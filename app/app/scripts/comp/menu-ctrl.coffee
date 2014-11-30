'use strict'

angular.module('genApp').controller 'MenuCtrl', ($location, $scope) ->
	$scope.setAll = () ->
		$scope.classLang = ''
		$scope.classSettings = ''
		$scope.classFaq = ''

	$scope.setActive = () ->
		if $location.path() is "/languages"
			$scope.setAll()
			$scope.classLang = 'active'
		if $location.path() is "/settings"
			$scope.setAll()
			$scope.classSettings = 'active'
		if $location.path() is "/faq"
			$scope.setAll()
			$scope.classFaq = 'active'

	$scope.$on '$routeChangeStart', (next, current) ->
	  $scope.setActive()

	$scope.setActive()
	