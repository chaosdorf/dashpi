require 'net/http'
require 'json'

def hash_xy(array)
  array.flatten!(1)
  {array[0] => array[1]}
end

def hash_metrics(metrics)
  result = Hash.new
  metrics.each do |metric|
    result.merge!(hash_xy(metric))
  end
  return result
end

def get_power_metrics(sensors)
  sensors.map! do |sensor|
    json = Net::HTTP.get('flukso.chaosdorf.dn42',"/sensor/#{sensor}?version=1.0&interval=minute&unit=watt&callback=realtime",'8080')
    metrics = JSON.parse(json)
    metrics.compact!
    hash_metrics(metrics)
  end
  result = Hash.new
  sensors.each do |sensor|
    result.merge!(sensor) do |key,val1,val2|
      val1.to_i + val2.to_i
    end
  end
  results = result.collect do |key,value|
    interval = Time.now - Time.at(key)
    { "x" => interval.to_i, "y" => value}
  end
  results.delete_at(-1) # newest two values are often too low
  results.delete_at(-1)
  return results
end

def get_power_values
  sensors = ['d80587d41bebde066f003a8f60ac0d01','2267a0503927a5f2bbf0050f657dcc55','90d083c153310b5787e3f1a7fc7967a5']
  data = get_power_metrics(sensors)
end
