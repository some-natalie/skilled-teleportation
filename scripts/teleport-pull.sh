#!/usr/bin/env bash

# This script is used to sync a bunch of GitHub Actions from github.com to your
# local machine.  The finished output is a tarball you can then move into an
# airgapped environment to push into a GHES server using `teleport-push.sh`.

# Make a temp directory in the relative working directory
mkdir -p tmp/

# Sync github.com/skills
curl -s https://api.github.com/orgs/skills/repos | jq -r '.[].full_name' | while read -r line ; do
    actions-sync pull --cache-dir tmp/ --repo-name "$line"
done

# Sync what's in the list of dependencies Actions
grep -v '^#' ../skills-dependencies.txt | while read -r line ; do
    actions-sync pull --cache-dir tmp/ --repo-name "$line"
done

# Sync what's in the list of other Actions
grep -v '^#' extra-actions.txt | while read -r line ; do
    actions-sync pull --cache-dir tmp/ --repo-name "$line"
done

# Tarball everything in tmp directory
tar -czf teleport-archive.tar.gz -C tmp/ .

# Remove temp directory
rm -rf tmp/
