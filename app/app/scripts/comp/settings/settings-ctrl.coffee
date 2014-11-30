'use strict'

angular.module('genApp').controller 'SettingsCtrl', ($scope, $http, api, User, Initializer) ->
	settings = {}
	_docs = {}
	$scope.isSaved = true
	Initializer.init().then () ->
		User.getSettings().then (s) ->
			settings = s
			applySettings()
			editor.gotoLine(1,1)
		api.get('settings_docs').then (d) ->
			_docs = d
			$scope.docs = d
			applySettings
		
	editor = {}
	editor = ace.edit("editor")
	setHeight = () ->
		$("#editor").height(Math.max($(document).height(), $(window).height()) - 70)
		$(".documentation").height(Math.max($(document).height(), $(window).height()) - 70)
	setHeight()
	window.addEventListener("resize", setHeight())
	setTextFirstTime = true

	setTimeout () ->
		$scope.isSaved = true
		$scope.$apply() if !$scope.$$phase
	, 500

	applySettings = () ->
		editor.setTheme(settings.editor_theme)
		editor.setFontSize(settings.editor_font_size)
		editor.getSession().setMode("ace/mode/json")
		editor.commands.addCommand(
			name: 'saveCommand',
			bindKey: {win: settings.editor_save_windows,  mac: settings.editor_save_mac},
			exec: (editor) ->
				settings_new = editor.getValue()
				try
					JSON.parse(settings_new)
				catch e
					return false
					# not valid json
				
				settings = JSON.parse(settings_new)
				User.setSettings(settings).then () ->
					User.getAuthKey().then (res) ->
						if res isnt false
							User.saveServerSettings()
					applySettings()
					$scope.isSaved = true
		)
		editor.on("change", () ->
			$scope.isSaved = false
			$scope.$apply() if !$scope.$$phase
		)
		if setTextFirstTime
			setTextFirstTime = false
			editor.setValue(JSON.stringify(settings,null, "\t"))

	# angular gave some trouble here, so made a custom filter
	$scope.setFilter = (query) ->
		$scope.docs = {}
		for i, name of _docs
			if i.indexOf(query) > -1
				$scope.docs[i] = name
		$scope.$apply() if !$scope.$$phase