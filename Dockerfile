FROM python:3.10-slim

# Install CUPS + SQLite
RUN apt-get update && apt-get install -y \
    cups \
    cups-client \
    sqlite3 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy reporting app
WORKDIR /app
COPY reporting/ /app/

# Copy schema (fixed path)
COPY init.sql /app/init.sql

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Install Python dependencies
RUN pip install --no-cache-dir flask pandas matplotlib requests

# Expose ports
EXPOSE 631 5000

# Start services
CMD ["/start.sh"]
