//= require jquery
//= require jquery_ujs
//= require underscore
//= require backbone
//= require backbone.radio
//= require marionette
//= require moment
//= require semantic.min
//= require calendar.min
// App = {
//   Models: {},
//   Views: {}
// }

// App.Models.ApplicantGroups = Backbone.

var ApplicantGroup = Backbone.Model.extend({

})

var ApplicantGroupsCollection = Backbone.Collection.extend({
  model: ApplicantGroup,
  url: "/v2/funnels.json"
})

var SearchView = Mn.View.extend({
  tagName: "div",
  className: "searchBar",
  template: "#search-template",
  events: {
    "click #search": "search",
  },
  onRender: function(){
    setTimeout(function(){
      $("#start_date, #end_date").calendar({type: "date"});
    },200)
  },
  search: function(event){
    var start_date = this.$el.find("#start_date input").val();
    var end_date = this.$el.find("#end_date input").val();
    if(start_date != "" && end_date != ""){
      this.collection.fetch({data:{
        start_date: moment(start_date).format("YYYY-MM-DD"),
        end_date: moment(end_date).format("YYYY-MM-DD")
      }});
    }
  }
})

var ApplicantGroupView = Mn.View.extend({
  tagName: "tr",
  template: "#applicant-group"
})

var ApplicantGroupsView = Mn.CompositeView.extend({
  template: "#applicant-groups-table",
  childView: ApplicantGroupView,
  childViewContainer: 'tbody'
})

var LayoutView = Mn.View.extend({
  template: "#main-layout",
  regions: {
    search: "#search",
    table: "#table"
  },
  onRender: function(){
    this.getRegion("search").show(new SearchView({collection: App.applicantGroups}));
    this.getRegion("table").show(new ApplicantGroupsView({collection: App.applicantGroups}));
  }
});

var application = Mn.Application.extend({
  region: '#main',

  onStart: function() {
    App.applicantGroups = new ApplicantGroupsCollection();
    App.applicantGroups.fetch({data: {start_date: moment().subtract(6, 'months').format("YYYY-MM-DD"), end_date: moment().format("YYYY-MM-DD")}});
    var main = this.getRegion();
    main.show(new LayoutView());
  }
});

_.templateSettings = {
  interpolate: /\{\{\=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g
};

$(document).ready(function(){
  window.App = new application();
  App.start();

  $("#example_1").calendar({type: 'date'});
})
