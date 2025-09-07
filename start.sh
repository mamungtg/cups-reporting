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

# Start CUPS in background
echo "Starting CUPS..."
cupsd -f &

# Sleep briefly to let CUPS settle
sleep 2

# Start Flask and replace shell with it
echo "Starting Flask..."
exec python3 /app/app.py
