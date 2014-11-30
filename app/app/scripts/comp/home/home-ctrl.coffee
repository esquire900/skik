'use strict'

angular.module('genApp').controller 'HomeCtrl', ($scope, $http, api, User, Initializer, $sce, $window, ScrollTo, $location) ->
	$scope.trees = []
	$scope.userIsNew = false
	$scope.settings = false
	$scope.openedArticles = {}
	$scope.userLoggedIn = false
	$scope.loginBtnText = 'Login'
	$scope.loginLabelText = 'register'
	$scope.lastPage = 0
	$scope.news = false
	$scope.loginError = false
	$scope.loginErrorStart = false
	$scope.loadingLogin = false
	$scope.rand = Math.floor((Math.random() * 7) + 1)
	_tmp_repo_rows = false
	_is_initialized = false

	init = () ->
		if _is_initialized
			return true
		$scope.loading = true
		Initializer.init().then () ->
			User.getSettings().then (settings) ->
				$scope.settings = settings
				$scope.feedList = []
				$scope.languageNames = []
				api.get('languages?with_feeds=true').then (allFeeds) ->
					for lang, index in $scope.settings.languages_following
						for l in allFeeds
							if l.name.toLowerCase() is lang.toLowerCase() 
								$scope.feedList[index] = l.feeds
						$scope.languageNames[index] = lang
						$scope.trees[index] = true

				User.getAuthKey().then (key) ->
					if key is false and $scope.settings.languages_following.length is 0
						$scope.userIsNew = true
					if key is false
						$scope.userLoggedIn = false
					else
						$scope.userLoggedIn = true
					if !$scope.userIsNew
						fetchRepositories()
					$scope.loading = false
					$scope.$apply() if !$scope.$$phase
					_is_initialized = true

	fetchRepositories = (newsOnly) ->
		User.getAuthKey().then (key) ->
			User.getSettings().then (settings) ->
				$scope.settings = settings
				if settings.languages_following.length is 0
					$scope.notFollowingAnything = true
					$scope.$apply() if !$scope.$$phase
				else
					if key isnt false
						if newsOnly isnt true
							api.get('repos?auth_key='+key).then (res) ->
								_tmp_repo_rows = false
								$scope.repos = res
								$scope.$apply() if !$scope.$$phase
						api.get('news?auth_key='+key).then (res) ->
							prepareNews(res)
					else
						if newsOnly isnt true
							api.post
								url: 'repos'
								data: $.param({settings: settings})
								headers: {'Content-Type': 'application/x-www-form-urlencoded'} 
							.then (res) ->
								_tmp_repo_rows = false
								$scope.repos = res
								$scope.$apply() if !$scope.$$phase

						api.post
							url: 'news'
							data: $.param({settings: settings})
							headers: {'Content-Type': 'application/x-www-form-urlencoded'} 
						.then (res) ->
							prepareNews(res)

	prepareNews = (serverRes) ->
		for n, index in serverRes
			# prepare and trust content
			if _.isString serverRes[index].content
				serverRes[index].content = $sce.trustAsHtml(n.content)
				if n.content is ''
					serverRes[index].content = $sce.trustAsHtml(n.description)
				if n.content is ''
					serverRes[index].content = $sce.trustAsHtml("No content in rss feed found")
			# rewrite date into human readable stuff
			serverRes[index].date = moment(n.date, 'X').fromNow()

		if $scope.news is false
			$scope.news = serverRes
		else
			for i in serverRes
				$scope.news.push(i)
		$scope.$apply() if !$scope.$$phase

	$scope.isEnabled = (i, feedName) ->
		if $scope.settings[$scope.languageNames[i].toLowerCase()+"_feeds_enabled"].indexOf(feedName) > -1
			return true
		else
			return false

	$scope.switchEnabled = (i, feedName) ->
		if $scope.settings[$scope.languageNames[i].toLowerCase()+"_feeds_enabled"].indexOf(feedName) > -1
			$scope.settings[$scope.languageNames[i].toLowerCase()+"_feeds_enabled"].splice($scope.settings[$scope.languageNames[i].toLowerCase()+"_feeds_enabled"].indexOf(feedName), 1)
		else
			$scope.settings[$scope.languageNames[i].toLowerCase()+"_feeds_enabled"].push(feedName)
		$scope.news = false
		User.setSettings($scope.settings).then () ->
			User.getAuthKey().then (key) ->
				if key isnt false
					User.saveServerSettings().then () ->
						fetchRepositories(true)
				else
					fetchRepositories(true)

	$scope.isOpen = (id) ->
		if angular.isDefined($scope.openedArticles[id]) and $scope.openedArticles[id] is true
			return true
		else
			return false

	$scope.openArticle = (id) ->
		if angular.isUndefined($scope.openedArticles[id]) or $scope.openedArticles[id] is false and $scope.justClosed isnt true
			$scope.openedArticles[id] = true
			ScrollTo(id, 70)
	$scope.closeArticle = (id) ->
		if angular.isDefined($scope.openedArticles[id]) and $scope.openedArticles[id] is true
			$scope.openedArticles[id] = false
		$scope.justClosed = true
		setTimeout () ->
			$scope.justClosed = false
			$scope.$apply() if !$scope.$$phase
		, 30

	$scope.login = () ->
		$scope.loginError = false
		$scope.$apply() if !$scope.$$phase
		password = CryptoJS.SHA512($scope.password)
		email = $scope.email
		$scope.loadingLogin = true
		$scope.rand = Math.floor((Math.random() * 7) + 1)
		if $scope.loginBtnText is 'Login'
			api.get('login?email='+email+'&password='+password).then (res) ->
				User.setAuthKey(res.auth_key).then () ->
					User.getServerSettings().then (serverSet) ->
						User.setSettings(serverSet).then () ->					
							$scope.loadingLogin = false
							$window.location.reload()
							$scope.$apply() if !$scope.$$phase
					$scope.userLoggedIn = true
			, (errorMessage) ->
				$scope.loginError = errorMessage
				$scope.loadingLogin = false
				$scope.$apply() if !$scope.$$phase

		else
			api.get('register?email='+email+'&password='+password).then (res) ->
				User.setAuthKey(res.auth_key).then () ->
					User.saveServerSettings().then () ->
						$window.location.reload()
			, (errorMessage) ->
				$scope.loginError = errorMessage
				$scope.loadingLogin = false
				$scope.$apply() if !$scope.$$phase

	$scope.loginStart = () ->
		$scope.loginError = false
		password = CryptoJS.SHA512($scope.password)
		email = $scope.email
		$scope.loadingLogin = true
		$scope.rand = Math.floor((Math.random() * 7) + 1)
		api.get('login?email='+email+'&password='+password).then (res) ->
			User.setAuthKey(res.auth_key).then () ->
				User.getServerSettings().then (serverSet) ->
					User.setSettings(serverSet).then () ->				
						$scope.loadingLogin = false
						$window.location.reload()
						$scope.$apply() if !$scope.$$phase
				$scope.userLoggedIn = true
		, (errorMessage) ->
				$scope.loadingLogin = false
				$scope.loginErrorStart = errorMessage
				$scope.$apply() if !$scope.$$phase

	$scope.syncSettings = () ->
		User.getServerSettings().then (serverSet) ->
			User.setSettings(serverSet).then () ->
				$window.location.reload()

	$scope.setEmail = (email) ->
		$scope.email = email

	$scope.setPassword = (password) ->
		$scope.password = password

	$scope.switchLoginType = () ->
		if $scope.loginBtnText is 'Login'
			$scope.loginBtnText = 'Register'
			$scope.loginLabelText = 'login'
		else
			$scope.loginBtnText = 'Login'
			$scope.loginLabelText = 'register'

	$scope.logout = () ->
		User.destroy().then () ->
			$window.location.reload();

	$scope.loadMore = () ->
		$scope.lastPage++
		User.getAuthKey().then (key) ->
			if key isnt false
				api.get('news?auth_key='+key+'&page='+$scope.lastPage).then (res) ->
					prepareNews(res)
			else
				User.getSettings().then (settings) ->
					api.post
						url: 'news?page='+$scope.lastPage
						data: $.param({settings: settings})
						headers: {'Content-Type': 'application/x-www-form-urlencoded'} 
					.then (res) ->
						prepareNews(res)

	$scope.getRepoRows = () ->
		if _tmp_repo_rows isnt false
			return _tmp_repo_rows
		if _.isUndefined $scope.repos
			return []
		array = []
		tmpArray = []
		for i in $scope.repos
			if tmpArray.length <= 3
				tmpArray.push(i)
			else
				array.push(tmpArray)
				tmpArray = []
		_tmp_repo_rows = array
		return array
	init()