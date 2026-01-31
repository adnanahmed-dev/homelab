# 🏗️ DevOps HomeLab: Infrastructure-as-Code

## 🎯 Overview
This repository serves as the "Source of Truth" for my personal DevOps HomeLab. My goal is to shift from manual "Click-Ops" to a fully automated, self-healing infrastructure. This lab is a playground for practicing **Cloud-Native technologies, GitOps workflows, and Site Reliability Engineering (SRE)** principles.

### 🏠 The Hardware (The "Workhorse")
- **Host:** Dell Optiplex 7060
- **Specs:** Intel i7 (8th Gen) | 40GB DDR4 RAM | 256GB NVMe SSD
- **Storage:** No storage added yet.
- **Virtualization:** Proxmox VE 9

---

## 🛠️ The Tech Stack
| Layer | Tool | Purpose |
| :--- | :--- | :--- |
| **Virtualization** | [Proxmox](https://www.proxmox.com/) | Type-1 Hypervisor managing VMs and LXCs. |
| **IaC** | [Terraform](https://www.terraform.io/) | Provisioning Proxmox VMs and networking. |
| **Configuration** | [Ansible](https://www.ansible.com/) | OS Hardening, K3s installation, and UFW management. |
| **Orchestration** | [K3s](https://k3s.io/) | Lightweight Kubernetes for edge/home deployments. |
| **GitOps** | [ArgoCD](https://argoproj.github.io/cd/) | Declarative continuous delivery for Kubernetes. |
| **Observability** | [Prometheus](https://prometheus.io/) / [Grafana](https://grafana.com/) | Real-time monitoring and alerting. |
| **Connectivity** | [Tailscale](https://tailscale.com/) | Secure WireGuard-based Mesh VPN for remote management. |

---

## 📐 Architecture
The lab is structured into three distinct layers of automation:

1. **Infrastructure Layer (`/terraform`):** Defines the "virtual hardware." Clones Debian Cloud-Init templates to create K3s control planes and worker nodes.
2. **Configuration Layer (`/ansible`):** Standardizes the OS. Handles swap-off, security patching, and K3s cluster bootstrapping.
3. **Application Layer (`/kubernetes`):** Managed by ArgoCD. Deployments include SQL Server, N8N, and the Observability stack.

---

## 🚀 Getting Started (Disaster Recovery)

In the event of a total host failure, the lab can be restored using the following workflow:

### 1. Provision VMs
```bash
cd terraform/
terraform init
terraform apply -var-file="secret.tfvars"

```

### 2. Configure OS & Install K3s

```bash
cd ../ansible/
ansible-playbook -i inventory.ini playbooks/setup-k3s.yml

```

### 3. Bootstrap GitOps

```bash
kubectl apply -f kubernetes/bootstrap/argocd.yaml

```

---

## 📈 Roadmap & Learning Journey

* [x] Initial Proxmox setup and VM manual testing.
* [x] Automate VM provisioning with Terraform & Cloud-Init.
* [ ] Configure K3s cluster via Ansible.
* [ ] Implement GitOps with ArgoCD.
* [ ] Deploy Observability stack (Prometheus/Grafana).
* [ ] Instrument apps with OpenTelemetry.

---

## ✍️ Learning Logs

I document the challenges and "Aha!" moments of this journey on my blog and LinkedIn:

* **LinkedIn:** [Adnan Ahmed](https://www.linkedin.com/in/adnanahmed-dev/)
* **Blog:** coming soon

---

*“If you have to do it twice, automate it.”*
