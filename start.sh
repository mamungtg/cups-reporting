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

# Always reset perms
chmod 777 /data
chmod 666 /data/jobs.db || true

# Start CUPS in background
echo "Starting CUPS..."
/usr/sbin/cupsd -f &

# Give CUPS a second to settle
sleep 2

# Start Flask as PID 1 (keeps container alive)
echo "Starting Flask..."
exec python3 -m flask run --host=0.0.0.0 --port=5000 --no-debugger
