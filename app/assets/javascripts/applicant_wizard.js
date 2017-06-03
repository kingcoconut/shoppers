$(document).ready(function(){
  $("#new_applicant").on("ajax:success", function(e, data){
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
      success: function(e, data){
        $(".step").hide();
        $("#step-3").show();
      },
      error: function(e,response,msg){
        alert("something bad happend...")
      }
    })
  })

  $("#background-decline").on("click", function(){
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
  })
});
