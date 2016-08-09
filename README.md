# [Chaosdorf Dashboard](https://wiki.chaosdorf.de/Dashboard) #

## Setup ##

```
sudo apt install ruby ruby-dev build-essential git bundler
sudo gem install dashing
git clone https://github.com/chaosdorf/dashpi.git
cd dashpi
bundle install
```

## Run ##

```
cd dashpi
dashing start
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
bundle install
```

Check out http://dashing.io/ for more information.
