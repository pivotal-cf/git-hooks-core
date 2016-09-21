# git-hooks-core

> *An opinionated use of the `core.hooksPath` feature released in Git 2.9.*

## ABOUT

This repository is meant to be used as the directory that the Git `core.hooksPath` config value is pointed at.

It exists because using the `core.hooksPath` feature is used in place of any local, repository-specific hooks in `.git/hooks`. This isn't necessarily what you want, as you may have repository-specific hooks that you want to run in addition to some hooks that should be global.

If you use this repository as your `core.hooksPath`, you will be able to:

* Retain any repository-specific hooks in `.git/hooks`
* Add hooks that will apply to all repositories in their respective *.d* folder
* Use multiple files for hooks rather than a single file, as Git expects
* Whitelist specific repositories against specific hooks (See [Whitelists](https://github.com/pivotal-cf-experimental/git-hooks-core#whitelists))

And now that the hooks dir is outside of your repository, you can commit the global hooks. Hooray!

## INSTALLATION

Clone this repo to your directory of choice, e.g. $HOME/workspace/git-hooks-core.

```
git clone https://github.com/pivotal-cf-experimental/git-hooks-core $HOME/workspace/git-hooks-core
```

This repo comes with some hooks by default that depend on
[cred-alert](https://github.com/pivotal-cf/cred-alert/releases/latest). You'll
need to download the latest release and put it in your PATH somewhere for the
hooks to work.

### CUSTOMIZATION

If you're a Pivotal team and you would like your own collection of hooks then
please add a branch to this repository with the name `team/<team-name>`. For example,
if I was on a security team I would push a branch to `team/pcf-security`. We originally
wanted to have people fork this repository but that requires administrator access
for the destination organization.

If you use `sprout-git` to install this then you can use the `sprout.git.hooks.revision`
attribute to set the branch you would like to use.

### CRED-ALERT

You can download the `cred-alert-cli` binary for [OS X][cred-alert-osx] and
[Linux][cred-alert-linux]. Make sure to move it to your `PATH`, rename it to
`cred-alert-cli`, and make it executable.

[cred-alert-osx]: https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_darwin
[cred-alert-linux]: https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_linux

## USAGE

Point `core.hooksPath` at the directory you cloned this repo to:

```
git config --global --add core.hooksPath $HOME/workspace/git-hooks-core
```

Add any global hooks you'd like to their respective *.d* folder:

```
chmod +x my-commit-msg-hook
cp my-commit-msg-hook $HOME/workspace/git-hooks-core/commit-msg.d
```

### Whitelists

This repository supports whitelisting repositories against specific files in
the *hook_name*.d folders.

The `whitelists` file within git-hooks-core is used to declare which hooks are
affected by the whitelists that live in `whitelists.d/`. The structure is as
follows:

```
$HOOK_PATH $WHITELIST
```

Where `HOOK_PATH` is a relative path pointing to a file in a *hook_name*.d
folder in the git-hooks-core directory and `WHITELIST` is the name of the file
that resides in `git-hooks-core/whitelists.d/`.

Each whitelist file should contain absolute paths to the repositories that the
whitelist affects. For example, if you had a repository
`/home/username/my-repo` that you wanted to whitelist against a commit-msg hook
called `add_footer`, you would:

1. Create a file, `git-hooks-core/whitelists.d/my-whitelist` with a single entry: `/home/username/my-repo`
1. Add an entry to git-hooks-core/whitelists: `commit-msg.d/add_footer my-whitelist`

`git-hooks-core/whitelists` has been preconfigured with entries for the
(initially empty) cred-alert whitelist in `whitelists.d`.

## LINKS

* [githooks](https://git-scm.com/docs/githooks)
* [cred-alert](https://github.com/pivotal-cf/cred-alert)
