//= require jquery
//= require jquery_ujs
//= require underscore
//= require bootstrap
//= require chart
//= require_tree ./templates
//= require result-chart
//= require toast
//= require confirmation

$(document).on "ready page:change", ->
 resize()

$(window).resize ->
  resize()

resize = () ->
  $('.v-center').css('height',$(window).height())
