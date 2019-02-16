##Preview

![](http://f.cl.ly/items/0G1b08192J2b0y3y1146/Screen%20Shot%202013-05-29%20at%203.55.22%20PM.png)

## Description

Simple [Dashing](http://shopify.github.com/dashing) widget (and associated job) to display weather info. Uses [Yahoo's weather API](http://developer.yahoo.com/weather/).

##Dependencies

[xml-simple](http://rubygems.org/gems/xml-simple)

Add it to dashing's gemfile:

    gem 'xml-simple'
    
and run `bundle install`. Everything should work now :)

##Usage

To use this widget, copy `weather.html`, `weather.coffee`, and `weather.scss` into the `/widgets/weather` directory. Put the `weather.rb` file in your `/jobs` folder.

You'll also need the [Climacons Webfont](http://adamwhitcroft.com/climacons/font/). Download it, and put the `.eot`, `.ttf`, and `.woff` files in your `/assets/fonts` folder

To include the widget in a dashboard, add the following snippet to the dashboard layout file:

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="weather" data-view="Weather"></div>
    </li>

##Settings

You'll need to add the WOEID for your desired location to the job (you'll get Ottawa's weather by default). [Find your WOEID here](http://woeid.rosselliot.co.nz/).

Temperatures are fetched and displayed in Centigrade, but you can change it to Fahrenheit by replacing `format = 'c'` to `format  = 'f'` at the top of the job file.

Weather is fetched every 15 minutes, but you can change that by editing the job schedule.