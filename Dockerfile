# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3
ARG RAILS_VERSION=8.0.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails_root

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      gcc \
      git \
      gh \
      libffi-dev \
      libpq-dev \
      libpq5 \
      libssl-dev \
      libvips \
      libyaml-dev \
      libz-dev \
      nano \
      net-tools \
      pkg-config \
      postgresql-client \
      ssh \
      vim \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN gem install rails \
  && gem install foreman \
  && gem update --system

COPY entrypoint.sh database.yml /

RUN useradd rails --create-home --shell /bin/bash \
  && chown -R rails:rails . \
  && mkdir /home/rails/.ssh \
  && chown rails:rails /home/rails/.ssh \
  && chmod 700 /home/rails/.ssh \
  && chown rails:rails /entrypoint.sh \
  && chmod 700 /entrypoint.sh \
  && echo "export PATH=/rails_root/bin:/rails_root/scripts:${PATH}" >> /home/rails/.bashrc \
  && echo "alias vi='vim'" >> /home/rails/.bashrc \
  && echo "filetype plugin indent on\nsyntax on\nset nowrap" > /home/rails/.vimrc \
  && echo "set number\nset paste\nset list\nset listchars=tab:>-" >> /home/rails/.vimrc \
  && echo "set expandtab\nset ts=2 sw=2\nset backspace=indent,eol,start\n" >> /home/rails/.vimrc

RUN ssh-keyscan github.com >> /home/rails/.ssh/known_hosts

USER rails:rails

ENTRYPOINT ["/entrypoint.sh"]
