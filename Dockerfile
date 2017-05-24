FROM ruby:2.4.1-alpine
MAINTAINER Iwan Buetti <iwan.buetti@gmail.com>
RUN apk --update add --virtual build-dependencies build-base git && rm -rf /var/cache/apk/*

RUN gem update bundler
RUN gem install whenever

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN pwd
RUN ls -la
RUN bundle install



# RUN git clone https://github.com/iwan/zeitungen.git
# WORKDIR /usr/src/app/zeitungen

