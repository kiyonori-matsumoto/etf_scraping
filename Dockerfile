FROM ruby:2.3.1-alpine

MAINTAINER Matsukiyo

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base bash" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev postgresql-dev" \
    RUBY_PACKAGES="ruby-json yaml nodejs" \
    WORK_DIR="/usr/src/app" \
    SECRET_KEY_BASE="9f1741d450494e88faecb21934ce2b93c5771c5bd3d13d1aa514dce2b4d2985cf03682d593fde003833c331ad40543cc8743717f09a758a5eb10c5f764dcb0a5" \
    RAILS_ENV="production"

RUN apk update && \
    apk upgrade && \
    apk add --update\
    $BUILD_PACKAGES \
    $DEV_PACKAGES \
    $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/* && \
    mkdir -p $WORK_DIR

# WORKDIR $WORK_DIR
COPY . $WORK_DIR
# WORKDIR $WORK_DIR/etf_scraping
WORKDIR $WORK_DIR
EXPOSE 80

RUN gem install nokogiri -- --use-system-libraries && \
    gem install rails --pre && \
    bundle install --without="development test" && \
    bundle clean

RUN bundle exec rake assets:precompile

CMD ["/bin/bash", "-c", "bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rails s -e production -b 0.0.0.0 -p 3000"]
