$(document).ready(function(){
  var applicantFormValidator = new FormValidator('applicant_form', [{
    name: 'applicant[first_name]',
    display: 'First Name',
    rules: 'required|min_length[2]'
  },{
    name: 'applicant[last_name]',
    display: 'Last Name',
    rules: 'required|min_length[2]'
  },{
    name: 'applicant[email]',
    display: "Email",
    rules: 'required|valid_email'
  },{
    name: 'applicant[zipcode]',
    display: 'Zipcode',
    rules: 'required|numeric|min_length[5]'
  },{
    name: 'applicant[cell]',
    display: 'Cell Phone Number',
    rules: 'required|min_length[10]|max_length[11]',
    depends: function(field){
      field.element.value = field.element.value.replace(/\D/g,'')
      return true
    }
  }],
  function(errors, event) {
    var $errors = $("#form_errors").hide();
    $errors.html("");
    if (errors.length > 0) {
      event.cancelBubble = true
      for(i=0;i<errors.length;i++){
        var error = $("<p>").html(errors[i].message);
        $errors.append(error);
      }
      $errors.show();
    }
  });
});
