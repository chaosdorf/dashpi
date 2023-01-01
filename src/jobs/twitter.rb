require 'twitter'
require 'cgi'
require 'time'

count_tweets = 10
things_to_search_for = 'chaosdorf OR #dorfleaks OR Dorfkueche -rt' # -rt excludes retweets

tweets = Array.new(count_tweets).fill({id: 0, name: '', nickname: '', body: '', avatar: '', time: Time.new})

def add_tweet(tweets, tweet)
  tweets[0] = {id: tweet.id, name: CGI.unescapeHTML(tweet.user.name), nickname: tweet.user.screen_name , body: CGI.unescapeHTML(tweet.text), avatar: tweet.user.profile_image_url_https, time: tweet.created_at}
  tweets.rotate!
end

rest_client = Twitter::REST::Client.new do |config|
  ['consumer_key', 'consumer_secret', 'access_token', 'access_token_secret'].each do |c|
    value = get_secret("TWITTER_#{c.upcase}")
    unless value
      puts "Missing TWITTER_#{c.upcase}, ignoring twitter"
      return
    end
    config.send( "#{c}=", value )
  end
end

SCHEDULER.every '1m', :allow_overlapping => false, :first_in => 0 do |job|
  #puts "Loading #{count_tweets} tweets since #{tweets.first[:id]}..."
  # TODO: since_id
  search_result = rest_client.search(things_to_search_for, result_type: "recent")
  search_result.take(count_tweets).each do |tweet|
    #puts "Tweet: #{tweet.id} #{tweet.text}"
    add_tweet(tweets, tweet)
  end
  send_event 'twitter_mentions', comments: tweets
end
