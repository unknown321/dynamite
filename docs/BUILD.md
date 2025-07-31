Build requirements:

  - Docker
  - internet connection

Preparing (build toolchain docker image, takes a while):

```shell
make prepare
```

Build:

```shell
make release
```

Grab `dynamite-<OS>-amd64` binary in main directory.

### Dockerless build:

Alternatively, you'll need: 
  - CMake
  - Make
  - C++23 compiler
  - Go >= v1.24.5

Building hook:

```shell
cd hook
# directory name is important, see hook/embed.go
mkdir cmake-build-release-docker-mingw15
cd cmake-build-release-docker-mingw15
cmake ..
make
```

Building installer for your current platform:

```shell
go build .
```

Consult Makefile for more options.