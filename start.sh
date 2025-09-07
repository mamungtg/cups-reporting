#!/bin/bash
set -e

# Ensure jobs.db exists
if [ ! -f /app/jobs.db ]; then
  echo "Initializing jobs.db..."
  sqlite3 /app/jobs.db < /app/init.sql
fi

# Start CUPS in foreground (backgrounded here)
echo "Starting CUPS..."
cupsd -f &

# Start Flask app
echo "Starting Flask reporting app..."
python3 /app/app.py
