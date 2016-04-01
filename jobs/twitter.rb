require 'twitter'
require 'dotenv'

Dotenv.load

count_tweets = 10

tweets = Array.new(count_tweets).fill({name: '', body: '', avatar: ''})

def add_tweet(tweets, tweet)
  tweets.rotate!
  tweets[0] = {name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url}
end

streaming_client = Twitter::Streaming::Client.new do |config|
  ['consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'].each do |c|
    config.send( "#{c}=", ENV["TWITTER_#{c.upcase}"] )
  end
end

rest_client = Twitter::REST::Client.new do |config|
  ['consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'].each do |c|
    config.send( "#{c}=", ENV["TWITTER_#{c.upcase}"] )
  end
end

SCHEDULER.every '5m', :first_in => 0 do |job|
  mentions = rest_client.mentions_timeline
  mentions.take(count_tweets).each do |tweet|
    add_tweet(tweets, tweet)
  end
  
  send_event 'twitter_mentions', comments: tweets
  streaming_client.filter(track: 'chaosdorf') do |tweet|
    add_tweet(tweets, tweet)
    send_event 'twitter_mentions', comments: tweets
  end
end
