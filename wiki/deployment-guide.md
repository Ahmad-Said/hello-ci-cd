# Web Server Deployment Guide

This guide explains how to deploy a web application starting from a fresh Virtual Private Server (VPS) or a dedicated server with a public IP. We will use Docker and Nginx Proxy Manager (NPM) to expose services securely.

## 1. Prerequisites

- A **VPS or Dedicated Server** with a public IP address. *(New to this? Read about [VPS and Dedicated Servers](./vps-dedicated-server.md))*
- **Root or Sudo Access** to the server.
- A **Domain Name** (e.g., `example.com`).

## 2. Server Preparation

Ensure your server is accessible and the basic required ports are open.

### Firewall Configuration

*(New to this? Read our guide on [Firewalls and Ports](./firewall-ports.md))*

Your server must have the following ports open and accessible from the internet:

- **Port 80 (HTTP):** Used for initial traffic and Let's Encrypt SSL certificate generation.
- **Port 443 (HTTPS):** Used for secure web traffic.
- **Port 22 (SSH):** (Optional but recommended) Ensure your SSH port is accessible for server administration.

If you are using `ufw` (Uncomplicated Firewall) on Ubuntu/Debian:
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw enable
```

If your cloud provider (AWS, DigitalOcean, Hetzner, etc.) has an external firewall, make sure to open ports 80 and 443 in their dashboard as well.

## 3. DNS Configuration

*(New to this? Read our guide on [DNS Records](./dns-records.md))*

Point your domain name to your server's public IP address.

1. Go to your domain registrar's DNS settings.
2. Create an **A Record**.
3. Set the **Host/Name** to `@` (for the root domain) or a subdomain (e.g., `app`, `www`).
4. Set the **Value/Points To** to your server's public IP address.
5. (Optional) Create a Wildcard record (`*`) or CNAME records for other subdomains pointing to the same A record.

*Note: DNS propagation can take anywhere from a few minutes to up to 48 hours.*

## 4. Install Docker and Docker Compose

*(New to this? Read our guide on [Docker Basics](./docker-basics.md))*

We will deploy our applications and Nginx Proxy Manager using Docker.

Install Docker by running:
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Ensure Docker Compose is available (it's included in modern Docker installations as `docker compose`).

## 5. Deploy Nginx Proxy Manager

*(New to this? Read our guide on [Nginx Proxy Manager & Reverse Proxies](./nginx-proxy-manager.md))*

Nginx Proxy Manager provides a user-friendly web interface to manage reverse proxies, SSL certificates, and access lists.

1. Create a directory for Nginx Proxy Manager:
```bash
mkdir -p /opt/npm
cd /opt/npm
```

2. Create a `docker-compose.yml` file:
```yaml
version: '3.8'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      # These ports are in format <host-port>:<container-port>
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
```

3. Start the service:
```bash
docker compose up -d
```

4. Access the admin interface by navigating to `http://<your-server-ip>:81`.
   * Default Email: `admin@example.com`
   * Default Password: `changeme`
   * You will be prompted to change these upon first login.

## 6. Deploy Your Application (e.g., Frontend)

Now, let's deploy your actual web application using Docker. In this example, we deploy a simple frontend service.

1. Create a Docker network so NPM and your app can communicate securely:
```bash
docker network create web_network
```

2. Update NPM's `docker-compose.yml` to attach it to this network:
```yaml
version: '3.8'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '443:443'
      - '81:81'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    networks:
      - web_network

networks:
  web_network:
    external: true
```
Restart NPM with `docker compose down && docker compose up -d`.

3. Create a directory for your app:
```bash
mkdir -p /opt/my-frontend
cd /opt/my-frontend
```

4. Create a `docker-compose.yml` file for your frontend:
```yaml
version: '3.8'
services:
  frontend:
    image: nginx:alpine
    restart: unless-stopped
    # We do NOT expose ports directly to the host.
    # Nginx Proxy Manager will route traffic to this container via the internal network.
    volumes:
      - ./html:/usr/share/nginx/html
    networks:
      - web_network

networks:
  web_network:
    external: true
```

5. Start your frontend:
```bash
docker compose up -d
```

## 7. Configure Nginx Proxy Manager (Reverse Proxy)

Finally, link your domain to your Docker container.

1. Open the Nginx Proxy Manager admin UI (`http://<your-server-ip>:81`).
2. Go to **Hosts** -> **Proxy Hosts**.
3. Click **Add Proxy Host**.
4. In the **Details** tab:
   - **Domain Names:** Enter your FQDN (e.g., `app.example.com`).
   - **Scheme:** `http`
   - **Forward Hostname / IP:** `frontend` (This is the service name defined in your app's `docker-compose.yml`).
   - **Forward Port:** `80` (The internal port your frontend container listens on).
   - Enable **Cache Assets**, **Block Common Exploits**, and **Websockets Support** if needed.
5. In the **SSL** tab: *(Learn more about [SSL Certificates & Let's Encrypt](./ssl-certificates.md))*
   - Select **Request a new SSL Certificate**.
   - Enable **Force SSL**, **HTTP/2 Support**, and **HSTS Enabled**.
   - Enter your email address and agree to the Let's Encrypt Terms of Service.
6. Click **Save**.

Nginx Proxy Manager will now automatically fetch an SSL certificate from Let's Encrypt and route all traffic securely from `https://app.example.com` to your frontend Docker container.
