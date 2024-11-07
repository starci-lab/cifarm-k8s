#!/usr/bin/env bash

# Export env vars
echo "Loading .env.local..."
export $(grep -v '^#' .env.local | xargs)

echo "Loading .env.secret..."
export $(grep -v '^#' .env.secret | xargs)