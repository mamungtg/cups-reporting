FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    cups \
    python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python libs
RUN pip3 install flask pandas matplotlib sqlalchemy

# Copy reporting app
WORKDIR /app
COPY reporting/ /app/

# Expose CUPS (631) and Flask (5000)
EXPOSE 631 5000

# Start CUPS + Python app
CMD service cups start && python3 app.py
