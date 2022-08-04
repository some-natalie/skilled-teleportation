#!/usr/bin/env bash

# This script is used to sync a bunch of GitHub Actions from your local machine 
# to GHES, taking the tarball from `teleport-pull.sh`.

# Inputs
# $1: The tarball to sync to GHES
# $2: The GHES server to sync to (e.g. "https://github.yourcompany.com")
# $3: The GHES token to use (e.g. "ghp_123456789")

# Untar the tarball
mkdir -p tmp/
tar -xzf "$1" -C tmp/ && rm -rf "$1"

# For each directory in the archive, sync the Actions to GHES
actions-sync push --cache-dir "tmp/" --destination-url "$2" --destination-token "$3"
