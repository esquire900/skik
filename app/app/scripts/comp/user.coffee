'use strict';

angular.module('genApp').service 'User', ($q, api) ->
	obj = {}
	db = new PouchDB('geek_challange_user_11315g3426123')
	_default_cache = false
	is_initialized = false

	obj.destroy = () ->
		deferred = new $q.defer()
		db.destroy().then () ->
			deferred.resolve(true)
		return deferred.promise
		
	getUserObject = () ->
		deferred = new $q.defer()
		db.get('user').then (doc) ->
			if _.isUndefined doc.auth_key
				db.put
					_id: 'user',
					auth_key: false,
					settings: false
				.then (doc) ->
					deferred.resolve(doc)
			else
				deferred.resolve(doc)
		, (err) ->
			if(err)
				db.put
					_id: 'user',
					auth_key: false,
					settings: false
				.then (doc2) ->
					deferred.resolve(doc2)
		return deferred.promise

	obj.getAuthKey = () ->
		deferred = new $q.defer()
		getUserObject().then (doc) ->
			if _.isUndefined(doc.auth_key)
				doc.auth_key = false
			deferred.resolve(doc.auth_key)
		return deferred.promise

	obj.setAuthKey = (key) ->
		deferred = new $q.defer()
		getUserObject().then (doc) ->
			db.put 
				_id: 'user',
				_rev: doc._rev,
				auth_key: key
				settings: doc.settings
			.then () ->
				deferred.resolve(true)
		return deferred.promise

	obj.getSettings = () ->
		deferred = new $q.defer()
		getUserObject().then (doc) ->
			deferred.resolve(doc.settings)
		return deferred.promise

	obj.setSettings = (settings) ->
		newSettings = {}
		try
			newSettings = JSON.parse(settings)
		catch e
			newSettings = settings
		
		settings = newSettings

		deferred = new $q.defer()
		getUserObject().then (doc) ->
			db.put 
				_id: 'user',
				_rev: doc._rev,
				settings: settings
				auth_key: doc.auth_key
			.then () ->
				deferred.resolve(true)
		return deferred.promise

	obj.getDefaultSettings = () ->
		deferred = new $q.defer()
		if _default_cache isnt false
			deferred.resolve(_default_cache)
		else
			api.get('settings_default').then (settings) ->
				_default_cache = settings
				deferred.resolve(_default_cache)
		return deferred.promise

	obj.getServerSettings = () ->
		deferred = new $q.defer()
		obj.getAuthKey().then (auth_key) ->
			if auth_key is false
				deferred.resolve(false)
			api.get
				url: 'settings?auth_key='+auth_key
			.then (res) ->
				settings = {}
				try
					settings = JSON.parse(res)
				catch e
					settings = res

				deferred.resolve(settings)
		return deferred.promise

	obj.saveServerSettings = () ->
		deferred = new $q.defer()
		obj.getAuthKey().then (auth_key) ->
			if auth_key is false
				deferred.resolve(false)
			obj.getSettings().then (settings) ->
				api.post
					url: 'save_settings?auth_key='+auth_key
					data: $.param({settings: JSON.stringify(settings)})
					headers: {'Content-Type': 'application/x-www-form-urlencoded'} 
				.then (res) ->
					deferred.resolve(true)
		return deferred.promise

	# returns a valid setting
	obj.valSetting = (attribute, settings) ->
		if settings.indexOf(attribute) > -1
			return settings[attribute]
		else
			return _default_cache[attribute]

	return obj