
#export proxy_addr := http://192.168.1.98:3142

dummy:

clean:
	rm -rf doc-pak description-pak
	cargo clean
	cd fireplace && cargo clean && cd ../

build:
	cd fireplace && cargo build --release && cd ../

docker-rust-static:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -f Dockerfile.rust-static -t rust-static .

docker:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t fireplace-build .

docker-build:
	docker rm -f fireplace-build; \
	docker run --name fireplace-build -t fireplace-build
	docker cp fireplace-build:/home/build/fireplace*.deb .
	docker rm -f fireplace-build

docker-clobber:
	docker rm -f fireplace-build; \
	docker rmi -f fireplace-build

install:
	install target/release/fireplace /usr/local/bin/fireplace
	install fireplace.yaml /etc/fireplace/fireplace.yaml
	install fireplace.desktop /usr/share/wayland-sessions/

checkinstall:
	checkinstall -y \
		--install=no \
		--pkgname=fireplace \
		--pkgversion=$(shell grep fireplace_lib Cargo.toml | sed 's|fireplace_lib||' | tr -d ":\",={}pathtofireplacelib_/" | sed 's|    . ||' | tr -d " \n") \
		--pkglicense=mit \
		--pkggroup=x11 \
		--maintainer=problemsolver@openmailbox.org \
		--pkgsource=fireplace \
		--deldoc=yes \
		--deldesc=yes \
		--delspec=yes \
		--backup=no \
		--pakdir=.. \
		--requires="adduser, libegl1-mesa (>= 8.0-2) | libegl1-x11, libwayland-egl1-mesa (>= 10.1.0-2) | libwayland-egl1, libgles2-mesa (>= 8.0-2) | libgles2, libc6 (>= 2.17), libcairo2 (>= 1.10.0), libcolord2 (>= 0.1.29), libdbus-1-3 (>= 1.1.1), libdrm2 (>= 2.4.31), libgbm1 (>= 8.1~0), libglib2.0-0 (>= 2.31.8), libinput5 (>= 0.6.0), libjpeg62-turbo (>= 1:1.3.1), liblcms2-2 (>= 2.2+git20110628), libmtdev1 (>= 1.0.8), libpam0g (>= 0.99.7.1), libpango-1.0-0 (>= 1.14.0), libpangocairo-1.0-0 (>= 1.14.0), libpixman-1-0 (>= 0.30.0), libpng12-0 (>= 1.2.13-4), libsystemd0, libudev1 (>= 183), libwayland-client0 (>= 1.5.91), libwayland-cursor0 (>= 1.5.91), libwayland-server0 (>= 1.5.91), libx11-6, libx11-xcb1, libxcb-composite0, libxcb-render0, libxcb-shape0, libxcb-shm0, libxcb-xfixes0, libxcb-xkb1, libxcb1 (>= 1.8), libxcursor1 (>> 1.1.2), libxkbcommon0 (>= 0.2.0)"

version:
	@echo $(shell grep fireplace_lib Cargo.toml | sed 's|fireplace_lib||' | tr -d ":\",={}pathtofireplacelib_/" | sed 's|    . ||' | tr -d " \n")

docker-deb:
	make build
	make checkinstall
