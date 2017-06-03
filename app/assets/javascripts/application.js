// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require validate
//= require_tree .
$(document).ready(function(){
  $("#new_applicant").on("ajax:success", function(e, data){
    $(".step").hide();
    $("#step-2").show();
  }).on("ajax:error", function(e, response, message){
    var errors = response.responseJSON.errors
    $("#form_errors").html("")
    for (var key in errors) {
      var $p = $("<p>").html(key + " " + errors[key][0])
      $("#form_errors").append($p)
    }
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
    $("#step-4").show();
  })
});
