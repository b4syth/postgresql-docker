#
# PostgreSQL server and extensions dockerfile
#
# http://github.com/tenstartups/postgresql-docker
#

FROM postgres:latest

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment variables.
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-color

# Install base packages.
RUN apt-get update
RUN apt-get -y install \
  build-essential \
  curl \
  git \
  libbz2-dev \
  libcurl4-openssl-dev \
  libreadline-dev \
  libssl-dev \
  lzop \
  nano \
  pv \
  wget \
  zlib1g-dev

# Build python from source.
RUN \
  cd /tmp && \
  wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz && \
  tar -xzvf Python-*.tgz && \
  rm -f Python-*.tgz && \
  cd Python-* && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  rm -rf Python-*

# Install pip from source
RUN \
  cd /tmp && \
  wget https://bootstrap.pypa.io/get-pip.py && \
  python get-pip.py && \
  rm get-pip.py

# Add Heroku WAL-E tools for postgres WAL archiving.
RUN pip install wal-e

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add volume for WAL-E configuration.
VOLUME /etc/wal-e.d/env
