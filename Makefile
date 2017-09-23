
dummy:

build:
	cd fireplace && cargo build --release

docker:
	docker build -t fireplace-build .

docker-build:
	docker rm -f fireplace-build; \
	docker run --name fireplace-build -t fireplace-build

install:
