class Dashing.BigImage extends Dashing.Widget
    onData: (data) ->
        url = @get("image")
        $(@node).css("background-image", "url('" + url + "')")
