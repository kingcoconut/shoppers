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
  template: "#applicant-group",
  events: {
    "click": "fetch"
  },
  fetch: function(){
    var path = "/applicants/" + this.model.get("week_start") + "/" + this.model.get("week_end");
    Backbone.history.navigate(path, {trigger: true});
  }
})

var ApplicantGroupsView = Mn.CompositeView.extend({
  template: "#applicant-groups-table",
  childView: ApplicantGroupView,
  childViewContainer: 'tbody'
})

var ApplicantView = Mn.View.extend({
  tagName: "tr",
  template: "#applicant-template",
  events: {
    "click .linkedin": "showLinkedin"
  },
  showLinkedin: function(){
    $(".linkedin-modal").remove();
    var $modal = _.template($("#linkedin-modal-template").html())(this.model.get("linkedin_account"));
    $("body").append($modal);
    $(".ui.modal.linkedin-modal").modal("show");
  }
})

var ApplicantsTableView = Mn.CompositeView.extend({
  template: "#applicants-table",
  childView: ApplicantView,
  childViewContainer: 'tbody',
  events: {
    "click #back": "backNavigate"
  },
  backNavigate: function(){
    Backbone.history.navigate("grouped", {trigger:true});
  },
  onRender: function(){
    // bad hack :(
    setTimeout(function(){
      $("#applicants-table").DataTable({pageLength: 100});
    },500);
  }
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
