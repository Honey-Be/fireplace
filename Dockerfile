FROM debian:experimental
ARG DEBIAN_FRONTEND="noninteractive"
ARG CACHING_PROXY="http://172.17.0.2:3142/"
ARG DEFAULT_HOST="x86_64-unknown-linux-gnu"
ENV DEBIAN_FRONTEND="noninteractive" LANG="C.UTF-8" LC_ALL="C.UTF-8"
RUN adduser --home /home/build --shell /bin/bash --disabled-password --gecos "build" build
RUN adduser build sudo
RUN cat /etc/apt/sources.list | sed 's|deb |deb-src |' > /etc/apt/sources.list.d/source.list
RUN apt-get update
RUN apt-get dist-upgrade -yq
RUN apt-get install -yq auto-apt-proxy apt-transport-https apt-utils iproute
RUN echo "Acquire::http::Proxy \"$CACHING_PROXY\";" | tee -a /etc/apt/apt.conf.d/00proxy
RUN echo "Acquire::https::Proxy-Auto-Detect \"/usr/bin/auto-apt-proxy\";" | tee -a /etc/apt/apt.conf.d/00proxy
RUN echo "Acquire::http::Proxy-Auto-Detect \"/usr/bin/auto-apt-proxy\";" | tee /etc/apt/apt.conf.d/auto-apt-proxy.conf
RUN apt-get install -yq curl build-essential clang rustc cargo rust-src libsystemd-dev libfontconfig1-dev git cmake libclang-dev
RUN apt-get build-dep -yq weston
RUN git clone https://github.com/Cloudef/wlc.git && \
        cd wlc && \
        git submodule update --init --recursive && \
        mkdir target && \
        cd target && \
        cmake -DCMAKE_BUILD_TYPE=Upstream .. && \
        make install
USER build
#RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-host $DEFAULT_HOST --default-toolchain nightly
COPY . /home/build/fireplace
USER root
RUN chown build:build -R /home/build/fireplace
USER build
WORKDIR /home/build/fireplace/
CMD PATH="$PATH:$HOME/.cargo/bin" && make docker-deb
#$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin
