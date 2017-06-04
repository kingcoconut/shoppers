var App = {
  init: function(){
    this.checkLocalStorage();
    this.setupForm();
    this.setupButtons();
  },
  checkLocalStorage: function(){
    // This is how we determine what state/page to display the user
    applicant = this.getLocalApplicant()
    if(applicant){
      $("#step-1").hide();
      applicant = JSON.parse(applicant);

      // the user may have cleared there cookies but not their localStorage
      this.establishSession(applicant.id, applicant.email)
      if(applicant.background_consent !== null){
        (applicant.background_consent) ? $("#step-3").show() : $("#step-5").show();
      }else{
        // no background check consent yet
        $("#step-2").show();
      }
    }
  },
  setupForm: function(){
    var self = this;
    $("#new_applicant").on("ajax:success", function(e, data){
      self.saveLocalApplicant(data.applicant)
      $(".step").hide();
      $("#step-2").show();
    }).on("ajax:error", function(e, response, message){
      var errors = response.responseJSON.errors
      $("#form_errors").html("").hide()
      for (var key in errors) {
        var $p = $("<p>").html(key + " " + errors[key][0])
        $("#form_errors").append($p)
      }
      $("#form_errors").show();
    });
  },
  setupButtons: function(){
    $(".wizard-button").on("click", function(){
      $(".step").hide();
      var id = $(this).data('display');
      $(id).show();
    });
  },
  updateApplicant: function(data){
    var self = this;
    $.ajax({
      url: "/applicant",
      data: {applicant: data},
      method: "PUT",
      success: function(data){
        self.saveLocalApplicant(data.applicant);
      }
    });
  },
  saveLocalApplicant: function(applicant){
    if (typeof(Storage) !== "undefined") {
      localStorage.setItem("applicant", JSON.stringify(applicant))
    }
  },
  getLocalApplicant: function(){
    if (typeof(Storage) !== "undefined") {
      return localStorage.getItem("applicant")
    }
  },
  establishSession: function(id, email){
    $.ajax({
      url: "applicant/session",
      method: "POST",
      data: {
        id: id,
        email: email
      }
    });
  }
}

$(document).ready(function(){
  App.init();
});
