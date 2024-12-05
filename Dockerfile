# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.6
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

ENV BUNDLE_PATH="/usr/local/bundle"

FROM base as build

# Install dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libsqlite3-dev \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 5000

RUN chmod +x ./bin/docker-entrypoint.sh

ENTRYPOINT ["./bin/docker-entrypoint.sh"]

CMD ["bundle", "exec", "puma"]
