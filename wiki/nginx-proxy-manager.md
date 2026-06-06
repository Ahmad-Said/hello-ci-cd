# Nginx Proxy Manager & Reverse Proxies

## What is a Reverse Proxy?
A **Reverse Proxy** is a server that sits in front of web servers and forwards client (e.g., web browser) requests to those web servers.

Imagine a large restaurant. When you arrive, you don't go straight to the kitchen to talk to a chef. You talk to the **Maître D'** (the reverse proxy). The Maître D' takes your order, decides which chef is best suited to cook it, takes the food from the chef, and hands it back to you. The kitchen is hidden from the customer.

## What is Nginx Proxy Manager (NPM)?
Nginx Proxy Manager is a user-friendly web interface that configures an Nginx reverse proxy under the hood. It makes it incredibly easy to:
- Route `api.example.com` to one Docker container and `app.example.com` to another.
- Easily acquire and manage Free SSL Certificates from Let's Encrypt.
- Manage access and security.

## Concept Visualization

```mermaid
flowchart TD
    User1([User requesting \n app.example.com])
    User2([User requesting \n api.example.com])
    
    subgraph Your Server
        NPM{Nginx Proxy Manager\nReverse Proxy}
        
        subgraph Docker Network
            Frontend[Frontend Container\nPort 3000]
            Backend[Backend API Container\nPort 8080]
            Database[(Database Container\nPort 5432)]
        end
        
        NPM -- routes app.* to --> Frontend
        NPM -- routes api.* to --> Backend
        Backend --> Database
    end

    User1 -->|HTTPS Port 443| NPM
    User2 -->|HTTPS Port 443| NPM
```

The reverse proxy handles all incoming traffic on the standard HTTP/HTTPS ports (80/443) and intelligently routes it to the correct internal container on the internal Docker network. The internal containers don't need their ports exposed to the public internet.
