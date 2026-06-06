# How DNS Works

**DNS (Domain Name System)** is the phonebook of the internet. 

Humans access information online through domain names, like `example.com`. Web browsers interact through Internet Protocol (IP) addresses (like `192.168.1.1`). DNS translates domain names to IP addresses so browsers can load internet resources.

## Common DNS Records

- **A Record:** Points a domain (e.g., `example.com`) to an IPv4 address.
- **CNAME Record:** Points a domain to another domain name (like an alias).
- **Wildcard Record (`*`):** A record that will match requests for non-existent subdomains. For example, `*.example.com` would route `app.example.com` and `blog.example.com` to the same place.

## Concept Visualization

```mermaid
sequenceDiagram
    actor User as Web Browser
    participant Resolver as DNS Resolver (ISP)
    participant Auth as Authoritative DNS (Registrar)
    participant Server as Your Web Server (IP: 203.0.113.5)

    User->>Resolver: 1. I want to visit example.com
    Resolver->>Auth: 2. Where is example.com?
    Auth-->>Resolver: 3. It's at IP 203.0.113.5 (A Record)
    Resolver-->>User: 4. Go to 203.0.113.5
    User->>Server: 5. Sends HTTP request to 203.0.113.5
    Server-->>User: 6. Returns Website Data
```

When you configure your DNS to point to your VPS, you are setting up the "Authoritative DNS" to tell the world which IP address belongs to your domain name.
