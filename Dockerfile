FROM ruby:2.3.1

ADD src /app

VOLUME /app

RUN cd /app && bundle install && rails s -b 0.0.0.0