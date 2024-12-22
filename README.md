# 🐳 FreeRADIUS Docker Image

[![Docker](https://img.shields.io/badge/Docker-Image-blue?logo=docker)](https://hub.docker.com/r/devzami/freeradius)

This repository contains a Dockerfile to build a FreeRADIUS server with Oracle Instant Client support, along with basic configurations for testing.

## 🚀 Quick Start

### 🛠️ Build the Docker Image

To build the FreeRADIUS Docker image locally, run the following command:

```bash
docker build -t freeradius -f Dockerfile .
```

This command will create a Docker image with FreeRADIUS and Oracle Instant Client dependencies installed.

### 🐳 Run the Docker Container

Once the image is built, start the FreeRADIUS container using the following command:

```bash
docker run --rm -d --name freeradius -p 1812-1813:1812-1813/udp freeradius
```

This command will run the FreeRADIUS server in detached mode (`-d`) and expose ports 1812 (Authentication) and 1813 (Accounting) on your host machine.

### 🔧 Install and Test with radtest

To test the server using the `radtest` utility, follow these steps:

1. **Install radtest** utility (if not already installed):

   On **Ubuntu/Debian**:
   ```bash
   sudo apt-get install freeradius-client
   ```

   On **CentOS/RHEL**:
   ```bash
   sudo yum install freeradius-client
   ```

2. **Test the FreeRADIUS server locally** using the following command:

   ```bash
   radtest bob test 127.0.0.1 0 testing123
   ```

   This should return a response indicating that the test user `bob` has been successfully authenticated.

### 🐚 Access the Container and Test Internally

To access the FreeRADIUS container and run the test internally, use:

```bash
docker exec -it freeradius bash
```

Once inside the container, test using the container's local IP address:

```bash
radtest bob test 172.17.0.1 0 testing123
```

### 📂 Configuration Files

The container includes the following configuration files for testing purposes:

- **clients.conf**: Defines the client configuration for the FreeRADIUS server.

  Example of `clients.conf`:
  ```bash
  client dockernet {
      ipaddr = 172.17.0.0/16
      secret = testing123
  }
  ```

- **authorize**: Defines the test user for authentication.

  Example of `authorize` file:
  ```bash
  bob    Cleartext-Password := "test"
  ```

- **sql.conf**: Configures SQL-related settings for database interaction (this is left for you to configure based on your setup).
  Example of `authorize` file:
  ```bash
  sql {
       driver = "oracle"
       server = "oracle-server"
       port = 1521
       login = "schema-username"
       password = "schema-password"
       radius_db = "oracle_sid"
   }
  ```

### 📦 Dependencies

The FreeRADIUS server container includes the following dependencies:

- **FreeRADIUS Server**: Base image for FreeRADIUS.
- **Oracle Instant Client**: Installed to allow integration with Oracle databases.
- **nano**: Text editor for easy file editing inside the container.
- **libaio1**: A library required for Oracle Instant Client.

### 🔒 Exposed Ports

The FreeRADIUS container exposes the following ports:

- **1812/UDP**: Authentication (RADIUS).
- **1813/UDP**: Accounting (RADIUS).

### 🧹 Clean Up

The build process cleans up unnecessary files, including:

- The **RPM** package for Oracle Instant Client after installation.
- Temporary **apt** cache files to reduce the image size.

### 🛠️ Customizing Configuration

You can modify the configuration files in the `raddb/` directory to suit your specific requirements. These files will be copied into the container during the build process.

---

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### 🔑 Support

For any issues or support requests, feel free to open an issue in this repository.
