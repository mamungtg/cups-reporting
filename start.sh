#!/bin/bash
set -e

# Ensure jobs.db exists at runtime
if [ ! -f /app/jobs.db ]; then
  echo "Initializing jobs.db..."
  sqlite3 /app/jobs.db < /app/init.sql
  chown -R $(whoami) /app/jobs.db
fi

# Start CUPS
echo "Starting CUPS..."
cupsd -f &

# Start Flask app
echo "Starting Flask..."
python3 /app/app.py
