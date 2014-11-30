'use strict'

angular.module('genApp').service "api", ($http, $q, $window) ->
	api = {}
	if document.location.hostname == "skikapp.com"
		api.baseUrl = 'http://api.skikapp.com/v1/'
	else
		api.baseUrl = 'http://localhost/project/wuw/api/web/v1/'

	api.get = (url) ->
		deferred = new $q.defer()
		if typeof url is "object"
			data = url
			data.url = api.baseUrl+url.url
		else
			data = {}
			data.url = api.baseUrl+url
		data.method = "GET"
		$http(data).then (res)->
			deferred.resolve(res.data)
		, (errorCode) ->
			if _.isUndefined(errorCode.data.error)
				sweetAlert("This is awkward...", "The API seems to be down. Nothing I can do here, sorry", "error")
				return false
			# this is something seriously offsync, so we need a full reset. Shouldn't happen at all
			if errorCode.data.error.message is 'User couldnt be found.'
				sweetAlert
					title: "This is awkward...",
					text: "I can't find your authentication key, which probably means something is screwed at le server. Please go here http://skikapp.com/#/reset and login again :)",
					type: "warning",
					showCancelButton: true,
					confirmButtonColor: "#DD6B55",
					closeOnConfirm: false
			deferred.reject (errorCode.data.error.message)

		return deferred.promise

	api.post = (url) ->
		deferred = new $q.defer()
		if typeof url is "object"
			data = url
			data.url = api.baseUrl+url.url
		else
			data = {}
			data.url = api.baseUrl+url
		data.method = "POST"
		$http(data).then (res)->
			deferred.resolve(res.data)
		, (errorCode) ->
			if _.isUndefined(errorCode.data.error)
				sweetAlert("This is awkward...", "The API seems to be down. Nothing I can do here, sorry", "error")
				return false
			# this is something seriously offsync, so we need a full reset. Shouldn't happen at all
			if errorCode.data.error.message is 'User couldnt be found.'
				sweetAlert
					title: "This is awkward...",
					text: "I can't find your authentication key, which probably means something is screwed at le server. Please go here http://skikapp.com/#/reset and login again :)",
					type: "warning",
					showCancelButton: true,
					confirmButtonColor: "#DD6B55",
					closeOnConfirm: false
			deferred.reject (errorCode.data.error.message)

		return deferred.promise

	
	return api
