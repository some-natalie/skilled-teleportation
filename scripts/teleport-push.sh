#!/usr/bin/env bash

# This script is used to sync a bunch of GitHub Actions from your local machine 
# to GHES, taking the extracted ZIP archive from the Actions run or extracted
# tarball from `teleport-pull.sh`.

# Inputs
# $1: The GHES server to sync to (e.g. "https://github.yourcompany.com")
# $2: The GHES token to use (e.g. "ghp_123456789")

# For each directory in the archive, sync the Actions to GHES
actions-sync push --cache-dir "./cache" --destination-url "$1" --destination-token "$2"

# Make the skills repositories templates
curl -s "$1"/api/v3/orgs/skills/repos --header "Authorization: token $2" | jq -r '.[].full_name' | while read -r line ; do
    curl -sS -X PATCH "$1"/api/v3/repos/"$line" --header "Authorization: token $2" --data '{"is_template":true}'
done

# Make the starter Actions templates
starters=("typescript-action" "javascript-action" "hello-world-docker-action" "hello-world-javascript-action" "container-action" "container-toolkit-action")

for i in "${starters[@]}" ; do
    curl -sS -X PATCH "$1"/api/v3/repos/actions/"$i" --header "Authorization: token $2" --data '{"is_template":true}' || true
done
