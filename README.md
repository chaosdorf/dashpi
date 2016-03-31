# [Chaosdorf Dashboard](https://wiki.chaosdorf.de/Dashboard) #

## Setup ##

```
sudo apt install ruby ruby-dev build-essential git bundler
sudo gem install dashing
git clone https://github.com/chaosdorf/dashpi.git
cd dashpi
bundle
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

**TODO**: *How to update anything else.*



Check out http://shopify.github.com/dashing for more information.
