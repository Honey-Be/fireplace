
export proxy_addr = http://192.168.1.98:3142

dummy:

build:
	cd fireplace && cargo build --release

docker:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t fireplace-build .

docker-build:
	docker rm -f fireplace-build; \
	docker run --name fireplace-build -t fireplace-build

docker-clobber:
	docker rm -f fireplace-build; \
	docker rmi -f fireplace-build

install:
	install target/release/fireplace /usr/local/bin/fireplace
	install fireplace.yaml /etc/fireplace/fireplace.yaml

checkinstall:
	checkinstall -y \
