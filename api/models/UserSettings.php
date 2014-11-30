<?php

namespace app\models;

use yii;
use app\models\Language;

class UserSettings{

	private $settings;
	private $documentation;

	public function generateDefault(){
		$langs = Language::find()->with('feeds')->all();
		$langsArray = [];
		$feeds = [];
		foreach ($langs as $l) {
			$langsArray[] = strtolower($l->name);
			$feeds[strtolower($l->name)] = [];
			foreach ($l->feeds as $feed) {
				if($feed->repository == 1) continue;
				$feeds[strtolower($l->name)][] = strtolower($feed->name);
			}
		}

		$s = [];
		$s['user_name']				= ['',			'Username, used for greeting'];
		$s['languages_following'] 	= [[],			'Array of ;anguages that are followed and show news in the newsreader', implode(',',$langsArray)];
		$s['reader_show_left_column']=[true, 		'Whether to show the left languages and feeds column in the reader', 'true,false'];
		$s['reader_show_repo']		= [true,		'Whether to show the right repositories column in the reader', 'true,false'];
		$s['reader_show_news']		= [true,		'Whether to show the middle news column in the reader', 'true,false'];
		$s['reader_show_login']		= [true,		'Whether to show the login/greeting box', 'true,false'];
		$s['reader_items_count']	= [20,			'The size of the block of items that are fetched each time', '[1..100]'];
		$s['reader_repo_count']		= [20,			'The number of trending repositories that should be shown', '[1..50]'];
		$s['reader_repo_timespan']	= ['weekly',	'What the timespan used to calculate the trending repositories (by github) should be', 'weekly,daily'];
		$s['editor_font_size'] 		= ['14px',		'Font size of the editor', 'css measure'];
		$s['editor_theme']			= ['ace/theme/monokai', 'Theme for the editor', 'ace/theme/monokai'];
		$s['overwrite_feeds']		= [true,	 	'Whether to overwrite all the feeds that are enabled for a certain language, once that language is reactivated from the GUI', 'true,false'];
		$s['editor_save_windows'] 	= ['Ctrl-S',	'Keybinding for windows that saves the settings in the editor'];
		$s['editor_save_mac'] 		= ['Command-S',	'Keybinding for mac that saves the settings in the editor'];
		foreach ($feeds as $lang => $feedList) {
			$s[$lang.'_feeds_enabled']=[[],			'Array of feeds that are enabled for the '.$lang.' language', implode(',', $feedList)];
		}
		$this->settings = $this->createSettings($s);
		$this->documentation = $this->createDocumentation($s);
	}

	private function createSettings($settings){
		$res = [];
		foreach ($settings as $var => $value) {
			$res[$var] = $value[0];
		}
		return $res;
	}

	private function createDocumentation($settings){
		$res = [];
		foreach ($settings as $var => $value) {
			if(!isset($value[2]))
				$value[2] = '';
			$res[$var]['default'] = $value[0];
			$res[$var]['comment'] = $value[1];
			$res[$var]['options'] = $value[2];
		}
		return $res;
	}

	public function getDefaultSettings(){
		return $this->settings;
	}

	public function getDocumentation(){
		return $this->documentation;
	}

	public function validateSettings($settings){
		// TODO implement this
		return $settings;
	}
}