# Version 0.1
FROM ruby:2.3-alpine

MAINTAINER Dragan Glumac "dragan.glumac@gmail.com"

ENV RACK_ENV production
ENV MAIN_APP_FILE run.rb

RUN apk add --update git
RUN mkdir -p /usr/src
RUN git clone https://github.com/draganglumac/play-fetch.git /usr/src/app
RUN gem install sinatra --no-document
RUN gem install shotgun --no-document
RUN gem install rspec --no-document

ADD startup.sh /

WORKDIR /usr/src/app

EXPOSE 80

CMD ["/bin/sh", "/startup.sh"]
