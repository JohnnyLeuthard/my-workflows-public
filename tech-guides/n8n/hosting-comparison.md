# n8n Hosting Comparison

## Purpose

Compare the main hosting options for running n8n. Each option includes price range, difficulty, setup time, and key notes.

---

## Overview Graph

```
                         +----------------------+
                         |   Self Hosted PC     |
                         +----------+-----------+
                                    |
               +--------------------+--------------------+
               |                                         |
     +---------+-----------+                 +-----------+---------+
     | PC Without Docker   |                 | PC With Docker      |
     +----------------------+                 +---------------------+
                                    |
                                    |
                         +----------+-----------+
                         |     Cloud Hosting    |
                         +----------+-----------+
                                    |
         +--------------+-----------+-----------+---------------+
         |              |                       |               |
 +-------+-----+  +------+-----+        +-------+------+  +-----+-------+
 | GCP Free   |  | GCP Paid  |        | Third-Party |  | n8n Cloud   |
 | Tier VM    |  | Tier VM   |        | Hosting     |  | (Hosted)    |
 +-------------+  +-----------+        +-------------+  +-------------+
```

---

## Self Hosted on a Personal Computer

### Without Docker
- **Price:** Free  
- **Difficulty:** Medium  
- **Setup Time:** 20 to 40 minutes  
- **Notes:**  
  - Installs directly on your OS  
  - Manual updates  
  - Good for casual testing  
  - Not ideal for long-term uptime  

### With Docker Desktop
- **Price:** Free  
- **Difficulty:** Low  
- **Setup Time:** 10 to 20 minutes  
- **Notes:**  
  - Cleaner environment  
  - Easier upgrades  
  - Easy to relocate or backup containers  
  - Requires Docker Desktop running  

---

## GCP Free Tier VM (e2‑micro)
- **Price:** Free  
- **Difficulty:** Medium  
- **Setup Time:** 30 to 60 minutes  
- **Notes:**  
  - Good uptime  
  - Very limited RAM and CPU  
  - Needs DNS and firewall setup  
  - Solid for small or medium workflows  
  - Full control over system  

---

## GCP Non‑Free Tier VM
- **Price:** 10 to 50 dollars per month  
- **Difficulty:** Medium  
- **Setup Time:** 30 to 60 minutes  
- **Notes:**  
  - Better performance and fewer limits  
  - Can scale with larger machine types  
  - Strong security controls  
  - Good for production workloads  

---

## Third‑Party Hosting (General VPS Providers)
Examples: DigitalOcean, Hetzner, Vultr, Linode  
- **Price:** 5 to 20 dollars per month  
- **Difficulty:** Low to Medium  
- **Setup Time:** 10 to 30 minutes  
- **Notes:**  
  - Simple deployments  
  - Usually cheaper than GCP  
  - Less granular security  
  - Good performance per dollar  

---

## n8n Cloud (Official Hosted n8n)
- **Price:** 20 to 100 dollars per month  
- **Difficulty:** Very Low  
- **Setup Time:** 5 minutes  
- **Notes:**  
  - Zero server work  
  - Managed updates and scaling  
  - Best reliability  
  - No OS or networking tasks  
  - Higher cost than self hosting  
  - Great for users who want to avoid DevOps work  

---

## Summary Table

| Hosting Option | Price | Difficulty | Setup Time | Best For |
|----------------|--------|------------|------------|----------|
| PC Without Docker | Free | Medium | 20–40 min | Basic learning |
| PC With Docker | Free | Low | 10–20 min | Clean local testing |
| GCP Free Tier | Free | Medium | 30–60 min | Cloud testing, small workflows |
| GCP Non‑Free | 10–50 | Medium | 30–60 min | Production workloads |
| Third‑Party VPS | 5–20 | Low | 10–30 min | Cheap stable hosting |
| n8n Cloud | 20–100 | Very Low | 5 min | Anyone wanting zero maintenance |
