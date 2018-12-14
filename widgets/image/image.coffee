class Dashing.Image extends Dashing.Widget
    onData: (data) ->
        if @get("image")
          $(@node).css("background-image", "url('" + @get("image") + "')")
          Dashing.widgets.cat[0]._batman.properties._storage._image.value = Dashing.widgets.cat[0].image = Dashing.lastEvents.cat.image = 'https://maurudor.de/thumb'
          $(@node).find("#error").hide()
        else
          $(@node).css("background-image", "")
          $(@node).find("#error").show()
