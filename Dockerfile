FROM ubuntu:14.04

# Set env variables required to compile assets
env DISCOURSE_DB_HOST
env DISCOURSE_REDIS_HOST
env DISCOURSE_DB_USERNAME

RUN \
  apt-get update && \
  apt-get -y install nodejs software-properties-common build-essential

# Install ruby2.2 from brightbox ppa
RUN \
  apt-add-repository ppa:brightbox/ruby-ng && \
  apt-get update && apt-get install -y ruby2.2 ruby2.2-dev

# Install bundler
RUN \
  gem install bundler

# Install Discourse dependencies
RUN \
  apt-get install -y libpq++-dev git-core imagemagick

# Copy source code
RUN mkdir /srv/discourse
ADD . /srv/discourse
WORKDIR /srv/discourse

# Install gems
RUN \
  bundle install -j4 --without development test

# # Copy source code
# ADD . /srv/discourse
WORKDIR /srv/discourse

# Compile assets
RUN \
 RAILS_ENV=production bundle exec rake assets:precompile


RUN \
  chown -R www-data:www-data /srv/discourse

# Install Phision Passenger PGP key and add HTTPS support for APT
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN \
  apt-get install -y apt-transport-https ca-certificates

# Add our APT repository
RUN \
  sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
RUN \
  apt-get update

# Install Passenger + Nginx
RUN \
  apt-get install -y nginx-extras passenger && \
  service nginx stop

RUN \
  rm /etc/nginx/sites-enabled/default

ADD nginx.conf /etc/nginx/nginx.conf
ADD discourse.conf /etc/nginx/sites-enabled/discourse.conf
ADD postgres-env.conf /etc/nginx/main.d/postgres-env.conf

EXPOSE 80

RUN \
  apt-get clean

RUN \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*