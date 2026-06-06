# Understanding Firewalls and Ports

When you run a server, it's connected to the vast internet. To keep it secure, we use firewalls and ports.

## What is a Port?
Think of your server as a large office building and its IP address as the building's street address. **Ports** are like the individual doors or room numbers in that building. Different services use different ports:
- **Port 80:** The standard door for unencrypted web traffic (HTTP).
- **Port 443:** The secure door for encrypted web traffic (HTTPS).
- **Port 22:** The employee entrance for server administrators (SSH).

## What is a Firewall?
A **Firewall** is the security guard at the front desk of your office building. It decides which doors (ports) are allowed to be opened from the outside and who is allowed to enter.

## Concept Visualization

```mermaid
flowchart LR
    subgraph The Internet
        Hacker[Malicious Traffic]
        WebUser[Legitimate Web User]
        Admin[Server Administrator]
    end

    subgraph Your Server
        FW{Firewall\nSecurity Guard}
        
        P80[Port 80/443\nWeb Server]
        P22[Port 22\nSSH / Admin]
        P3306[Port 3306\nDatabase]
    end

    WebUser -->|Allowed| FW
    Admin -->|Allowed| FW
    Hacker -.->|Blocked| FW

    FW -->|Web Traffic| P80
    FW -->|Admin Access| P22
    
    style Hacker fill:#ffcccc,stroke:#ff0000
    style P3306 fill:#e6e6e6,stroke:#666,stroke-dasharray: 5 5
```

In the diagram above, the firewall blocks malicious traffic but allows web users to access the web server ports (80/443) and administrators to access the SSH port (22). The database port (3306) is hidden behind the firewall and not accessible from the outside internet.
