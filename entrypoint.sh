#!/bin/bash

set -e

SSH_KEY_PATH=~/.ssh/id_rsa
APP_DIR=/rails_root

git remote set-url origin "${REPO_PATH}"
git config --global user.email "${GITHUB_EMAIL}"
git config --global user.name "${GITHUB_NAME}"
bundle config path ~/.gem/ruby

if ! git ls-remote "${REPO_PATH}" >/dev/null 2>&1; then
  echo "Either the specified repository path, ${REPO_PATH}, does not exist, or the given SSH key does not have access to it."
  
  if [ ! -s ${SSH_KEY_PATH} ]; then
    echo "Note that ${SSH_KEY_PATH} appears to be empty. Ensure that the SSH key mounts in docker-compose.yml are valid."
  fi

  exit 1
fi

cd "${APP_DIR}"
if [ -z "$(ls -A .)" ]; then
  echo "Cloning ${REPO_PATH} into $(pwd)..."
  git clone "${REPO_PATH}" .
  
  if [ ! -s Gemfile ]; then
    echo "Gemfile not found. Initializing project..."
    eval "${RAILS_NEW_CMD}"

    echo "Creating database..."
    cat /database.yml > "${APP_DIR}/config/database.yml"
    bin/rails db:create

    echo "Pushing initial commit to ${REPO_PATH}..."
    git add -A
    git commit -m "initialized rails app"
    git push -u origin main
  fi
fi

echo "Running bundle install..."
bundle install

echo "Handing off execution..."
exec "$@"
