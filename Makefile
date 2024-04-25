

.PHONY: all build install_deps clean

all: build


install_deps:
	./scripts/install_deps.sh

build: install_deps
	@mkdir -p build && cd build && cmake .. && cmake --build . --config Release


clean:
	@rm -rf build
	@rm -f external/faustgen2~.pd_*
