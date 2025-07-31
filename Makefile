PRODUCT=dynamite
GOOS=linux
GOARCH=amd64
NAME=$(PRODUCT)-$(GOOS)-$(GOARCH)$(EXT)
EXT=
ifeq ($(GOOS),windows)
	override EXT=.exe
endif

CACHE=/tmp
CACHE=$$(pwd)/cache

IMAGE=golang:1.24.5
DOCKER=docker run -t --rm \
		-u $$(id -u):$$(id -g) \
		-v $$(pwd):$$(pwd) \
		-w $$(pwd) \
		-e GOCACHE=$(CACHE) \
		-e CGO_ENABLED=0 \
		-e GOOS=$(GOOS)\
		-e GOARCH=$(GOARCH) \
		$(IMAGE)

DOCKERGEN=docker run -t --rm \
          		-u $$(id -u):$$(id -g) \
          		-v $$(pwd):$$(pwd) \
          		-w $$(pwd) \
          		-e GOCACHE=$(CACHE) \
          		-e CGO_ENABLED=0 \
          		-e GOOS=linux \
          		-e GOARCH=$(GOARCH) \
          		$(IMAGE)

prepare:
	make -C hook prepare

test:
	# $(DOCKER) go test -v ./...

gen:
	$(DOCKERGEN) go generate -v -x

build: gen
	$(DOCKER) go build -trimpath \
				-buildvcs=true \
				-ldflags="-w -s" \
				-o $(NAME)

hook/cmake-build-release-docker-mingw15/dinput8.dll:
	make -C hook docker

hook: hook/cmake-build-release-docker-mingw15/dinput8.dll

release: test gen hook
	$(MAKE) GOOS=linux build
	$(MAKE) GOOS=windows build

full: release

.DEFAULT_GOAL := release
.PHONY: hook