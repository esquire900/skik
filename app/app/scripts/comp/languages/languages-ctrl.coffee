'use strict'

angular.module('genApp').controller 'LanguagesCtrl', ($scope, $http, api, User, Initializer) ->
	settings = {}
	_allLanguages = []
	Initializer.init().then () ->
		User.getSettings().then (s) ->
			settings = s
			$scope.selectedLanguages = settings.languages_following
			$scope.$apply() if !$scope.$$phase

			api.get('languages?with_feeds=true').then (res) ->
				_allLanguages = res
				$scope.languages = []
				row = []
				for i in res
					if row.length < 6
						row.push(i)
					else
						$scope.languages.push(row)
						row = []
				$scope.$apply() if !$scope.$$phase

	$scope.click = (lang) ->
		index = settings.languages_following.indexOf(lang)
		if index isnt -1
			settings.languages_following.splice(index, 1)
		else
			settings.languages_following.push(lang)
			for l in _allLanguages
				if l.name is lang 
					if settings[lang.toLowerCase()+"_feeds_enabled"].length is 0 or settings.overwrite_feeds is true
						settings[lang.toLowerCase()+"_feeds_enabled"] = l.feeds
						User.setSettings(settings).then () ->
							User.getAuthKey().then (key) ->
								if key isnt false
									User.saveServerSettings()
						return true
		User.setSettings(settings).then () ->
			User.getAuthKey().then (key) ->
				if key isnt false
					User.saveServerSettings()

