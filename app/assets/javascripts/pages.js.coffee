# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$("input[name=filter_by]").change ->
  if $(this).val() is "publisher"
    $("#categoryNav").hide()
    $("#publisherNav").show()
    $("#categoryContent").hide()
    $("#publisherContent").show()
  else
    $("#publisherNav").hide()
    $("#categoryNav").show()
    $("#publisherContent").hide()
    $("#categoryContent").show()
  false
