#!/usr/bin/env bash
set -euo pipefail

echo "Starting Voting App deployment..."

echo "Installing backend gems..."
bundle install --without development test

echo "Setting up SQLite database..."
if [ ! -f db/production.sqlite3 ]; then
  echo "Creating new SQLite database..."
  RAILS_ENV=production bundle exec rails db:setup
else
  echo "Migrating existing database..."
  RAILS_ENV=production bundle exec rails db:migrate
fi

echo "Installing frontend dependencies..."
cd frontend
yarn install --frozen-lockfile

echo "Building frontend..."
yarn build

cd ..

echo "deploy.sh completed!"
