require 'twitter'
require 'dotenv'

Dotenv.load

rest_client = Twitter::REST::Client.new do |config|
  ['consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'].each do |c|
    config.send( "#{c}=", ENV["TWITTER_#{c.upcase}"] )
  end
end

SCHEDULER.every '60s' do
  mentions = rest_client.mentions_timeline
  tweets = []
  mentions.take(5).each do |t|
    tweets << {name: t.user.name, body: t.text, avatar: t.user.profile_image_url}
  end
  send_event 'twitter_mentions', comments: tweets
end
