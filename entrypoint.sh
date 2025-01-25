#!/bin/bash

set -e

SSH_KEY_PATH=~/.ssh/id_rsa
APP_DIR=/rails_root

if [ -z "${REPO_PATH}" ] || [ -z "${GITHUB_EMAIL}" ] || [ -z "${GITHUB_NAME}" ] || [ -z "${RAILS_NEW_CMD}" ]; then
  echo "ERROR: One or more of the following environment variables are not set in .env:"
  echo "REPO_PATH, GITHUB_EMAIL, GITHUB_NAME, RAILS_NEW_CMD"
  echo "See README.md and .env.sample for help configuring these values. Exiting."
  exit 1
fi

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
    echo "Gemfile not found. Initializing project with '${RAILS_NEW_CMD}'..."
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
