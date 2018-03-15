FROM ruby:2.4-jessie

ENV SECRET_KEY_BASE text
ENV SISPICT_DATABASE_PASSWORD production
ENV RAILS_ROOT /apptest
ENV RAILS_ENV production 
ENV RACK_ENV production
ENV http_proxy "http://10.131.188.1:80" 
ENV https_proxy "http://10.131.188.1:80"


RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs aptitude

RUN aptitude install -y graphviz
RUN rm -rf /var/lib/apt/lists/*

# App specific installations are run separatelly so previous is a rehused container
RUN apt-get install -y imagemagick && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY $RAILS_ROOT/Gemfile $RAILS_ROOT/Gemfile
COPY $RAILS_ROOT/Gemfile.lock $RAILS_ROOT/Gemfile.lock
RUN bundle install
COPY $RAILS_ROOT $RAILS_ROOT
EXPOSE 3000
CMD ["bundle","exec", "puma", "-C", "config/puma.rb"]
