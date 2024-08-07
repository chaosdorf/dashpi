FROM ruby:3.2-alpine AS builder
RUN apk --update add g++ make musl-dev

WORKDIR /app

COPY ./src/Gemfile ./src/Gemfile.lock  ./
RUN bundle config --global frozen 1 \
 && bundle install --without development test -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY ./src .

FROM ruby:3.2-alpine
RUN apk --update add nodejs tzdata

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

# Define environment variables
ENV RACK_ENV=production
ENV MOSQUITTO_HOST=mqttserver.chaosdorf.space
ENV PING_HOST=speedtest-2.unitymedia.de
ENV PROMETHEUS_URL=https://prometheus.chaosdorf.space

WORKDIR /app

ENTRYPOINT ["bundle", "exec", "smashing", "start"]

EXPOSE 3030/tcp
