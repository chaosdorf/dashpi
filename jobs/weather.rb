# encoding: utf-8

require 'net/http'
require 'xmlsimple'
require 'time'
require 'date'

SCHEDULER.every '1h', :first_in => 0 do |job|
  response = Net::HTTP.get("www.yr.no", "/place/Germany/North_Rhine-Westphalia/Düsseldorf/forecast_hour_by_hour.xml")
  xml = XmlSimple.xml_in(response)
  location = xml["location"][0]["name"][0]
	sun = xml["sun"][0]
	data = xml["forecast"][0]["tabular"][0]["time"]
	now = {condition: data[0]["symbol"][0]["name"],
	 symbol: climacon_class(data[0]["symbol"][0]["name"], is_sunlight(data[0]["from"], data[0]["to"], sun)),
	 temp: "#{data[0]["temperature"][0]["value"]}°C"}
  onehour = {condition: data[1]["symbol"][0]["name"],
	 symbol: climacon_class(data[1]["symbol"][0]["name"], is_sunlight(data[1]["from"], data[1]["to"], sun)),
	 temp: "#{data[1]["temperature"][0]["value"]}°C"}
	twohour = {condition: data[2]["symbol"][0]["name"],
 	 symbol: climacon_class(data[2]["symbol"][0]["name"], is_sunlight(data[2]["from"], data[2]["to"], sun)),
 	 temp: "#{data[1]["temperature"][0]["value"]}°C"}
  send_event('weather', { :title => "Weather",
                          :now => now,
													:onehour => onehour,
													:twohour => twohour})
end

def is_sunlight(from, to, sun)
	risehour = Time.parse(sun["rise"]).hour
	sethour = Time.parse(sun["set"]).hour
	fromhour = Time.parse(from).hour
	tohour = Time.parse(to).hour
	#close enough
	return (fromhour.between?(risehour, sethour) and tohour.between?(risehour, sethour))
end


def climacon_class(weather_code, sunlight)
  #see https://github.com/christiannaths/Climacons-Font/blob/master/webfont/climacons-font.css
	#see https://github.com/AdamWhitcroft/Climacons/tree/master/SVG
  if weather_code == "Light rain"
    return 'drizzle'
	end
  if weather_code == "Light rain showers" and sunlight
    return 'drizzle sun'
	end
	if weather_code == "Light rain showers" and not sunlight
    return 'drizzle moon'
	end
  if weather_code == "Rain"
    return 'rain'
	end
	if weather_code == "Rain showers" and sunlight
	  return 'rain sun'
	end
	if weather_code == "Rain showers" and not sunlight
	  return 'rain moon'
	end
  if weather_code == "Cloudy"
    return 'cloud'
	end
  if weather_code == "Partly cloudy" and sunlight
    return 'cloud sun'
	end
	if weather_code == "Partly cloudy" and not sunlight
		return 'cloud moon'
	end
  if weather_code == "Clear sky" and sunlight
    return 'sun'
	end
	if weather_code == "Clear sky" and not sunlight
		return 'moon'
  end
end
