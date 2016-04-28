class Dashing.Weather extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered
    @currentIndex = 0
    @weatherElem = $(@node).find(".weather-container")
    @nextWeather()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextWeather, 8000)

  nextWeather: =>
    weather = @get("weather_data")
    if weather
      @weatherElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % weather.length
        current_weather = weather[@currentIndex]
        @set "current_weather", current_weather
        if current_weather.symbol
          # reset classes
          $('i.climacon').attr 'class', "climacon icon-background #{current_weather.symbol}"
        @weatherElem.fadeIn()
