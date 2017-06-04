var Router = Backbone.Router.extend({
  routes: {
    'grouped': "grouped",
    'applicants/:start_date/:end_date': 'showApplicants'
  },
  grouped: function(){
    App.applicantGroups = App.applicantGroups || new ApplicantGroupsCollection();
    if(App.applicantGroups.length === 0){
      App.applicantGroups.fetch({data: {start_date: moment().subtract(1, 'months').format("YYYY-MM-DD"), end_date: moment().add(1, 'day').format("YYYY-MM-DD")}});
    }
    App.getRegion().show(new LayoutView());
  },
  showApplicants: function(start_date, end_date){
    App.applicants = App.applicants || new ApplicantsCollection();
    App.applicants.fetch({data: {start_date: start_date, end_date: end_date}});
    App.getRegion().show(new ApplicantsTableView({collection: App.applicants}))
  }
});
