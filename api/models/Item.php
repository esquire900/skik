<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "item".
 *
 * @property integer $id
 * @property string $link
 * @property string $content
 * @property string $authors
 * @property string $description
 * @property integer $date
 * @property integer $feed_id
 *
 * @property Feed $feed
 */
class Item extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'item';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['link', 'date', 'feed_id', 'title'], 'required'],
            [['content', 'description', 'title'], 'string'],
            [['date', 'feed_id', 'score', 'rank'], 'integer'],
            [['link', 'authors'], 'string', 'max' => 512]
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'link' => 'Link',
            'content' => 'Content',
            'authors' => 'Authors',
            'description' => 'Description',
            'date' => 'Date',
            'feed_id' => 'Feed ID',
            'title' => 'Title',
            'score' => 'Score',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getFeed()
    {
        return $this->hasOne(Feed::className(), ['id' => 'feed_id']);
    }
}
