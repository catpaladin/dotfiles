#!/usr/bin/env bash

# Install nvim deps
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.60.1
go install github.com/segmentio/golines@latest
go install mvdan.cc/gofumpt@latest
go install github.com/incu6us/goimports-reviser/v3@latest
go install github.com/cweill/gotests/gotests@latest
go install golang.org/x/tools/cmd/godoc@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# Install go tools
go install github.com/spf13/cobra-cli@latest
go install github.com/air-verse/air@latest
go install github.com/swaggo/swag/cmd/swag@latest
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install python tools (requires rust cargo path)
if [ ! -f ~/.cargo/bin/uv ] ; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
if [ ! -f ~/.cargo/bin/ruff ] ; then
  curl -LsSf https://astral.sh/ruff/install.sh | sh
fi
if [ ! -f ~/.rye/shims/rye ] ; then
  curl -sSf https://rye.astral.sh/get | bash
fi
