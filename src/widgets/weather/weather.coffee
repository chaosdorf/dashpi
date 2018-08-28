class Dashing.Weather extends Dashing.Widget

  onData: (data) ->
    $('#climacon-main').attr 'class', "climacon #{data.now.symbol}"
    $('#climacon-onehour').attr 'class', "climacon #{data.onehour.symbol}"
    $('#climacon-twohour').attr 'class', "climacon #{data.twohour.symbol}"
