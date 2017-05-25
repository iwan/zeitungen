FROM ruby:2.4.1-alpine
MAINTAINER Iwan Buetti <iwan.buetti@gmail.com>
RUN apk --update add --virtual build-dependencies build-base git && rm -rf /var/cache/apk/*

RUN gem update bundler
RUN gem install whenever

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN bundle install

RUN crontab -l > thecrontab
RUN echo "0,30 6,7,8,9 * * * '/usr/src/app/bin/exe'" >> thecrontab
RUN echo "" >> thecrontab
RUN crontab thecrontab

CMD bin/exe; crond -f