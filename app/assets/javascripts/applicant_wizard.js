$(document).ready(function(){
  $("#new_applicant").on("ajax:success", function(e, data){
    window.applicant = data.applicant
    if (typeof(Storage) !== "undefined") {
      localStorage.setItem("applicant", JSON.stringify(data.applicant))
    }
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
  })

  $("#background-accept").on("click", function(){
    $.ajax({
      url: "/applicant",
      data: {applicant: {background_consent: true}},
      method: "PUT",
      success: function(data){
        if (typeof(Storage) !== "undefined") {
          localStorage.setItem("applicant", JSON.stringify(data.applicant))
        }
      }
    });
    // don't wait for response
    $(".step").hide();
    $("#step-3").show();
  })

  $("#background-decline").on("click", function(){
    $.ajax({
      url: "/applicant",
      data: {applicant: {background_consent: false}},
      method: "PUT",
      success: function(data){
        if (typeof(Storage) !== "undefined") {
          localStorage.setItem("applicant", JSON.stringify(data.applicant))
        }
      }
    })
    // don't wait for response
    $(".step").hide();
    $("#step-5").show();
  })

  $("#background-back").on("click", function(){
    $(".step").hide();
    $("#step-2").show();
  })

  $("#application-complete").on("click", function(){
    $(".step").hide();
    $("#step-4").show();
  })
  $("#complete-back").on("click", function(){
    $(".step").hide();
    $("#step-3").show();
  });

  // This is how we determine what state/page to display the user
  if (typeof(Storage) !== "undefined") {
    window.applicant = localStorage.getItem("applicant")
    if(applicant){
      $("#step-1").hide();
      applicant = JSON.parse(applicant);

      // the user may have cleared there cookies but not their localStorage
      establishSession(applicant.id, applicant.email)
      if(applicant.background_consent !== null){
        if(applicant.background_consent){
          $("#step-3.step").show();
        }else{
          $("#step-5.step").show();
        }
      }else{
        // no background check consent yet
        $("#step-2.step").show();
      }
    }else{
      $("#step-1.step").show();
    }
  }else{
    $("#step-1.step").show();
  }

  // We need to restablish the applicant session incase the user
  // has cleared their cookies but not their localstorage
  function establishSession(id, email){
    $.ajax({
      url: "applicant/session",
      method: "POST",
      data: {
        id: id,
        email: email
      }
    });
  }
});
