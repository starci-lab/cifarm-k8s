#!/usr/bin/env bash

# Install dos2unix
if ! dpkg-query -l | grep -q dos2unix; then
  sudo apt-get install -y dos2unix
else
  echo "dos2unix is already installed, skipping."
fi

# Export env vars
echo "Loading .env.local..."
dos2unix .env.local
export $(grep -v '^#' .env.local | xargs)

echo "Loading .env.secret..."
dos2unix .env.secret
export $(grep -v '^#' .env.secret | xargs)

#Path: source load-dev-env.sh