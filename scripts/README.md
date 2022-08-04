# Scripts

These shell scripts form a less-Actions-oriented way to accomplish what you can in [the main README](../README.md).  The `pull` script runs [actions-sync](https://github.com/actions/actions-sync) to create a tarball, then the `push` script puts it into GitHub Enterprise Server using the same program, as shown in the example below.

These scripts are not used by the GitHub Action.

You'll need the following installed to pull/push:

- [actions-sync](https://github.com/actions/actions-sync)
- Bash
- `tar`
- `curl`
- `grep`

Additionally, you'll need to have an account that has the ability to create organizations if they don't exist and write to the ones that do on your GitHub Enterprise Server.

To pull iteratively over all [github.com/skills](https://skills.github.com) and the contents of `teleport-list.txt`:

```shell
./teleport-pull.sh
```

Then to push it to GitHub Enterprise Server:

```shell
./teleport-push.sh \
    teleport-archive.tar.gz \
    https://github.yourcompany.com \
    github_token_goes_here
```

It assumes that the token you give it has the ability to create organizations if needed, and write access to all the organizations you have already synced prior.
