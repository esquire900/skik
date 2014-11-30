<?php

namespace app\controllers;

use yii;
use yii\filters\AccessControl;
use yii\web\Controller;
use yii\filters\VerbFilter;
use app\models\LoginForm;
use app\models\User;
use app\models\Feed;
use app\models\UserHasFeed;

class SiteController extends Controller
{
    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'only' => ['logout'],
                'rules' => [
                    [
                        'actions' => ['logout'],
                        'allow' => true,
                        'roles' => ['@'],
                    ],
                ],
            ],
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'logout' => ['post'],
                ],
            ],
        ];
    }

    // public function successCallback($client)
    // {
    //     $attributes = $client->getUserAttributes();
    //     $name = '';
    //     $email = '';
    //     if(isset($attributes['first_name']) && isset($attributes['last_name'])){
    //         $name = $attributes['first_name'].$attributes['last_name'];
    //         $email = $attributes['email'];
    //     }
    //     if($client->id == "twitter"){
    //         $name = $attributes['screen_name'];
    //     }
    //     $u = User::find()->where(['username' => $name, 'type' => $client->id])->one();
    //     if($u == null){
    //         $u = new User;
    //         $u->username = $name;
    //         $u->setPassword('8hc2cnbp29bv24v24v9274v24v9'.$u->username);
    //         $u->generateAuthKey();
    //         $u->type =  $client->id;
    //         $u->save();

    //         $f = new Feed;
    //         $f->type = $client->id;
    //         $f->oauth_user_key = json_encode($client->getAccessToken()->getParams());
    //         $f->name = $client->id.' Feed';
    //         if(!$f->save()){
    //             yii\helpers\VarDumper::dump($f->getErrors(), 10, true); exit();
    //         }

    //         $uhf = new UserHasFeed;
    //         $uhf->user_id = $u->id;
    //         $uhf->feed_id = $f->id;
    //         $uhf->save();
    //     }

    //     // log user in
    //     $model = new LoginForm();
    //     $model->username = $u->username;
    //     $model->password = '8hc2cnbp29bv24v24v9274v24v9'.$u->username;
    //     $model->login();

    //     // yii\helpers\VarDumper::dump($client->api('user.json', 'GET'), 10, true); exit();
    //     // user login or signup comes here
    // }

    public function actions()
    {
        return [
            'error' => [
                'class' => 'yii\web\ErrorAction',
            ],
            'auth' => [
                'class' => 'yii\authclient\AuthAction',
                'successCallback' => [$this, 'successCallback'],
            ],
        ];
    }

    public function actionIndex()
    {
        return $this->render('index');
    }

    // public function actionLogin()
    // {
    //     if (!\Yii::$app->user->isGuest) {
    //         return $this->goHome();
    //     }

    //     $model = new LoginForm();
    //     if ($model->load(Yii::$app->request->post()) && $model->login()) {
    //         return $this->goBack();
    //     } else {
    //         return $this->render('login', [
    //             'model' => $model,
    //         ]);
    //     }
    // }

    // public function actionLogout()
    // {
    //     Yii::$app->user->logout();
    //     return $this->goHome();
    // }

    // public function actionTest(){
    //     $langs = \app\models\Language::find()->where(['name' => 'php'])->all();
    //     $items = [];
    //     foreach ($langs as $lang) {
    //         $limit = round($settings['reader_repo_count']/count($langs));
    //         $new_items = \app\models\Item::find()->where(['feed.language_id' => $lang->id, 'feed.repository' => '2'])->innerJoinWith('feed')->orderBy('item.date DESC,item.rank ASC')->all();
    //     }
    //     return $this->render('index');
    // }
}
