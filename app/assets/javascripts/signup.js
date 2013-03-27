$(function() {

  // Step 1 (Sign Up)
  $("button#signupButton").on("click", function() {
  	var username = $("input[type=text][name='user[username]']").val(); 
  	var email = $("input[type=text][name='user[email]']").val();
  	var password = $("input[type=password][name='user[password]']").val();
  	var password_confirmation = $("input[type=password][name='user[password_confirmation]']").val();
  	var input_variables = {};
  	
  	input_variables['user[username]'] = username;
  	input_variables['user[email]'] = email;
  	input_variables['user[password]'] = password;
  	input_variables['user[password_confirmation]'] = password_confirmation;
  	
  	var request = $.ajax({
	  url: "/users",
	  type: "POST",
	  data: input_variables,
	  dataType: "json"
	});
	
	request.done(function(msg, textStatus, jqXHR) {
	  $("#signup_step1").html("");
	  $("#signup_step1").hide();
	  $("#signup_step2").show();
	});
	 
	request.fail(function(jqXHR, textStatus) {
	  var error_string = "";

  	  var errors = $.parseJSON(jqXHR.responseText).errors;
  	  for (key in errors) {
  	  	error_string += "<li>" + errors[key] + "</li>" 
  	  }
  	  
  	  if(error_string != "") {
  	  	error_string = "<ul>" + error_string + "</ul>";
  	  }
  	  $("#error_explanation").html(error_string).show();
  	  
	});
  });
  
  // Step 2 (Subscribe to Feeds)
  $("button#feed_subscribe_button").on("click", function() {
  	str = "";
  	$(".pub-cat-hidden").each(function(index, object){
  		if(object.value.length > 0) {
  		    str += object.value + ",";
  		}
  	});
  	str = str.replace(/,$/g,''); //trim ',' on last string
  	
  	var request = $.ajax({
	  url: "/feed_subscribe",
	  type: "GET",
	  data: {pub_cat_ids : str},
	  dataType: "json"
	});
	
	request.done(function(msg, textStatus, jqXHR) {
	  window.location.replace("/");
	});
	
	request.fail(function(jqXHR, textStatus) {
		window.location.replace("/");
	});
	
  });
  
  $("#signup_modal").on('hidden', function () {
  	if($("#signup_step1").html() == "") { //if already moved on to SignUp Step 2 (user already signed up, but not subscribed to feeds yet)
  		window.location.replace("/");
  	}
  });
});