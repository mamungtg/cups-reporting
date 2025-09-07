FROM python:3.10-slim

# Install CUPS + SQLite
RUN apt-get update && apt-get install -y \
    cups \
    cups-client \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Copy reporting app
WORKDIR /app
COPY reporting/ /app/

# Initialize SQLite database
COPY reporting/init.sql /app/init.sql
RUN sqlite3 /app/jobs.db < /app/init.sql

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Install Python dependencies
RUN pip install --no-cache-dir flask pandas matplotlib

# Expose ports
EXPOSE 631 5000

# Start both services
CMD ["/start.sh"]
