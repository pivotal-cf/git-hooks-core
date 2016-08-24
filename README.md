# git-hooks-core

> *An opinionated use of the `core.hooksPath` feature released in Git 2.9.*

## ABOUT

This repository is meant to be used as the directory that the Git `core.hooksPath` config value is pointed at.

It exists because using the `core.hooksPath` feature is used in place of any local, repository-specific hooks in `.git/hooks`. This isn't necessarily what you want, as you may have repository-specific hooks that you want to run in addition to some hooks that should be global.

If you use this repository as your `core.hooksPath`, you will be able to:

* Retain any repository-specific hooks in `.git/hooks`
* Add hooks that will apply to all repositories in their respective *.d* folder
* Use multiple files for hooks rather than a single file, as Git expects

And now that the hooks dir is outside of your repository, you can commit the global hooks. Hooray!

## INSTALLATION

Clone this repo to your directory of choice. Git recommends using `/etc/git/hooks` on Linux:

```
git clone https://github.com/pivotal-cf-experimental/git-hooks-core
```

This repo comes with some hooks by default that depend on
[cred-alert](https://github.com/pivotal-cf/cred-alert/releases/latest). You'll
need to download the latest release and put it in your PATH somewhere for the
hooks to work.

## USAGE

Point `core.hooksPath` at the directory you cloned this repo to:

```
git config --global --add core.hooksPath /etc/git/hooks
```

Add any global hooks you'd like to their respective *.d* folder:

```
cp my-commit-msg-hook /etc/git/hooks/commit-msg.d
chmod +x /etc/git/hooks/commit-msg.d
```

## LINKS

* [githooks](https://git-scm.com/docs/githooks)
* [cred-alert](https://github.com/pivotal-cf/cred-alert)
