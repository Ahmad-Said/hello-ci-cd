# What is a VPS or Dedicated Server?

When deploying a web application, you need a computer that is always on and connected to the internet. 

## VPS (Virtual Private Server)
A VPS is a virtual machine sold as a service by an Internet hosting service. It runs its own copy of an operating system, and you have superuser-level access to that operating system instance. It shares physical hardware with other VPS instances but acts as a dedicated server.

## Dedicated Server
A dedicated server is a single physical computer in a network reserved for serving the needs of the network. You do not share the physical resources (CPU, RAM, storage) with any other users.

## Concept Visualization

```mermaid
flowchart TD
    subgraph The Internet
    User1((User))
    User2((User))
    end

    subgraph Hosting Provider
        subgraph Physical Server
            Hypervisor(Hypervisor)
            VPS1[Your VPS\nDedicated Resources]
            VPS2[Other VPS]
            VPS3[Other VPS]
            
            Hypervisor --> VPS1
            Hypervisor --> VPS2
            Hypervisor --> VPS3
        end
    end

    User1 -->|Access Website| VPS1
    User2 -->|Access Website| VPS1
```

In simpler terms, think of a Dedicated Server as owning a whole house, while a VPS is like renting a private apartment within a larger building. You have your own space and locks, but you share the underlying building infrastructure.
