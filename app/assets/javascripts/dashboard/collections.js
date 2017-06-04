var ApplicantGroupsCollection = Backbone.Collection.extend({
  model: ApplicantGroup,
  url: "/v2/funnels.json"
})

var ApplicantsCollection = Backbone.Collection.extend({
  model: Applicant,
  url: "/v2/applicants.json"
});
