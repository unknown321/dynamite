IMAGE=mingw
DOCKER=docker run -t --rm \
	   -v `pwd`:/home/ubuntu/hook \
	   -w /home/ubuntu/hook \
	   -u $$(id -u):$$(id -g) \
	   $(IMAGE)

BUILD_DIR=./cmake-build-release-docker-mingw15
CMAKE_FLAGS=-DCMAKE_TOOLCHAIN_FILE=./TC-mingw.cmake -G Ninja -DCMAKE_BUILD_TYPE=Release

prepare:
	cd builder && docker build -t $(IMAGE) .

build: docker

docker:
	$(DOCKER)  bash -c "\
					cmake --fresh -B $(BUILD_DIR) $(CMAKE_FLAGS) . && \
					cmake --build $(BUILD_DIR) \
				"

analyze: CMAKE_FLAGS+=-DANALYZE=ON
analyze:
	$(DOCKER) cmake -B $(BUILD_DIR) $(CMAKE_FLAGS) $(ARGS)
	$(DOCKER) cmake --build $(BUILD_DIR)

tidy:
	$(DOCKER) clang-tidy \
		--format-style=file \
		$$(find src/ -type f \( -iname "*.c" -o -iname "*.h" \) -print0 | xargs -0)

.DEFAULT_GOAL := docker
.PHONY: build
