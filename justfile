set dotenv-load := true
set export := true
set positional-arguments := true

NAME := "ipset-fast-update"

default:
    @just --list

#
# clean
#

clean:
    rm -rf dist
    mkdir -p dist

#
# release
#

snapshot:
    goreleaser release --skip=publish --clean --snapshot

release:
    goreleaser release --skip=publish --clean --skip=validate
