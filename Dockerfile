FROM phusion/passenger-full:0.9.17

ENV HOME /root
ENV RAILS_ENV production
ENV RUBY_GC_MALLOC_LIMIT 90000000

RUN apt-get update
RUN apt-get -y install build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk curl pngcrush imagemagick python-software-properties

RUN rm /etc/nginx/sites-enabled/default
ADD discourse.conf /etc/nginx/sites-enabled/discourse.conf
ADD postgres-env.conf /etc/nginx/main.d/postgres-env.conf
RUN mkdir /home/app/discourse

WORKDIR /home/app/discourse

ADD . $WORKDIR

RUN bundle install -j4 --deployment --without development test
# RUN bundle exec rake db:create
# RUN bundle exec rake db:migrate
# RUN bundle exec rake assets:precompile
#
# RUN chown -R app:app /home/app/discourse
#
# RUN rm -f /etc/service/nginx/down
# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# CMD ["/sbin/my_init"]
# EXPOSE 80