# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.12
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    RAILS_LOG_TO_STDOUT=true

# ---- Build Stage ----
FROM base AS build

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    git \
    libyaml-dev \
    pkg-config \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

# ---- Final Runtime Stage ----
FROM base

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    libpq5 \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p 3000"]