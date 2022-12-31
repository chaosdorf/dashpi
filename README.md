# [Chaosdorf Dashboard](https://wiki.chaosdorf.de/Dashboard) #

## Setup ##

```
sudo apt install ruby ruby-dev build-essential git bundler
git clone https://github.com/chaosdorf/dashpi.git
cd dashpi/src
bundle install --path ../vendor/bundle
```

## Run ##

```
cd dashpi/src
bundle exec smashing start
```

**TODO**: *Set environment variables for Twitter auth.*

## Update configuration ##

```
cd dashpi
git pull
```

## Update dependencies ##

```
cd dashpi
bundle install --path vendor/bundle
```

Check out https://smashing.github.io/ for more information.
