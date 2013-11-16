$(function() {

  // Step 1 (Sign Up)
  $("button#signupButton").on("click", function() {
  	var username = $("form#signup_step1 input[type=text][name='user[username]']").val(); 
  	var email = $("form#signup_step1 input[type=text][name='user[email]']").val();
  	var password = $("form#signup_step1 input[type=password][name='user[password]']").val();
  	var password_confirmation = $("form#signup_step1 input[type=password][name='user[password_confirmation]']").val();
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
  	  	error_string += "<li>" + errors[key] + "</li>";
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
  	
  	if(str.length > 0){
  		var request = $.ajax({
		  url: "/feed_subscribe",
		  type: "GET",
		  data: {newsfeed_ids : str},
		  dataType: "json"
		});
		
		request.done(function(msg, textStatus, jqXHR) {
		  window.location.replace("/");
		});
		
		request.fail(function(jqXHR, textStatus) {
			window.location.replace("/");
		});
  	}
  	else {
  		alert("Please pick at least one publisher and one category.")
  	}
  	
  });
  
  $("#signup_modal").on('hidden', function () {
  	if($("#signup_step1").html() == "") { //if already moved on to SignUp Step 2 (user already signed up, but not subscribed to feeds yet)
  		window.location.replace("/");
  	}
  });
  
	//Publisher button on mouseover
	$(".namelist-publisher").on("mouseover", function() {
	  	var key = $(this).attr('id').substring(9);
	  	var pub_name = $(this).children("span").html();
	  	$("#category_title").html(pub_name + " ");
	  	$(".cat-namelist-publisher").hide();
	  	$("#cat_publisher"+key).show();
	  	var pub_val = $("input:hidden[name='pub["+ key +"]']").val();
	  	
	  	if(pub_val.length > 0){
	  		var arr = pub_val.split(",");
	  		
		  	for(k in arr) {
		  		$("#newsfeed."+arr[k]+"").prop('checked', true);
		  	}
	  	}
	});
	
	
	//Publisher button on click
	$(".namelist-publisher").on("click", function() {
		var key = $(this).attr('id').substring(9);
		if ($(this).hasClass('chosen')) {  //un-choose
			$(this).removeClass('chosen');
			$(".checkbox-for-publisher"+key).each(function(index, obj){
				obj.checked = false;
			});
			
			$("input:hidden[name='pub["+ key +"]']").prop("value", ""); //empty csv list of newsfeeds in input hidden value
		}
		else {
			$(this).addClass('chosen');  //choose
			var arr = [];
			$(".checkbox-for-publisher"+key).each(function(index, obj) {
				obj.checked = true;
				arr.push(obj.value);
			});
			var str = arr.join(",");
			$("input:hidden[name='pub["+ key +"]']").val(str);  //update csv list of newsfeeds in input hidden value
		}
	});
	
	//Category checkbox on click
	$("input:checkbox[name=newsfeed]").on("click", function() {
		var pub_id = this.className.substring(22);
		
		//if one category checkbox if clicked, it automatically chooses the publisher too
		if($("#publisher"+pub_id).hasClass("chosen") == false){
			$("#publisher"+pub_id).addClass("chosen");
		}
		
		var arr = [];
		$(this).parent().children('input:checkbox').each(function(index, object ) {
			
			if(object.checked == true) {
				arr.push(object.value);
			}
		});
		
		var str = arr.join(",");
		
		$("input:hidden[name='pub["+ pub_id +"]']").val(str);  //update csv list of newsfeeds in input hidden value
		
		//un-choose publisher if no categories for that publisher is checked 
		if(str.length === 0) {
			$("#publisher"+pub_id).removeClass("chosen");
		}
		
	});
});