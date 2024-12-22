FROM freeradius/freeradius-server:latest

# Install dependencies for Oracle Instant Client and nano text editor
RUN apt-get update && apt-get install -y \
    nano \
    libaio1 \
    wget \
    unzip \
    alien && \
    wget -q https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-basiclite-21.3.0.0.0-1.x86_64.rpm && \
    wget -q https://download.oracle.com/otn_software/linux/instantclient/213000/oracle-instantclient-sqlplus-21.3.0.0.0-1.x86_64.rpm && \
    alien -i oracle-instantclient-basiclite-21.3.0.0.0-1.x86_64.rpm && \
    alien -i oracle-instantclient-sqlplus-21.3.0.0.0-1.x86_64.rpm && \
    rm -f oracle-instantclient-basiclite-21.3.0.0.0-1.x86_64.rpm oracle-instantclient-sqlplus-21.3.0.0.0-1.x86_64.rpm && \
    rm -rf /var/lib/apt/lists/*

# Set Oracle environment variables
ENV ORACLE_HOME=/usr/lib/oracle/21/client64
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV TNS_ADMIN=$ORACLE_HOME/network/admin
ENV PATH=$ORACLE_HOME/bin:$PATH

# Copy the custom FreeRADIUS configuration directory into the container
COPY raddb/ /etc/raddb/

# Expose RADIUS ports (authentication and accounting)
EXPOSE 1812/udp
EXPOSE 1813/udp

# Command to run FreeRADIUS
CMD ["freeradius", "-X"]
