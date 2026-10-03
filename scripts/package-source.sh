#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
git diff --quiet || { echo 'Stage source changes before packaging.' >&2; exit 1; }
mkdir -p dist
# Export the index, not the working directory: ignored private data stays local.
tree=$(git write-tree)
git archive --format=zip --prefix=ai-screen-stream/ "$tree" -o dist/ai-screen-stream-source.zip
echo 'Created dist/ai-screen-stream-source.zip from the Git index.'
