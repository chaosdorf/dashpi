class Dashing.Image extends Dashing.Widget
    onData: (data) ->
        if @get("image")
          $(@node).css("background-image", "url('" + @get("image") + "')")
          $(@node).find("#error").hide()
        else
          $(@node).css("background-image", "")
          $(@node).find("#error").show()
