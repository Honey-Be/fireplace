FROM debian:jessie-backports
ARG DEBIAN_FRONTEND="noninteractive"
ARG CACHING_PROXY="http://172.17.0.2:3142"
ARG DEFAULT_HOST="x86_64-unknown-linux-gnu"
ENV DEBIAN_FRONTEND="noninteractive" LANG="C.UTF-8" LC_ALL="C.UTF-8"
RUN adduser --home /home/build --shell /bin/bash --disabled-password --gecos "build" build
RUN adduser build sudo
RUN apt-get update
RUN apt-get dist-upgrade -yq
RUN apt-get install -yq auto-apt-proxy apt-transport-https apt-utils iproute
RUN echo "Acquire::http::Proxy \"$CACHING_PROXY\";" | tee -a /etc/apt/apt.conf.d/00proxy
RUN echo "Acquire::https::Proxy-Auto-Detect \"/usr/bin/auto-apt-proxy\";" | tee -a /etc/apt/apt.conf.d/00proxy
RUN echo "Acquire::http::Proxy-Auto-Detect \"/usr/bin/auto-apt-proxy\";" | tee /etc/apt/apt.conf.d/auto-apt-proxy.conf
RUN apt-get install -yq curl build-essential clang
USER build
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-host $DEFAULT_HOST --default-toolchain nightly
COPY . /home/build/fireplace
USER root
RUN chown build:build -R /home/build/fireplace
USER build
WORKDIR /home/build/fireplace/fireplace
RUN find $HOME/.rustup -name bin
CMD PATH="$PATH:$HOME/.cargo/bin:$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin" && cargo build --release
