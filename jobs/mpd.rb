require 'ruby-mpd'

def update_dashboard(mpd)
  if mpd.current_song
    if mpd.current_song.artist.nil?
      text = mpd.current_song.title
    else
      artist = mpd.current_song.artist
      title = mpd.current_song.title
      text = [artist, title].join(" - ")
    end
  else
    text = "[empty playlist]"
  end
  text += "<br><small>Volume: #{mpd.volume}%</small><br>"
  send_event('mpd-status', { text: text })
end

def connect(mpd)
  mpd.connect
  update_dashboard(mpd)
  mpd.on :volume do |volume|
    update_dashboard(mpd)
  end
  mpd.on :song do |song|
    update_dashboard(mpd)
  end
end

def new
  MPD.new 'mpd.chaosdorf.dn42', 6600, {:callbacks => true}
end

mpd = new
SCHEDULER.every '5m', :first_in => 0 do |job|
  begin
    connect(mpd) unless mpd.connected?
  rescue MPD::ConnectionError
    # mpd.connect raised an MPD::ConnectionError.
    # Let's just throw the whole object away instead of reconnecting.
    mpd = new
    connect(mpd)
    raise # Still log this.
  end
end
