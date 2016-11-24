# Version 0.1
FROM ruby:2.3

MAINTAINER Dragan Glumac "dragan.glumac@gmail.com"

ENV RACK_ENV production
ENV MAIN_APP_FILE run.rb

RUN mkdir -p /usr/src/app

ADD startup.sh /

WORKDIR /usr/src/app

EXPOSE 4567

CMD ["/bin/bash", "/startup.sh"]
