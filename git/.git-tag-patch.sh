#!/bin/bash
set -e

V=$(git describe --tags --abbrev=0)

major=$(echo "$V" | cut -d "." -f 1)
minor=$(echo "$V" | cut -d "." -f 2)
patch=$(($(echo "$V" | cut -d "." -f 3) + 1))

newV="$major.$minor.$patch"

git tag --annotate --message "$newV" --edit "$newV"
