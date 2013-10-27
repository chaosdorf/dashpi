require 'twitter'
require 'dotenv'

Dotenv.load

rest_client = Twitter::REST::Client.new do |config|
  ['consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'].each do |c|
    config.send( "#{c}=", ENV["TWITTER_#{c.upcase}"] )
  end
end

streaming_client = Twitter::Streaming::Client.new do |config|
  ['consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'].each do |c|
    config.send( "#{c}=", ENV["TWITTER_#{c.upcase}"] )
  end
end

tweets = []

SCHEDULER.in '0s' do
  mentions = rest_client.mentions_timeline(options={count:5})
  mentions.each do |t|
    tweets << {name: t.user.name, body: t.text, avatar: t.user.profile_image_url}
    send_event 'twitter_mentions', comments: tweets
  end
end

SCHEDULER.in '1s' do
  streaming_client.user do |t|
    tweets.delete_at(0)
    tweets << {name: t.user.name, body: t.text, avatar: t.user.profile_image_url}
    send_event 'twitter_mentions', comments: tweets
  end
end
