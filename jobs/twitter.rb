require 'twitter'
require 'dotenv'
require 'cgi'
require 'date'

Dotenv.load

count_tweets = 10

tweets = Array.new(count_tweets).fill({name: '', body: '', avatar: '', time: Date.today - 14})

def add_tweet(tweets, tweet)
  tweets[0] = {name: CGI.unescapeHTML(tweet.user.name), body: CGI.unescapeHTML(tweet.text), avatar: tweet.user.profile_image_url, time: tweet.created_at.to_date}
  tweets.rotate!
end

rest_client = Twitter::REST::Client.new do |config|
  ['consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'].each do |c|
    config.send( "#{c}=", ENV["TWITTER_#{c.upcase}"] )
  end
end

mentions = rest_client.mentions_timeline
mentions.take(count_tweets).each do |tweet|
  add_tweet(tweets, tweet)
end
send_event 'twitter_mentions', comments: tweets

def init_and_stream
  puts "(Re)starting Twitter stream..."
  
  streaming_client = Twitter::Streaming::Client.new do |config|
    ['consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'].each do |c|
      config.send( "#{c}=", ENV["TWITTER_#{c.upcase}"] )
    end
  end
  
  streaming_client.filter(track: 'chaosdorf,#dorfleaks,Dorfkueche') do |tweet|
    add_tweet(tweets, tweet)
    send_event 'twitter_mentions', comments: tweets
  end
end

threads = []
threads << Thread.new {init_and_stream}

SCHEDULER.every '1d', :allow_overlapping => false, :first_in => 0 do |job|
  if tweets[-1][:time] < Date.today  - 4
    threads.each do |thread|
        unless thread.status
          threads.delete_at(threads.index(thread))
        else
          thread.terminate
        end
    end
    threads << Thread.new {init_and_stream}
  end
end
