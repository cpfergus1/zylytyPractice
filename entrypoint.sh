#!/bin/bash
set -e

rm -f /myapp/tmp/pids/server.pid

# Check environment variables
: "${DB_HOST:?DB_HOST not set}"
: "${DB_PASSWORD:?DB_PASSWORD not set}"
: "${DB_PORT:?DB_PORT not set}"
: "${DB_USERNAME:?DB_USERNAME not set}"
: "${RAILS_ENV:?RAILS_ENV not set}"
: "${API_LISTENING_PORT:?API_LISTENING_PORT not set}"
: "${SECRET_KEY_BASE:=$(openssl rand -hex 64)}"
: "${JWT_SECRET:=$(openssl rand -hex 64)}"

echo "Using SECRET_KEY_BASE: $SECRET_KEY_BASE"
echo "Using JWT_SECRET: $JWT_SECRET"

export SECRET_KEY_BASE
export JWT_SECRET

# Wait for the database to be ready
while ! nc -z $DB_HOST $DB_PORT; do
  echo "Waiting for the database to be ready..."
  sleep 2
done

# Initialize the database
rails db:prepare
rails db:seed

echo "Database is up - executing command"
exec "$@"
