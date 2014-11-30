<?php

namespace app\models;

use yii;
use Zend\Feed\Reader\Reader;
use app\models\Item;

/**
 * This is the model class for table "feed".
 *
 * @property integer $id
 * @property string $name
 * @property string $url
 * @property integer $language_filter
 * @property integer $language_id
 *
 * @property Language $language
 */
class Feed extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'feed';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['repository', 'language_id', 'last_fetch', 'fetch_minutes', 'score'], 'integer'],
            [['name'], 'string', 'max' => 256],
            [['url'], 'string', 'max' => 512]
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'name' => 'Name',
            'url' => 'Url',
            'language_id' => 'Language ID',
            'repository' => 'Language ID',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getLanguage()
    {
        return $this->hasOne(Language::className(), ['id' => 'language_id']);
    }

    public function getItems()
    {
        return $this->hasMany(Item::className(), ['feed_id' => 'id']);
    }

    public function fetch(){
        try {
            $feed = Reader::import($this->url);
        } catch (Exception $e) {
            return false;
        }   
        $rank = 0;
        foreach ($feed as $entry) {
            $n = Item::find()->where(["link" => $entry->getLink(), 'feed_id' => $this->id])->one();
            if($n !== null){
                if($n->date == $entry->getDateModified()->getTimestamp()) continue;
            }else{
                $n = new Item;
            }
            if($this->repository == 1){
                $n->title = explode(" (", $entry->getTitle())[0];
                $n->rank = $rank;
                $rank++;
            }else{
                $n->title = $entry->getTitle();
            }
            $authors = '';
            if(is_array($entry->getAuthors())){
                foreach ($entry->getAuthors() as $author) {
                    $authors .= $author['name'].' ';
                }
            }
            // prefer content over description
            if($entry->getDescription() !== $entry->getContent())
                $n->description = $entry->getDescription();
            $date = $entry->getDateModified();
            if($date !== null){
                $date = $entry->getDateModified()->getTimestamp();
            }else{
                $date = time() - 1000;
            }
            $n->date = $date;
            $n->authors = $authors;
            $n->link = $entry->getLink();
            $n->content = $entry->getContent();
            $n->feed_id = $this->id;
            $n->save();
        }
        $this->last_fetch = time();
        $this->save();
    }
}
