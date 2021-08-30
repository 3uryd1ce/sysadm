# shellcheck disable=SC2154 shell=sh
# 'common.sh' is a file with frequently used functions. its purpose is
# to be sourced in scripts for readability purposes and ease of
# management. therefore, it has no shebang and isn't executable.

# instead of remembering/accounting for two different forms of privilege
# elevation, one is assigned to the alias 'priv.' doas is preferred over
# sudo.
if [ -x "$(command -v 'doas')" ]; then
  alias priv='doas '
elif [ -x "$(command -v 'sudo')" ]; then
  alias priv='sudo '
fi

# reads from STDIN and checks that all commands needed are executable
# and available.
#
# note that I only check executables that aren't accounted for in dotfiles.
check_deps() {
  while read -r -- dependency; do
    if [ -x "$(command -v -- "${dependency}")" ]; then
      continue
    else
      err "${dependency} not found in PATH or not executable."
    fi
  done
}

# err() is the generic way to print an error message and exit a script.
# all of its output goes to STDERR.
#
# print everything passed as an argument.
# exit with a return code of 1.
err() {
  printf '%s\n' "$*" >&2
  exit 1
}

# if the user isn't root, print an error message and exit.
must_be_root() {
  [ "$(id -u)" = 0 ] || err "Execute ${0##*/} with root privileges."
}

# print date in yyyy-mm-dd format.
today() { date '+%F'; }
