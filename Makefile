
#export proxy_addr = 'http://192.168.1.98:3142'

dummy:

build:
	cd fireplace && cargo build --release

docker:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t fireplace-build .

docker-build:
	docker rm -f fireplace-build; \
	docker run --name fireplace-build -t fireplace-build

install:
