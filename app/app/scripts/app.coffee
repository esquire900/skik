'use strict'

angular.module('genApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ngScrollTo'
])
.config( ($routeProvider) ->
  $routeProvider
    .when('/home', {
      templateUrl: 'scripts/comp/home/home.html',
      controller: 'HomeCtrl',
    })
    .when('/languages', {
      templateUrl: 'scripts/comp/languages/languages.html',
      controller: 'LanguagesCtrl'
    }) 
    .when('/settings', {
      templateUrl: 'scripts/comp/settings/settings.html',
      controller: 'SettingsCtrl'
    }) 
    .when('/faq', {
      templateUrl: 'scripts/comp/faq/faq.html',
    })
    .when('/reset', {
      templateUrl: 'scripts/comp/faq/faq.html',
      controller: 'ResetCtrl'
    })
    .otherwise({
      redirectTo: '/home'
    })
)
.service 'Initializer', ($q, User) ->
  is_initialized = false
  resolver = () ->
    deferred = new $q.defer()
    if is_initialized is false
      User.getAuthKey().then (auth_key) ->
        if auth_key is false
          # user doesn't have a key yet: is not logged in
          User.getSettings().then (settings) ->
            if settings is false
              User.getDefaultSettings().then (dSettings) ->
                User.setSettings(dSettings).then () ->
                  is_initialized = true
                  deferred.resolve(true)
            else
              is_initialized = true
              deferred.resolve(true)
        else
          # user is logged in
          User.getSettings().then (settings) ->
            is_initialized = true
            deferred.resolve(true)
    else
      deferred.resolve(true)
    return deferred.promise
  return {
    init: resolver
  }