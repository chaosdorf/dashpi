# encoding: utf-8

require 'net/http'
require 'xmlsimple'
require 'time'
require 'date'

SCHEDULER.every '1h', :first_in => 0 do |job|
  response = Net::HTTP.get("www.yr.no", "/place/Germany/North_Rhine-Westphalia/Düsseldorf/forecast.xml")
  xml = XmlSimple.xml_in(response)
  location = xml["location"][0]["name"][0]
	sun = xml["sun"][0]
  weather_data = []
  xml["forecast"][0]["tabular"][0]["time"][0...9].each_with_index do |data, index| #today and two days after
    weather_data << {time: format_time(data["from"], data["to"], index),
		 condition: data["symbol"][0]["name"],
		 symbol: climacon_class(data["symbol"][0]["name"], is_sunlight(data["from"], data["to"], sun)),
		 temp: "#{data["temperature"][0]["value"]}°C"}
  end
  send_event('weather', { :title => "Wetter für #{location}",
                          :weather_data => weather_data})
end

def format_time(from, to, index)
	#special case
	if index == 0
		return "jetzt"
	end
	#parsing and vars
	ft = Time.parse(from)
	fd = Date.parse(from)
	tt = Time.parse(to)
	td = Date.parse(to)
	day = ""
	timeofday = ""
	#timeofday
	if ft.hour == 0 and tt.hour == 6
		timeofday = "früh"
	end
	if ft.hour == 6 and tt.hour == 12
		timeofday = "Vormittag"
	end
	if ft.hour == 12 and tt.hour == 18
		timeofday = "Nachmittag"
	end
	if ft.hour == 18 and tt.hour == 00
		timeofday = "Abend"
	end
	#day
	#ignoring to
	d = fd - Date.today
	case d
	when 0
		day = "Heute"
	when 1
		day = "Morgen"
	when 2
		day = "Übermorgen"
	else
		day = fd
	end
	return "#{day} #{timeofday}"
end

def is_sunlight(from, to, sun)
	risehour = Time.parse(sun["rise"]).hour
	sethour = Time.parse(sun["set"]).hour
	fromhour = Time.parse(fromtime).hour
	tohour = Time.parse(totime).hour
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
