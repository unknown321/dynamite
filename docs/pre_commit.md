# Pre-commit Configuration

This project is enabled with pre-commit for proper code formatting and styling to catch bugs, beautify source code for easier debugging as well as making the code more reviewable. 

## Prerequisites

* [pre-commit](https://pre-commit.com/#installation)
* golangci-lint
* goimports

## Installation

## pre-commit

```
pip install pre-commit

pre-commit install # Ensures that pre-commmit runs on git commit
```

### golanci-lint

```
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

### goimports

```
go install golang.org/x/tools/cmd/goimports@latest
```

## Usage

You can run `pre-commit` manually with
```
pre-commit run --all-files
```

## Hooks
The following hooks are enabled:
* end-of-file-fixer → Ensures files end with a single newline.
* trailing-whitespace → Removes trailing whitespace from lines.
* stylua → Automatically formats Lua code according to stylua style rules.
* go-imports → Formats Go code and automatically organizes imports.
* go-mod-tidy → Runs go mod tidy to keep go.mod and go.sum clean.
