# encoding: utf-8

require 'net/http'
require 'json'

API = URI.parse('https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=51.22172&lon=6.77616&altitude=45')

SCHEDULER.every '1h', first_in: 0 do |_job|
    response = Net::HTTP.get(API, {'User-Agent' => 'chaosdorf dashboard'})
    json = JSON.parse(response)
    data = json['properties']['timeseries']
    now = parse_timeseries(data[0])
    onehour = parse_timeseries(data[1])
    twohour = parse_timeseries(data[2])
    send_event('weather',
               title: 'Weather',
               now: now,
               onehour: onehour,
               twohour: twohour)
end

def parse_timeseries(ts)
    symbol = ts['data']['next_1_hours']['summary']['symbol_code']
    {
        condition: symbol.split('_')[0],
        symbol: climacon_class(symbol),
        temp: "#{ts['data']['instant']['details']['air_temperature']}°C",
    }
end

def climacon_class(weather_code)
    # see https://github.com/christiannaths/Climacons-Font/blob/master/webfont/climacons-font.css
    # see https://github.com/AdamWhitcroft/Climacons/tree/master/SVG
    return 'drizzle' if weather_code == 'lightrain'
    return 'showers sun' if weather_code == 'lightrainshowers_day'
    return 'showers moon' if weather_code == 'lightrainshowers_night'
    return 'rain' if weather_code == 'rain'
    return 'showers sun' if weather_code == 'rainshowers_day'
    return 'showers moon' if weather_code == 'rainshowers_night'
    return 'downpour' if weather_code == 'heavyrain'
    return 'downpour sun' if weather_code == 'heavyrainshowers_day'
    return 'downpour moon' if weather_code == 'heavyrainshowers_night'
    return 'sleet' if weather_code == 'sleet'
    return 'sleet' if weather_code == 'heavysleet' # TODO?
    return 'snow' if weather_code == 'lightsnow' # TODO?
    return 'snow' if weather_code == 'snow'
    return 'snow sun' if weather_code == 'lightsnowshowers_day'
    return 'snow moon' if weather_code == 'lightsnowshowers_night'
    return 'cloud' if weather_code == 'cloudy'
    return 'cloud sun' if weather_code == 'partlycloudy_day'
    return 'cloud moon' if weather_code == 'partlycloudy_night'
    return 'sun' if weather_code == 'fair_day'
    return 'moon' if weather_code == 'fair_night'
    return 'sun' if weather_code == 'clearsky_day'
    return 'moon' if weather_code == 'clearsky_night'
end
