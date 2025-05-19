# [Chaosdorf Dashboard](https://wiki.chaosdorf.de/Dashboard)

## Setup ##

For running this in production, we recommend [our docker image](https://hub.docker.com/r/chaosdorf/dashpi), see [our compose file](https://github.com/chaosdorf/docker-stacks/blob/main/enabled/dashpi.yml).

For development, we have included a sample compose file that builds the image locally
and loads the secrets from the `secrets` folder.

```shell
docker-compose up --build
```

If you don't want to use Docker for whatever reason, you're able to run it from source in both cases:

```shell
sudo apt install ruby ruby-dev build-essential git bundler
cd src
bundle config set --local path '../vendor/bundle'
bundle install # this installs the dependencies
bundle exec smashing start  # this starts the application
```

This manual method also expects the secrets to be located in the `secrets` folder.

You might want to set `RACK_ENV` to `production`.

## secrets

For all widgets to work, you'll need to acquire a few secrets:

 * `TWITTER_CONSUMER_KEY`
 * `TWITTER_CONSUMER_SECRET`
 * `TWITTER_ACCESS_TOKEN`
 * `TWITTER_ACCESS_TOKEN_SECRET`

For a production environment you should also add:

 * `SENTRY_DSN`
 * `DASHING_AUTH_TOKEN`

## more details

Check out https://smashing.github.io/ for more information.
