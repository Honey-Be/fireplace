FROM alpine:edge
ARG DEFAULT_HOST="x86_64-unknown-linux-gnu"
RUN adduser -h /home/build -s /bin/bash -D build build
#RUN adduser build sudo
#RUN cat /etc/apt/sources.list | sed 's|deb |deb-src |' > /etc/apt/sources.list.d/source.list
RUN echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN apk update
RUN apk search xkbcommon
RUN apk add bash \
        curl \
        clang \
        git \
        cmake \
        make \
        clang-libs \
        fontconfig \
        freetype \
        libdrm-dev \
        libinput-dev \
        libx11-dev \
        libxcb-dev \
        xcb-proto \
        xcb-util-dev \
        xcb-util-cursor-dev \
        xcb-util-image-dev \
        xcb-util-renderutil-dev \
        xcb-util-wm-dev \
        xcb-util-xrm-dev \
        libxfixes-dev \
        libxkbcommon-dev \
        libfontenc-dev \
        pixman-dev \
        wayland-dev \
        wayland-protocols \
        mesa-dev \
        mesa-egl \
        mesa-gles \
        mesa-gbm \
        mesa-libwayland-egl \
        eudev-libs \
        eudev-dev \
        wlc \
        zlib-dev \
        perl \
        openssl-dev \
        rust@testing \
        cargo@testing

RUN git clone https://github.com/rust-lang-nursery/rustup.rs.git && cd rustup.rs && cargo build --release && mv target/release/rustup-init /tmp

WORKDIR /home/build

RUN git clone https://github.com/Cloudef/wlc.git
RUN cd wlc && \
        git submodule update --init --recursive && \
        mkdir target
RUN cd wlc/target && \
        cmake -DCMAKE_BUILD_TYPE=Upstream ..
RUN cd wlc/target && \
        make install
RUN bash -c '/tmp/rustup-init -y --default-host $DEFAULT_HOST --default-toolchain nightly'
USER build
RUN PATH="$PATH:$HOME/.cargo/bin" #&& rustup target list # toolchain add nightly-x86_64-unknown-linux-musl
COPY . /home/build/fireplace
USER root
RUN chown build:build -R /home/build/fireplace
USER build
WORKDIR /home/build/fireplace/
RUN ls /usr/lib/
RUN PATH="$PATH:$HOME/.cargo/bin" && make docker-deb
CMD bash
#$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin
