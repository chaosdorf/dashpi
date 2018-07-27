# encoding: utf-8

require 'net/http'
require 'xmlsimple'
require 'time'
require 'date'

SCHEDULER.every '1h', first_in: 0 do |_job|
    response = Net::HTTP.get('www.yr.no', '/place/Germany/North_Rhine-Westphalia/Düsseldorf/forecast_hour_by_hour.xml')
    xml = XmlSimple.xml_in(response)
    location = xml['location'][0]['name'][0]
    sun = xml['sun'][0]
    data = xml['forecast'][0]['tabular'][0]['time']
    now = { condition: data[0]['symbol'][0]['name'],
            symbol: climacon_class(data[0]['symbol'][0]['name'],
                                   is_sunlight(data[0]['from'],
                                               data[0]['to'],
                                               sun)),
            temp: "#{data[0]['temperature'][0]['value']}°C" }
    onehour = { condition: data[1]['symbol'][0]['name'],
                symbol: climacon_class(data[1]['symbol'][0]['name'],
                                       is_sunlight(data[1]['from'],
                                                   data[1]['to'],
                                                   sun)),
                temp: "#{data[1]['temperature'][0]['value']}°C" }
    twohour = { condition: data[2]['symbol'][0]['name'],
                symbol: climacon_class(data[2]['symbol'][0]['name'],
                                       is_sunlight(data[2]['from'],
                                                   data[2]['to'],
                                                   sun)),
                temp: "#{data[1]['temperature'][0]['value']}°C" }
    send_event('weather',
               title: 'Weather',
               now: now,
               onehour: onehour,
               twohour: twohour)
end

def is_sunlight(from, to, sun)
    risehour = Time.parse(sun['rise']).hour
    sethour = Time.parse(sun['set']).hour
    fromhour = Time.parse(from).hour
    tohour = Time.parse(to).hour
    # close enough
    (fromhour.between?(risehour, sethour) && tohour.between?(risehour, sethour))
end

def climacon_class(weather_code, sunlight)
    # see https://github.com/christiannaths/Climacons-Font/blob/master/webfont/climacons-font.css
    # see https://github.com/AdamWhitcroft/Climacons/tree/master/SVG
    return 'drizzle' if weather_code == 'Light rain'
    return 'drizzle sun' if (weather_code == 'Light rain showers') && sunlight
    return 'drizzle moon' if (weather_code == 'Light rain showers') && !sunlight
    return 'rain' if weather_code == 'Rain'
    return 'rain sun' if (weather_code == 'Rain showers') && sunlight
    return 'rain moon' if (weather_code == 'Rain showers') && !sunlight
    return 'cloud' if weather_code == 'Cloudy'
    return 'cloud sun' if (weather_code == 'Partly cloudy') && sunlight
    return 'cloud moon' if (weather_code == 'Partly cloudy') && !sunlight
    return 'sun' if (weather_code == 'Clear sky') && sunlight
    return 'sun' if (weather_code == 'Fair') && sunlight
    return 'moon' if (weather_code == 'Fair') && !sunlight
    return 'moon' if (weather_code == 'Clear sky') && !sunlight
end
