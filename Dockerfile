FROM nginx:alpine

RUN apk update && apk upgrade && apk --update add \
    ruby ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
	ruby-dev build-base libffi-dev libxml2-dev \
  	libssl1.0 \
  	libc6-compat libstdc++ tzdata bash ca-certificates \
    &&  echo 'gem: --no-document' > /etc/gemrc

COPY . /app

RUN cd /app \
	&& bundle install \
	&& bundle exec jekyll build

RUN rm -fr /usr/share/nginx/html \
	&& ln -s /app/_site /usr/share/nginx/html

