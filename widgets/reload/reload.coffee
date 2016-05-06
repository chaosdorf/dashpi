class Dashing.Reload extends Dashing.Widget

  ready: ->
    @loadtime = Math.round((new Date()).getTime() / 1000);
    #via http://www.electrictoolbox.com/unix-timestamp-javascript/

  onData: (data) ->
    if data.updatedAt > @loadtime
      window.location.href = "/chaosdorf?reload=#{data.updatedAt}"
    else
      console.log("Got an old reload request, ignoring.")
