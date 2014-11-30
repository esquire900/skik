<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "language".
 *
 * @property integer $id
 * @property string $name
 * @property string $img
 *
 * @property Feed[] $feeds
 * @property UserHasLanguage[] $userHasLanguages
 * @property User[] $users
 */
class Language extends \yii\db\ActiveRecord
{
    public $lfeeds;
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'language';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['name', 'img'], 'string', 'max' => 256]
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
            'img' => 'Img',
            'score' => "Score"
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getFeeds()
    {
        return $this->hasMany(Feed::className(), ['language_id' => 'id']);
    }

    public function afterFind(){
        $this->img = "http://".$_SERVER['SERVER_NAME'].Yii::getAlias('@web')."/img/".$this->img;
        return parent::afterFind();
    }
}
