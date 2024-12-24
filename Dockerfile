# Base image for FreeRADIUS
FROM freeradius/freeradius-server:latest

# Install only necessary dependencies for Oracle Instant Client and FreeRADIUS
RUN apt-get update && apt-get install -y \
    nano && \
    # Remove cached files to reduce image size
    rm -rf /var/lib/apt/lists/*

# Copy the custom FreeRADIUS configuration directory into the container
COPY raddb/ /etc/raddb/

# Expose RADIUS ports (authentication and accounting)
EXPOSE 1812/udp
EXPOSE 1813/udp

# Command to run FreeRADIUS
CMD ["freeradius", "-X"]
