//= require jquery
//= require jquery_ujs
//= require underscore
//= require backbone
//= require backbone.radio
//= require marionette
//= require moment
//= require dataTables.min
//= require dataTables.semantic.min
//= require semantic.min
//= require calendar.min
//= require ./dashboard/models
//= require ./dashboard/collections
//= require ./dashboard/views
//= require ./dashboard/router

var application = Mn.Application.extend({
  region: '#main',

  onStart: function() {
    App.router = new Router();
    Backbone.history.start();
    Backbone.history.navigate("grouped",{trigger:true});
  }
});

_.templateSettings = {
  interpolate: /\{\{\=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g
};

$(document).ready(function(){
  window.App = new application();
  App.start();
})
