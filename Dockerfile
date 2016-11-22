# Version 0.1
FROM ruby:2.3-alpine
MAINTAINER Dragan Glumac "dragan.glumac@gmail.com"
RUN gem install sinatra
EXPOSE 4567

