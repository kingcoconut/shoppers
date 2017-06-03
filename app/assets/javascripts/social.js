function onLinkedInLoad() {
  IN.Event.on(IN, "auth", getProfileData);
}

// Handle the successful return from the API call
function onSuccess(data) {
  $.ajax({
    url: "/linkedin_accounts",
    method: "POST",
    data: {account: data.values[0]},
    success: function(e, data){

    },
    error: function(e, response, msg){

    }
  })
  console.log(data);
}

// Handle an error response from the API call
function onError(error) {
  console.log(error);
}

// Use the API call wrapper to request the member's basic profile data
function getProfileData() {
  IN.API.Profile("me").fields("id", "first_name", "last_name", "num-connections", "email-address", "industry", "location", "picture-url", "public-profile-url").result(onSuccess).error(onError);
}
