'use strict'

angular.module('genApp').controller 'ResetCtrl', (User, $window, $location) ->
	User.destroy().then ()->
		setTimeout () ->
			$window.location.reload()
		, 500
		$location.path('/')
