var ApplicantGroup = Backbone.Model.extend({
  defaults: {
    applied: 0,
    quiz_started: 0,
    quiz_completed: 0,
    onboarding_requested: 0,
    onboarding_completed: 0,
    hired: 0,
    rejected: 0
  }
})

var Applicant = Backbone.Model.extend({
  defaults: {
    first_name: "",
    last_name: "",
    industry: "",
    location: "",
    num_connections: "",
    picture_url: "",
    public_profile_url: ""
  }
});
