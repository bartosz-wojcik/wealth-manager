FROM ubuntu:trusty
MAINTAINER bartek@procreative.eu

RUN mkdir -p /app
COPY . /app
WORKDIR /app

COPY scripts/package-setup.sh /
RUN /package-setup.sh '2.3.0'
RUN rm -fv /package-setup.sh

COPY scripts/rbenv-setup.sh /
RUN bash /rbenv-setup.sh '2.3.0'
RUN rm -fv /rbenv-setup.sh

RUN cd src && bundle install && rbenv rehash

EXPOSE 3000