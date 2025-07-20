#!/usr/bin/env bash
set -euo pipefail

echo "Starting Voting App deployment..."

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

echo "Installing backend gems..."
bundle install --without development test

echo "Setting up SQLite database..."
if [ ! -f storage/production.sqlite3 ]; then
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
VITE_API_BASE_URL=https://voting-app.t0nylombardi.dev yarn build

cd ..

echo "deploy.sh completed!"
