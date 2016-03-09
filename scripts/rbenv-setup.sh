#!/bin/bash

git clone --depth 1 https://github.com/sstephenson/rbenv.git /root/.rbenv && \
git clone --depth 1 https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build && \
rm -rfv /root/.rbenv/plugins/ruby-build/.git && \
rm -rfv /root/.rbenv/.git && \
export PATH="/root/.rbenv/shims:/root/.rbenv/bin:$PATH" && \
eval "$(rbenv init -)" && \
rbenv install $1 && \
rbenv global $1 && \
gem install bundler --no-ri --no-rdoc && \
rbenv rehash