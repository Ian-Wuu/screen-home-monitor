#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
git diff --quiet || { echo 'Stage source changes before packaging.' >&2; exit 1; }
mkdir -p dist
# Export the index, not the working directory: ignored private data stays local.
tree=$(git write-tree)
git archive --format=zip --prefix=screen-home-monitor/ "$tree" -o dist/screen-home-monitor-source.zip
echo 'Created dist/screen-home-monitor-source.zip from the Git index.'
