<?php

namespace app\controllers;

use yii;
use yii\web\Controller;
use app\models\LoginForm;
use app\models\Language;
use app\models\Feed;
use app\models\Item;
use app\models\ItemInteraction;
use app\models\User;

class ApiController extends Controller{
	public $enableCsrfValidation = false;
	public function behaviors()
    {
        return [
            'verbs' => [
                'class' => yii\filters\VerbFilter::className(),
                'actions' => [
                    'repos' => ['post','get'],
                    'news' => ['post','get'],
                    'item_interaction' => ['post'],
                    'save_settings' => ['post'],
                ],
            ],
        ];
    }

	/**
	 * Returns all the available languages from the database
	 * @param  boolean $withFeeds [description]
	 * @return [type]             [description]
	 */
	public function actionLanguages($with_feeds = false){
		if($with_feeds){
			$l = Language::find()->joinWith('feeds')->orderBy('score DESC')->asArray()->all();
			foreach ($l as $a => $lang) {
				foreach ($lang['feeds'] as $b => $feed) {
					if($feed['repository'] != 0){
						unset($l[$a]['feeds'][$b]);
					}else{
						$l[$a]['feeds'][$b] = $feed['name'];						
					}
				}
				sort($l[$a]['feeds']);
			}
		}else{
			$l = Language::find()->asArray()->orderBy('score DESC')->all();
		}
		foreach ($l as &$lang) {
			$lang['img'] = \yii\helpers\BaseUrl::base(true)."/img/".$lang['img'];
		}
		$this->_sendResponse($l);
	}

	/**
	 * Returns languages and their feeds
	 * @param  str $languages comma seperated string of languages
	 * @return arr           [description]
	 */
	public function actionFeeds($languages){
		$f = [];
		if(is_string($languages)){
			$languages = explode(",", $languages);
			$l = Language::find();
			foreach ($languages as $lang) {
				$l = $l->orWhere(['name' => $lang]);
			}
			$l = $l->with('feeds')->asArray()->all();
			$this->_sendResponse($l);
		}else{
			$this->_sendResponse("Parameter 'languages' has to be set", 418);
		}
	}

	public function actionNews($auth_key = null, $page=0){
		$settings = [];
		if($auth_key !== null && $auth_key != false){
			$u = User::findIdentityByAccessToken($auth_key);
			if($u === null){
				$this->_sendResponse("User couldnt be found.", 418);
			}
			$settings = $u->getSettings();
		}else{
			if(!isset($_POST['settings']))
				$this->_sendResponse("Settings couldnt be found: either send them in post or provide a user auth_key", 418);
			$sObject = new \app\models\UserSettings;
			$settings = $sObject->validateSettings($_POST['settings']);
		}
		$following = [];
		if(!is_array($settings['languages_following'])){
			$this->_sendResponse("Not following any languages yet", 418);
		}
		foreach ($settings['languages_following'] as $l) {
			$following[] = strtolower($l);
		}
		// get all enabled feeds from settings
		$feedUrls = [];
		foreach ($settings as $key => $value) {
			if(strpos($key, "_feeds_enabled") > -1 
				&& in_array(str_replace("_feeds_enabled", '', $key), $following)){
				$feedUrls = array_merge($value, $feedUrls);
			}
		}
		$items = Item::find()->innerJoinWith(['feed', 'feed.language'])->where(['in', 'feed.name', $feedUrls])->limit($settings['reader_items_count'])->offset($page*$settings['reader_items_count'])->orderBy('date DESC')->asArray()->all();
		foreach ($items as &$i) {
			$i['language'] = $i['feed']['language']['name'];
			$i['feed_name'] = $i['feed']['name'];
			unset($i['feed']);
			unset($i['feed_id']);
			unset($i['rank']);
		}
		$this->_sendResponse($items);
	}

	public function actionRepos($auth_key = null){
		$settings = [];
		if($auth_key != null && $auth_key != false){
			$u = User::findIdentityByAccessToken($auth_key);
			if($u === null){
				$this->_sendResponse("User couldnt be found.", 418);
			}
			$sObject = new \app\models\UserSettings;
			$settings = $sObject->validateSettings($u->getSettings());
		}else{
			if(!isset($_POST['settings']))
				$this->_sendResponse("Settings couldnt be found: either send them in post or provide a user auth_key", 418);
			$sObject = new \app\models\UserSettings;
			$settings = $sObject->validateSettings($_POST['settings']);
		}
		if(!is_array($settings['languages_following'])){
			$this->_sendResponse("Not following any languages yet", 418);
		}
		$wheres = [];
		foreach ($settings['languages_following'] as $lang) {
			$wheres[] = 'language.name = "'.$lang.'"';
		}
		$where = '('.implode(' OR ', $wheres).")";
		$langs = \app\models\Language::find()->where($where)->all();
        $items = [];
        foreach ($langs as $i => $lang) {
        	if($i%2!=0)
	            $limit = ceil($settings['reader_repo_count']/count($langs));
	       	else
	            $limit = floor($settings['reader_repo_count']/count($langs));
            $new_items = \app\models\Item::find()->where(['feed.language_id' => $lang->id, 'feed.repository' => 1])->innerJoinWith('feed')->orderBy('item.date DESC,item.rank ASC');
            if($settings['reader_repo_timespan'] == 'weekly'){
            	$new_items = $new_items->andWhere(['feed.fetch_minutes' => 300]);
            }else{
            	$new_items = $new_items->andWhere(['feed.fetch_minutes' => 60]);
            }
            $new_items = $new_items->all();
            $new_items = array_slice($new_items, 0, $limit);
            $items = array_merge_recursive($items, $new_items);
        }
        $items = array_splice($items, 0, $settings['reader_repo_count']);
		$this->_sendResponse($items);
	}

	public function actionSettings_default(){
		$d = new \app\models\UserSettings;
		$d->generateDefault();
		$this->_sendResponse($d->getDefaultSettings());
	}

	public function actionSettings_docs(){
		$d = new \app\models\UserSettings;
		$d->generateDefault();
		$this->_sendResponse($d->getDocumentation());
	}

	public function actionCron()
	{
		// prevent db from overflowing
		\app\models\Item::deleteAll('date < '.(time() - 60*60*24*7));
		$feeds = Feed::find()->all();
		foreach ($feeds as $feed) {
			if(($feed->last_fetch + $feed->fetch_minutes*60) < time()){
				// this is an ugly hack, but makes sure every feed is fetched seperately, without blocking the rest if it fails
				try {
					$link = yii\helpers\BaseUrl::base(true);
					@file_get_contents($link."/api/fetch?id=".$feed->id);
				} catch (Exception $e) {
					echo $e;
				}
			}
		}
	}

	public function actionFetch($id){
		$feed = Feed::findOne($id);
		$feed->fetch();
	}

	public function actionLogin($email, $password){
		$u = User::find()->where(['email' => $email])->one();
		if($u === null){
			$this->_sendResponse("Email adress couldn't be found.", 418);
		}
		if($u->validatePassword($password)){
			unset($u->password_hash);
			$this->_sendResponse($u);
		}else{
			sleep(2);
			$this->_sendResponse("The provided password is not correct.", 418);
		}
	}

	public function actionRegister($email, $password){
		$u = User::find()->where(['email' => $email])->one();
		if($u !== null){
			$this->_sendResponse("Email is already used, please login instead of registering.", 418);
		}
		$u = new User;
		$u->email = $email;
		$u->setPassword($password);
		$u->generateAuthKey();
		if(!$u->save()){
			$this->_sendResponse("Email isn't valid: don't be scared, I won't contact you.", 418);
		}
		unset($u->password_hash);
		$this->_sendResponse($u);
	}

	public function actionSave_settings($auth_key){
		if($auth_key == false)
			$this->_sendResponse("Auth key cant be false", 418);
		$u = User::findIdentityByAccessToken($auth_key);
		if($u == null)
			$this->_sendResponse("User couldnt be found.", 418);
		if(!is_string($_POST['settings']))
			$_POST['settings'] = json_encode($_POST['settings']);
		$u->settings = $_POST['settings'];
		if($u->save()){
			$this->_sendResponse(true);
		}else{
			$this->_sendResponse($u->getErrors(), 418);
		}
	}

	public function actionSettings($auth_key){
		if($auth_key == false)
			$this->_sendResponse("Auth key cant be false", 418);
		$u = User::findIdentityByAccessToken($auth_key);
		if($u == null)
			$this->_sendResponse("User couldnt be found.", 418);
		$this->_sendResponse($u->settings);
	}

	public function actionItem_interaction($auth_key = false){
		if(!isset($_POST['value']) || !isset($_POST['item_id']))
			$this->_sendResponse("value and item_id should be posted", 418);
		$i = new ItemInteraction;
		if($auth_key != false){
			$user = User::findIdentityByAccessToken($auth_key);
			$i->user_id = $user->id;
		}
		$i->value = $_POST['value'];
		$i->item_id = $_POST['item_id'];
		$i->timestamp = time();
		$i->save();

		$item = Item::findOne($item_id);
		$item->score += $value;
		$item->save();
	}

	private function _sendResponse($message, $statusCode = 200){
		$res = [];
		if($statusCode !== 200){
			http_response_code($statusCode);
			$res = ['error' => ['message' => $message, 'errorCode' => $statusCode]];
		}else{
			$res = $message;
		}
		echo yii\helpers\Json::encode(($res));
		exit();
	}

}