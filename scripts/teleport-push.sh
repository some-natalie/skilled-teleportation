#!/usr/bin/env bash

# This script is used to sync a bunch of GitHub Actions from your local machine
# to GHES, taking the extracted ZIP archive from the Actions run or extracted
# tarball from `teleport-pull.sh`.

# Inputs
# $1: The GHES server to sync to (e.g. "https://github.yourcompany.com")
# $2: The GHES token to use (e.g. "ghp_123456789")

# For each directory in the archive, sync the Actions to GHES
echo "Syncing Actions to GHES..."
actions-sync push --cache-dir "./cache" --destination-url "$1" --destination-token "$2"

# Set the headers for curl
HEADER="Authorization: token $2"

# Remove the trailing slash from the server URL if it exists
if [[ "$1" == *"/" ]]; then
    URL="${1::-1}"
else
    URL="$1"
fi

# Make the skills repositories templates
echo "Making the skills repositories templates..."
curl -s --header "$HEADER" "$URL"/api/v3/orgs/skills/repos | jq -r '.[].full_name' | while read -r line ; do
   curl -sS -o /dev/null --show-error --fail -X PATCH --header "$HEADER" "$URL"/api/v3/repos/"$line" --data '{"is_template":true}'
done

# Make the starter Actions templates
echo "Making the starter Actions templates..."
starters=("typescript-action" "javascript-action" "hello-world-docker-action" "hello-world-javascript-action" "container-action" "container-toolkit-action")

for i in "${starters[@]}" ; do
    curl -sS -o /dev/null --show-error --fail -X PATCH --header "$HEADER" "$URL"/api/v3/repos/actions/"$i" --data '{"is_template":true}' || true
done

