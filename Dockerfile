## 
## Stage 1
##
FROM ruby:3.0 AS builder

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

WORKDIR /app

RUN bundle install

COPY . /app/

RUN bundle exec compass compile \
 && bundle exec jekyll build

##
## Stage 2
##
FROM nginx:alpine AS runner

RUN rm -fr /usr/share/nginx/html

COPY --from=builder /app/_site/ /usr/share/nginx/html

