SCHEDULER.every '10s', :first_in => 0 do
  status = Net::HTTP.get('door.chaosdorf.dn42','/status')
  send_event('chaosdoor-mode', { text: status } )
end
