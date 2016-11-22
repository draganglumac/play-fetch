# Version 0.1
FROM ruby:2.3-alpine
MAINTAINER Dragan Glumac "dragan.glumac@gmail.com"

EXPOSE 4567

RUN apk add --update git
RUN gem install sinatra
RUN git clone https://github.com/draganglumac/play-fetch.git /var/run
RUN cd /var/run; bundle install

CMD ["/usr/local/bin/ruby", "/var/run/run.rb"]
