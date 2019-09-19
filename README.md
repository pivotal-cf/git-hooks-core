# git-hooks-core

> *An opinionated use of the `core.hooksPath` feature released in Git 2.9.*

## ABOUT

This repository is meant to be used as the directory that the Git `core.hooksPath` config value is pointed at.

It exists because using the `core.hooksPath` feature is used in place of any local, repository-specific hooks in `.git/hooks`. This isn't necessarily what you want, as you may have repository-specific hooks that you want to run in addition to some hooks that should be global.

If you use this repository as your `core.hooksPath`, you will be able to:

* Retain any repository-specific hooks in `.git/hooks`
* Add hooks that will apply to all repositories in their respective *.d* folder
* Use multiple files for hooks rather than a single file, as Git expects
* Whitelist specific repositories against specific hooks (See [Whitelists](https://github.com/pivotal-cf/git-hooks-core#optional-setting-whitelists))

And now that the hooks dir is outside of your repository, you can commit the global hooks. Hooray!

## INSTALLATION

### Installing cred-alert-cli

This repo comes with some hooks that depend on `cred-alert-cli`.

To install the `cred-alert-cli` binary download the version for your OS
([macOs][cred-alert-osx] or [Linux][cred-alert-linux]), rename it to `cred-alert-cli`,
make it executable, and move it to a directory in `${PATH}`.

```
os_name=$(uname | awk '{print tolower($1)}')
curl -o cred-alert-cli \
  https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_${os_name}
chmod 755 cred-alert-cli
mv cred-alert-cli /usr/local/bin # <= or other directory in ${PATH}
cred-alert-cli --help # <= make sure cred-alert-cli works.
```

[cred-alert-osx]: https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_darwin
[cred-alert-linux]: https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_linux

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

### (Optional) Setting whitelists

Whitelist inform git-hooks-core to ignore certain repos. This is handy for private repos containing secret keys.
The structure of whitelist is as follows:

```
.
├── whitelists      # contains a mapping of hooks to whitelists
└── whitelists.d    # contains whitelists
    └── cred-alert  # a whitelist
```

All you need to do it to add the absolute path of your whitelist repo to file whitelist.d/cred-alert

For example, a continuous-integration repo contains secret keys and which need to put it to the whitelist.
` echo $HOME/workspace/continuous-integration >> whitelists.d/cred-alert`

#### Additional whitelist customizations

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

CLI Binaries:

* [OSX][cred-alert-osx]
* [Linux][cred-alert-linux]
