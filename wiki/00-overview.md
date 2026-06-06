# Web Server Deployment Guide

This guide explains how to deploy a web application starting from a fresh Virtual Private Server (VPS) or a dedicated server with a public IP. We will use Docker and Nginx Proxy Manager (NPM) to expose services securely.

## Global Architecture

The diagram below shows the full picture of what you are building. Every section in this guide maps to one of these layers.

```mermaid
graph TB
    User(("👤 User\nBrowser"))
    DNS["🌐 DNS Registrar\nA Record: app.example.com → VPS IP"]

    subgraph VPS["🖥️ VPS / Dedicated Server  (Public IP)"]
        FW["🔒 Firewall\nports 80 · 443 · 22"]

        subgraph Docker["🐳 Docker Environment"]
            subgraph WebNet["web_network  (internal bridge)"]
                NPM["Nginx Proxy Manager\n:80  :443  :81 (admin)"]
                FE["Frontend Container\nnginx:alpine"]
                BE["Backend Container\n(optional)"]
            end
            LE["Let's Encrypt\nSSL certificates"]
        end
    end

    User -->|"https://app.example.com"| DNS
    DNS -->|"resolves to Public IP"| FW
    FW -->|"80 / 443"| NPM
    NPM <-->|"ACME challenge"| LE
    NPM -->|"reverse proxy\n(internal)"| FE
    NPM -.->|"reverse proxy\n(optional)"| BE
```

## Deployment Steps Overview

```mermaid
flowchart LR
    A([Start]) --> B[1. Prerequisites]
    B --> C[2. Server Preparation\n& Firewall]
    C --> D[3. DNS Configuration]
    D --> E[4. Install Docker]
    E --> F[5. Deploy NPM]
    F --> G[6. Deploy Your App]
    G --> H[7. Configure\nReverse Proxy]
    H --> I([Live 🎉])

    style A fill:#4CAF50,color:#fff
    style I fill:#4CAF50,color:#fff
    style F fill:#2196F3,color:#fff
    style H fill:#2196F3,color:#fff
```

## Deployment Checklist

```mermaid
graph TD
    C1["☐ VPS provisioned with public IP"]
    C2["☐ Firewall: ports 80, 443, 22 open"]
    C3["☐ DNS A record pointing to VPS IP"]
    C4["☐ Docker & Docker Compose installed"]
    C5["☐ web_network created"]
    C6["☐ Nginx Proxy Manager running on :81"]
    C7["☐ App container on web_network (no host ports)"]
    C8["☐ Proxy Host configured in NPM"]
    C9["☐ SSL certificate issued by Let's Encrypt"]
    C10(["✅ Site live on HTTPS"])

    C1 --> C2 --> C3 --> C4 --> C5 --> C6 --> C7 --> C8 --> C9 --> C10

    style C10 fill:#4CAF50,color:#fff
```
