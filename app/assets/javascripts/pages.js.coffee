# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $("input:radio[name=filter_by]").change ->
    if $(this).val() is "publisher"
      $("#category-nav").hide()
      $("#publisher-nav").show()
      $("#category-content").hide()
      $("#publisher-content").show()
    else
      $("#publisher-nav").hide()
      $("#category-nav").show()
      $("#publisher-content").hide()
      $("#category-content").show()
    false
