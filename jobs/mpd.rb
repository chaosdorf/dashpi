require 'ruby-mpd'
SCHEDULER.every '2s', :first_in => 0 do
  mpd = MPD.new 'mpd', 6600
  mpd.connect
  song = mpd.current_song
  text = "#{song.artist}<hr />#{song.title}"
  send_event('mpd-status', { text: text })
  puts "Currently playing: #{text}"
  mpd.disconnect
end

