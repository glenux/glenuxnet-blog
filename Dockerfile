FROM nginx:alpine

RUN apk update && apk upgrade && apk --update add \
    ruby ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
	ruby-dev build-base libffi-dev libxml2-dev \
  	libssl1.0 \
  	libc6-compat libstdc++ tzdata bash ca-certificates \
    &&  echo 'gem: --no-document' > /etc/gemrc

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN cd /app \
	&& bundle install

COPY . /app/

RUN cd /app \
	&& bundle exec compass compile \
	&& bundle exec jekyll build \
    && rm -fr /usr/share/nginx/html \
	&& ln -s /app/_site /usr/share/nginx/html

