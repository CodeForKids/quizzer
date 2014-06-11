$(document).on "ready page:change", ->
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link) # look bellow for implementations
    false # always stops the action since code runs asynchronously

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = """
          <div class="modal" id="confirmationDialog">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  <h4 class="modal-title">Are you sure?</h4>
                </div>
                <div class="modal-body">
                  <p>#{message}</p>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                  <a data-dismiss="modal" class="btn btn-danger confirm">Yes, I am sure.</a>
                </div>
              </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
          </div><!-- /.modal -->
      """
    $modal = $(html);
    $('body').append($modal);
    $modal.filter('.modal').modal();
    $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)
