#!/bin/bash
set -e

# Initialize DB if missing
if [ ! -f /app/jobs.db ]; then
  echo "Initializing jobs.db..."
  sqlite3 /app/jobs.db < /app/init.sql
fi

# Fix permissions (read/write for all users)
chmod 666 /app/jobs.db

# Start CUPS
echo "Starting CUPS..."
cupsd -f &

# Start Flask
echo "Starting Flask..."
python3 /app/app.py
