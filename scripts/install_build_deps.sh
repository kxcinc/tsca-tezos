#! /bin/sh

set -e

script_dir="$(cd "$(dirname "$0")" && echo "$(pwd -P)/")"
src_dir="$(dirname "$script_dir")"

if [ -z "$WORKSPACE_ROOT" ]; then
    WORKSPACE_ROOT="$src_dir"
fi

. "$script_dir"/version.sh

if [ "$1" = "--dev" ]; then
    dev=yes
else
    dev=
fi

opam repository set-url tezos --dont-select $opam_repository || \
    opam repository add tezos --dont-select $opam_repository > /dev/null 2>&1

opam update --repositories --development

opam_dir="$WORKSPACE_ROOT/_opam"
echo "creating local opam switch at $opam_dir"
if [ ! -d "$opam_dir" ] ; then
    opam switch create "$WORKSPACE_ROOT" --repositories=tezos ocaml-base-compiler.$ocaml_version
fi

if [ ! -d "$opam_dir" ] ; then
    echo "Failed to create the opam switch"
    exit 1
fi

eval $(opam env --shell=sh)

if [ -n "$dev" ]; then
    opam repository remove default > /dev/null 2>&1 || true
fi

if [ "$(ocaml -vnum)" != "$ocaml_version" ]; then
    opam install --unlock-base ocaml-base-compiler.$ocaml_version
fi

opam install --yes opam-depext

"$script_dir"/install_build_deps.raw.sh

if [ -n "$dev" ]; then
    opam repository add default --rank=-1 > /dev/null 2>&1 || true
    opam install merlin odoc --criteria="-changed,-removed"
fi
