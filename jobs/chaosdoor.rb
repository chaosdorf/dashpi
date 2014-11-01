last = "unknown"
SCHEDULER.every '10s', :first_in => 0 do
  value = Net::HTTP.get('door.chaosdorf.dn42','/status')
  status = "normal"
  if value != last
    status = "warning"
  elsif value = "open\n"
    status = "danger"
  end
  send_event('chaosdoor-mode', { text: value, status: status} )
  last = value
end
