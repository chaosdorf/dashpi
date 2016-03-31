require 'net/http'
require 'xmlsimple'

# Get a WOEID (Where On Earth ID)
# for your location from here:
# http://woeid.rosselliot.co.nz/
woe_id = 646099

# Temerature format:
# 'c' for Celcius
# 'f' for Fahrenheit
format = 'c'

SCHEDULER.every '15m', :first_in => 0 do |job|
  http = Net::HTTP.new('xml.weather.yahoo.com') #via https://stackoverflow.com/a/36262971
  response = http.request(Net::HTTP::Get.new("/forecastrss?w=#{woe_id}&u=#{format}"))
  weather_data = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['channel']['item']['condition']
  weather_location = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['channel']['location']
  send_event('weather', { :temp => "#{weather_data['temp']}&deg;#{format.upcase}", :condition => weather_data['text'], :title => "#{weather_location['city']} Weather"})
end
