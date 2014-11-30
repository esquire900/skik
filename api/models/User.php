<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;

/**
 * This is the model class for table "user".
 *
 * @property integer $id
 * @property string $email
 * @property string $password_hash
 * @property string $recovery_key
 * @property string $auth_key
 *
 * @property UserHasLanguage[] $userHasLanguages
 * @property Language[] $languages
 */
class User extends \yii\db\ActiveRecord implements IdentityInterface
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'user';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['email', 'password_hash'], 'required'],
            [['id'], 'integer'],
            [['email'], 'email'],
            [['email', 'password_hash', 'recovery_key', 'auth_key'], 'string', 'max' => 256],
            [['settings'], 'string']
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'email' => 'Email',
            'password_hash' => 'Password Hash',
            'recovery_key' => 'Recovery Key',
            'auth_key' => 'Auth Key',
            'settings' => 'Settings',
        ];
    }



    public function getSettings(){
        return \yii\helpers\Json::decode($this->settings);
    }
}
