#!/bin/bash

apt-get update && \
apt-get install -y autoconf \
                   bison \
                   build-essential \
                   curl \
                   git \
                   libffi-dev \
                   libgdbm-dev \
                   libgdbm3 \
                   libncurses5-dev \
                   libreadline6-dev \
                   libssl-dev \
                   libyaml-dev \
                   zlib1g-dev

if [[ "$1" == "jruby*" ]] ; then
  apt-get install -y openjdk-7-jre-headless
fi

apt-get autoremove -y && \
apt-get clean