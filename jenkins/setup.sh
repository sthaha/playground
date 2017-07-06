#!/usr/bin/bash
set -e -u

declare -r SCRIPT_PATH=$(readlink -f $0)
declare -r SCRIPT_DIR=$(cd $(dirname $SCRIPT_PATH) && pwd)

execute() {
  echo "Running: $@"
  $@
}

main() {
  docker volume create --name jenkins_gitolite_sshkeys
  docker volume create --name jenkins_gitolite_git
  docker run --rm \
      -e SSH_KEY="$(cat gitolite-admin.pub)" \
      -e SSH_KEY_NAME="admin" \
      -v jenkins_gitolite_sshkeys:/etc/ssh/keys \
      -v jenkins_gitolite_git:/var/lib/git \
    jgiannuzzi/gitolite true

  return $?
}

main "$@"
