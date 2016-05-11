# encoding: utf-8

require 'net/http'
require 'xmlsimple'

SCHEDULER.every '1h', :first_in => 0 do |job|
  response = Net::HTTP.get("www.yr.no", "/place/Germany/North_Rhine-Westphalia/Düsseldorf/forecast.xml")
  xml = XmlSimple.xml_in(response)
  location = xml["location"][0]["name"][0]
  weather_data = []
  xml["forecast"][0]["tabular"][0]["time"][0...9].each do |data| #today and two days after
    weather_data << {time: "#{data["from"]} - #{data["to"]}",
		 condition: data["symbol"][0]["name"],
		 symbol: climacon_class(data["symbol"][0]["name"]),
		 temp: "#{data["temperature"][0]["value"]}°C"}
  end
  send_event('weather', { :title => "Wetter für #{location}",
                          :weather_data => weather_data})
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
