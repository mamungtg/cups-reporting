#!/bin/bash
set -e

# Ensure /data is writable
mkdir -p /data
chmod 777 /data

# Initialize DB if missing
if [ ! -f /data/jobs.db ]; then
  echo "Initializing jobs.db..."
  sqlite3 /data/jobs.db < /app/init.sql || true
  chmod 666 /data/jobs.db
fi

# Double check perms every run
chmod 777 /data
chmod 666 /data/jobs.db || true

# Start CUPS
echo "Starting CUPS..."
cupsd -f &

# Start Flask
echo "Starting Flask..."
python3 /app/app.py
