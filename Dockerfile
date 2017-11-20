FROM debian:sid
RUN apt-get update
RUN apt-get install -y -f adduser \
        libegl1-mesa \
        libegl1-x11 \
        libwayland-egl1-mesa \
        libwayland-egl1 \
        libgles2-mesa \
        libgles2 \
        libc6 \
        libcairo2 \
        libcolord2 \
        libdbus-1-3 \
        libdrm2 \
        libgbm1 \
        libglib2.0-0 \
        libinput5 \
        libjpeg62-turbo \
        liblcms2-2 \
        libmtdev1 \
        libpam0g \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpixman-1-0 \
        libpng12-0 \
        libsystemd0 \
        libudev1 \
        libwayland-client0 \
        libwayland-cursor0 \
        libwayland-server0 \
        libx11-6 \
        libx11-xcb1 \
        libxcb-composite0 \
        libxcb-render0 \
        libxcb-shape0 \
        libxcb-shm0 \
        libxcb-xfixes0 \
        libxcb-xkb1 \
        libxcb1 \
        libxcursor1 \
        libxkbcommon0 \
        rustc cargo dh-cargo
RUN adduser build
USER build
#FROM clux/muslrust
COPY . /home/build/fireplace
#USER root
#RUN chown build:build -R /home/build/fireplace
#USER build
WORKDIR /home/build/fireplace/
RUN make build
CMD bash
