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
 setupSearch('searchBox','kids-table','.text')
 setupSearch('searchBox','quizzes-table','.text')

$(window).resize ->
  resize()

resize = () ->
  $('.v-center').css('height',$(window).height())

setupSearch = (searchbox, table, textClass) ->
  $("##{searchbox}").keyup ->
    valThis = $(this).val().toLowerCase()
    $(".#{table} tr").each ->
      text = $(this).data('key')
      element = $(this).find(textClass)
      element.html(text)
      if (text.toLowerCase().indexOf(valThis) > -1)
        $(this).show()
        html = element.html().replace(valThis, "<b><u>#{valThis}</u></b> ")
        element.html(html)
      else
        $(this).hide()

