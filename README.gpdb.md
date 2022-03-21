## ABOUT

This is the global common git hooks used inside VMWare Greenplum team. Please follow this document to make the minimal settings. Please refer to [README](README.md) for More advanced usages.

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

### (Optional) Setting cread-alert whitelists for gp-continuous-integration

To be able to commit secret to [gp-continuous-integration repo](), add it to the whitelists by:

```
echo $HOME/workspace/gp-continuous-integration >> whitelists.d/cred-alert
```

## VERIFY IT ALL WORKS

```
mkdir $HOME/workspace/cred-alert-test; cd $HOME/workspace/cred-alert-test; git init; cat <<'EOF'> test.key
-----BEGIN RSA PRIVATE KEY-----
fakersakeydata
-----END RSA PRIVATE KEY-----
EOF
git add test.key;
git commit -m "Testing credential commit" # You should see a warning after this command
mv $HOME/workspace/cred-alert-test /tmp
```
