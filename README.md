# git-hooks-core

> *An opinionated use of the `core.hooksPath` feature released in Git 2.9.*

## ABOUT

This repository is meant to be used as the directory that the Git `core.hooksPath` config value is pointed at.

It exists because using the `core.hooksPath` feature is used in place of any local, repository-specific hooks in `.git/hooks`. This isn't necessarily what you want, as you may have repository-specific hooks that you want to run in addition to some hooks that should be global.

If you use this repository as your `core.hooksPath`, you will be able to:

* Retain any repository-specific hooks in `.git/hooks`
* Add hooks that will apply to all repositories in their respective *.d* folder
* Use multiple files for hooks rather than a single file, as Git expects
* Excludelist specific repositories against specific hooks (See [Excludelist](https://github.com/pivotal-cf/git-hooks-core#optional-setting-excludelist))

And now that the hooks dir is outside of your repository, you can commit the global hooks. Hooray!

## INSTALLATION

### Installing cred-alert-cli

This repo comes with some hooks that depend on `cred-alert-cli`.

To install the `cred-alert-cli` binary, view the [latest release on GitHub](
https://github.com/pivotal-cf/cred-alert/releases/latest) and download either
`cred-alert-cli_darwin` (for macOS) or `cred-alert-cli_linux` (for Linux).
Rename it to `cred-alert-cli`, make it executable, and move it to a directory
in `${PATH}`.

### Installing git-hooks-core

Clone this repo to your directory of choice, e.g. $HOME/workspace/git-hooks-core.
Point `core.hooksPath` at the installation directory.

```
git clone https://github.com/pivotal-cf/git-hooks-core $HOME/workspace/git-hooks-core
git config --global --add core.hooksPath $HOME/workspace/git-hooks-core
```

### (Optional) Adding global hooks

Add any global hooks you'd like to their respective *.d* folder:

```
chmod +x my-commit-msg-hook
cp my-commit-msg-hook $HOME/workspace/git-hooks-core/commit-msg.d
```

### (Optional) Setting excludelist

Exludelist inform git-hooks-core to ignore certain repos. This is handy for private repos containing secret keys.
The structure of exlcudelist is as follows:

```
.
├── excludelist      # contains a mapping of hooks to excludelist
└── excludelist.d    # contains excludelist
    └── cred-alert  # a excludelist
```

All you need to do it to add the absolute path of your excludelist repo to file excludelist.d/cred-alert

For example, a continuous-integration repo contains secret keys and which need to put it to the excludelist.
` echo $HOME/workspace/continuous-integration >> excludelist.d/cred-alert`

#### Additional excludelist customizations

The `excludelist` file within git-hooks-core is used to declare which hooks are
affected by the excludelist that live in `excludelist.d/`. The structure is as
follows:

```
$HOOK_PATH $EXCLUDELIST
```

Where `HOOK_PATH` is a relative path pointing to a file in a *hook_name*.d
folder in the git-hooks-core directory and `EXCLUDELIST` is the name of the file
that resides in `git-hooks-core/excludelist.d/`.

Each exlcudelist file should contain absolute paths to the repositories that the
exlcudelist affects. For example, if you had a repository
`/home/username/my-repo` that you wanted to exlcudelist against a commit-msg hook
called `add_footer`, you would:

1. Create a file, `git-hooks-core/excludelist.d/my-exlcudelist` with a single entry: `/home/username/my-repo`
1. Add an entry to git-hooks-core/excludelist: `commit-msg.d/add_footer my-excludelist`

`git-hooks-core/excludelist` has been preconfigured with entries for the
(initially empty) cred-alert exlcudelist in `excludelist.d`.

## VERIFY IT ALL WORKS

```
mkdir $HOME/workspace/cred-alert-test; cd $HOME/workspace/cred-alert-test; git init; cat <<'EOF'>> test.key
-----BEGIN RSA PRIVATE KEY-----
fakersakeydata
-----END RSA PRIVATE KEY-----
EOF
git add test.key;
git commit -m "Testing credential commit" # You should see a warning after this command
mv $HOME/workspace/cred-alert-test /tmp
```

## CUSTOMIZATION

If you're a Pivotal team and you would like your own collection of hooks then
please add a branch to this repository with the name `team/<team-name>`. For example,
if I was on a security team I would push a branch to `team/pcf-security`. We originally
wanted to have people fork this repository but that requires administrator access
for the destination organization.

If you use `sprout-git` to install this then you can use the `sprout.git.hooks.revision`
attribute to set the branch you would like to use.

## LINKS

* [githooks](https://git-scm.com/docs/githooks)
* [cred-alert](https://github.com/pivotal-cf/cred-alert)
