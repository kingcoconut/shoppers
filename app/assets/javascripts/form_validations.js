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
    rules: 'required|exact_length[10]',
    depends: function(field){
      field.element.value = field.element.value.replace(/\D/g,'')
      return true
    }
  }],
  function(errors, event) {
    var $errors = $("#form_errors");
    $errors.html("");
    if (errors.length > 0) {
      event.cancelBubble = true
      for(i=0;i<errors.length;i++){
        var error = $("<p>").html(errors[i].message);
        $errors.append(error);
      }
    }
  });
  applicantFormValidator.setMessage("exact_length", "%s must be a valid US number")
});
