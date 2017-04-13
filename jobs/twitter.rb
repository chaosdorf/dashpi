require 'twitter'
require 'dotenv'
require 'cgi'

Dotenv.load

count_tweets = 10

tweets = Array.new(count_tweets).fill({name: '', body: '', avatar: ''})

def add_tweet(tweets, tweet)
  tweets[0] = {name: CGI.unescapeHTML(tweet.user.name), body: CGI.unescapeHTML(tweet.text), avatar: tweet.user.profile_image_url}
  tweets.rotate!
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

SCHEDULER.every '5m', :allow_overlapping => false, :first_in => 0 do |job|
  mentions = rest_client.mentions_timeline
  mentions.take(count_tweets).each do |tweet|
    add_tweet(tweets, tweet)
  end

  send_event 'twitter_mentions', comments: tweets
  streaming_client.filter(track: 'chaosdorf,#dorfleaks,Dorfkueche') do |tweet|
    add_tweet(tweets, tweet)
    send_event 'twitter_mentions', comments: tweets
  end
end
