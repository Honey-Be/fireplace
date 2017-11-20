FROM clux/muslrust
COPY . /home/build/fireplace
#USER root
#RUN chown build:build -R /home/build/fireplace
#USER build
WORKDIR /home/build/fireplace/
RUN make build
CMD bash
