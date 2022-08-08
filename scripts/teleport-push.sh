#!/usr/bin/env bash

# This script is used to sync a bunch of GitHub Actions from your local machine 
# to GHES, taking the tarball from `teleport-pull.sh`.

# Inputs
# $1: The tarball to sync to GHES
# $2: The GHES server to sync to (e.g. "https://github.yourcompany.com")
# $3: The GHES token to use (e.g. "ghp_123456789")

# Make the cache directory
mkdir -p tmp/

# Extract the tarball to the cache directory
tar -xzf "$1" -C tmp/

# For each directory in the archive, sync the Actions to GHES
actions-sync push --cache-dir "tmp/" --destination-url "$2" --destination-token "$3"

# Make the skills repositories templates
curl -s "$2"/api/v3/orgs/skills/repos --header "Authorization: token $3" | jq -r '.[].full_name' | while read -r line ; do
    curl -sS -X PATCH "$2"/api/v3/repos/"$line" --header "Authorization: token $3" --data '{"is_template":true}'
done

# Clean up the /tmp directory, but keep the tarball
rm -rf tmp/
