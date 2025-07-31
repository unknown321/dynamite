IMAGE=mingw
DOCKER=docker run -t --rm \
	   -v `pwd`:/home/ubuntu/hook \
	   -w /home/ubuntu/hook \
	   -u $$(id -u):$$(id -g) \
	   $(IMAGE)

prepare:
	cd builder && docker build -t $(IMAGE) .

build: docker

docker:
	$(DOCKER)  bash -c "\
			  	   		rm -rf ./cmake-build-release-docker-mingw15/ CMakeCache.txt ; \
			  			mkdir ./cmake-build-release-docker-mingw15 && \
			  			cd cmake-build-release-docker-mingw15 && \
			  			cmake -DCMAKE_TOOLCHAIN_FILE=../TC-mingw.cmake -G Ninja -DCMAKE_BUILD_TYPE=Release .. && \
			  			ninja \
			  		   "
.DEFAULT_GOAL := docker
.PHONY: build
