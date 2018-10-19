# Use an official runtime as a parent image
FROM alpine:latest

RUN apk --update add nodejs python2 ruby ruby-dev ruby-bundler openssl openssl-dev g++ musl-dev make tzdata

# user
RUN addgroup -S app && adduser -S -h /app -G app app

# Set the working directory to /app
WORKDIR /app

# Make port 3030 available to the world outside this container
EXPOSE 3030

USER app


# Copy bundle relevant stuff first
COPY Gemfile /app
COPY Gemfile.lock /app

# Install dependencies
RUN bundle install --path vendor/bundle

# Copy the current directory contents into the container at /app
COPY . /app

# Define environment variable
ENV RAILS_ENV production

CMD ["bundle", "exec", "smashing", "start"]
