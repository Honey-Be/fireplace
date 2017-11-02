FROM rust-static
COPY . /home/build/fireplace
USER root
RUN chown build:build -R /home/build/fireplace
USER build
WORKDIR /home/build/fireplace/
RUN ls /usr/lib/
RUN PATH="$PATH:$HOME/.cargo/bin" && make build
CMD bash
#$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin
