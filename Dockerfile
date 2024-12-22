# Base image for FreeRADIUS
FROM freeradius/freeradius-server:latest

# Install only necessary dependencies for Oracle Instant Client and FreeRADIUS
RUN apt-get update && apt-get install -y \
    nano \
	libaio1 \
    libc6 \
    libstdc++6 \
    wget \
    unzip \
    alien && \
    # Download the full Oracle Instant Client packages
    wget -q https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-basic-21.3.0.0.0-1.x86_64.rpm && \
    wget -q https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-tools-21.3.0.0.0-1.x86_64.rpm && \
    # Use alien to convert and install the RPM packages
    alien -i --scripts oracle-instantclient-basic-21.3.0.0.0-1.x86_64.rpm && \
    alien -i --scripts oracle-instantclient-tools-21.3.0.0.0-1.x86_64.rpm && \
    # Clean up the downloaded RPM files
    rm -f oracle-instantclient-basic-21.3.0.0.0-1.x86_64.rpm oracle-instantclient-tools-21.3.0.0.0-1.x86_64.rpm && \
    # Remove unnecessary build dependencies
    apt-get purge -y wget unzip alien && \
    # Remove cached files to reduce image size
    rm -rf /var/lib/apt/lists/*

# Set Oracle environment variables
ENV ORACLE_HOME=/usr/lib/oracle/21/client64
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV TNS_ADMIN=$ORACLE_HOME/network/admin

# Copy the custom FreeRADIUS configuration directory into the container
COPY raddb/ /etc/raddb/

# Expose RADIUS ports (authentication and accounting)
EXPOSE 1812/udp
EXPOSE 1813/udp

# Command to run FreeRADIUS
CMD ["freeradius", "-X"]
