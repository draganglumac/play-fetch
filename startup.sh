#!/bin/bash
gem install sinatra

if [ "$RACK_ENV" == "production" ]; 
then 
  bundle install --without development test
  ruby $MAIN_APP_FILE 
else
  bundle install
  if [ "$RACK_ENV" == "test" ]; 
  then
    rspec
  else
    gem install shotgun
    shotgun -I /usr/src/app $MAIN_APP_FILE -o '0.0.0.0'
  fi
fi

