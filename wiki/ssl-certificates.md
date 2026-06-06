# SSL Certificates and Let's Encrypt

## What is SSL/TLS?
**SSL (Secure Sockets Layer)** and its modern successor **TLS (Transport Layer Security)** are cryptographic protocols designed to provide communications security over a computer network. 

When a website uses SSL, the URL starts with **HTTPS** (Hypertext Transfer Protocol Secure) instead of HTTP, and a padlock icon appears in the browser. This means the data passed between your browser and the web server is encrypted, protecting sensitive information like passwords and credit card numbers from eavesdroppers.

## What is Let's Encrypt?
**Let's Encrypt** is a free, automated, and open certificate authority (CA). It provides free SSL/TLS certificates to enable encrypted HTTPS on web servers. Nginx Proxy Manager integrates directly with Let's Encrypt to automatically fetch and renew these certificates.

## Concept Visualization

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant Server as Web Server (NPM)
    participant LE as Let's Encrypt Authority

    Note over User,Server: Insecure HTTP Connection (Plain Text)
    User->>Server: HTTP Request to http://example.com
    
    Note over Server,LE: Server requests a secure certificate
    Server->>LE: Request Certificate for example.com
    LE-->>Server: Issues Certificate & Keys
    
    Note over User,Server: Server redirects user to secure port
    Server-->>User: 301 Redirect to https://example.com
    
    Note over User,Server: Secure HTTPS Connection (Encrypted Tunnel)
    User->>Server: HTTPS Request to https://example.com
    Server-->>User: Encrypted Website Data
```

By using HTTPS, even if someone intercepts the traffic between the user and the server, they will only see unreadable, encrypted gibberish.
