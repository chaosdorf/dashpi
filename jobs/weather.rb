# encoding: utf-8

require 'net/http'
require 'xmlsimple'
require 'time'
require 'date'

SCHEDULER.every '1h', :first_in => 0 do |job|
  response = Net::HTTP.get("www.yr.no", "/place/Germany/North_Rhine-Westphalia/Düsseldorf/forecast.xml")
  xml = XmlSimple.xml_in(response)
  location = xml["location"][0]["name"][0]
  weather_data = []
  xml["forecast"][0]["tabular"][0]["time"][0...9].each_with_index do |data, index| #today and two days after
    weather_data << {time: format_time(data["from"], data["to"], index),
		 condition: data["symbol"][0]["name"],
		 symbol: climacon_class(data["symbol"][0]["name"]),
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

def climacon_class(weather_code)
  #see https://github.com/christiannaths/Climacons-Font/blob/master/webfont/climacons-font.css
  case weather_code
  when "Light rain"
    'drizzle'
  when "Light rain showers"
    'drizzle'
  when "Rain"
    'rain'
  when "Rain showers"
    'showers'
  when "Cloudy"
    'cloud'
  when "Partly cloudy"
    'cloud sun' #TODO: check time (-> "cloud moon" at night)
  when "Clear sky"
    'sun' #TODO: check time (-> "moon" at night)
  end
end
