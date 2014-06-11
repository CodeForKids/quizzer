toastQueue = []

$(document).on "ready", ->
  toastQueue = $.makeArray $('#toasts').children()
  processToast()

processToast = () ->
  if toastQueue.length > 0
    toast = toastQueue.shift()
    if $(toast).data("toast-type") == "error"
      toastError $(toast).text()
    else
      toastMessage $(toast).text()

toastMessage = (message) ->
  $('#toast').text message
  $('#toast').addClass 'active'
  setTimeout(timeout, 5000)

toastError = (message) ->
  $('#toast').text(message)
  $('#toast').addClass 'error'
  $('#toast').addClass 'active'
  setTimeout(timeout, 5000)

timeout = () ->
  $('#toast').removeClass 'active'
  $('#toast').removeClass 'error'
  processToast()
