#!/usr/bin/env bash
set -e

report_status() {
  local exit_status=$?

  if [ $exit_status -eq 0 ]; then
    printf "\e[32m
 ___ _   _  ___ ___ ___  ___ ___
/ __| | | |/ __/ __/ _ \/ __/ __|
\__ \ |_| | (_| (_|  __/\__ \__ \\
|___/\__,_|\___\___\___||___/___/\n
    \e[0m\n"
  else
    printf "\e[31m
  ___ _ __ _ __ ___  _ __
 / _ \ '__| '__/ _ \| '__|
|  __/ |  | | | (_) | |
 \___|_|  |_|  \___/|_| \n
    \e[0m\n"
  fi
}

trap report_status EXIT

mix test
mix format --check-formatted
mix compile --warnings-as-errors
mix dialyzer

# Got some things we need to address before we can enable this.
# mix credo --strict

# If the script stops here you'll need to:
# 1. Unlock the dependency `mix deps.unlock some_dep`
# 2. Remove the dependency `mix deps.clean some_dep`
mix deps.unlock --check-unused

# Including this locally, but not in the CI pipeline.
# It's last in the list so you can ignore it,
# but it's there as a friendly reminder.
# mix hex.outdated
