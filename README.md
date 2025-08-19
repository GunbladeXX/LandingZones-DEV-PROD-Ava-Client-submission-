# AVA Landing Zone (Hub & Spoke)

This repository contains an Azure Landing Zone deployment using **Bicep** and **GitHub Actions**, based on a phased architecture (Hub + Spoke model).  
It is designed for submission to an employer and demonstrates both **infrastructure-as-code** and **CI/CD operational deployment**.

---

## 🧱 Architecture Overview

The landing zone is divided into two areas:

| Area | Description |
|------|-------------|
| **Platform (Hub)** | Centralized network / shared services (Hub VNet, Firewall, Bastion, Private DNS, etc.) |
| **Application (Spoke)** | Workload subscription (App Gateway, VM Scale Sets, Key Vault, Log Analytics, etc.) |

All components follow a **phased deployment approach** using modular Bicep files (Phase 1 → Phase 7).

Deployments are performed via a **GitHub Actions pipeline** that targets two environments:  
**`dev`** and **`prod`** (including `what-if` and approval for production deployments).

---

## 📛 Naming Convention

All resources follow the naming pattern:

**`AVA` + `<ResourceTypeAbbreviation>` + `<Index>`**

| Resource Type | Example Name |
|---------------|-------------------|
| Subscription | AvaSub1 |
| Hub VNet | AvaVnetHub1 |
| Spoke VNet | AvaVnetSpoke1 |
| Key Vault | AvaKv1 |
| Storage Account | AvaStrg1 |
| Log Analytics | AvaLog1 |
| Firewall | AvaFw1 |
| Scale Set | AvaVmssFront1 / AvaVmssBack1 |
| Application Gateway | AvaAgw1 |

---

## 🚀 Deployment Flow (GitHub Actions)

1. Configure GitHub **environments**:  
   - `dev`  
   - `prod` (with manual approval)
2. Add Service Principal credentials to repository **secrets** (`AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `AZURE_CLIENT_SECRET`).
3. Commit/push to `main`.
4. GitHub Actions will:
   - Run `az deployment what-if` for **dev**
   - Deploy the phase modules to **dev**
5. Promotion to **prod** is performed after approval via GitHub.
6. The same pipeline runs `what-if` / deploy against `prod`.

---

## ✅ Phase 1 – Hub Network (AvaVnetHub1)

**Purpose:**  
Create the Hub Virtual Network foundation in the region `westeurope`.

**Resources deployed in Phase 1:**

| Resource | Name | Notes |
|---------|----------------|------------------------------|
| Virtual Network | AvaVnetHub1 | Primary Hub VNet |
| Subnet | AzureFirewallSubnet | Required for Firewall (Phase 2) |
| Subnet | AzureBastionSubnet | Required for Bastion (Phase 2) |
| Subnet | GatewaySubnet | Placeholder for VPN/ER Gateway |

> 🔔 **Firewall, Bastion and VPN/ExpressRoute gateways are *not* deployed in Phase 1.**  
> Those will be deployed in **Phase 2** using separate Bicep modules.

**Outputs:**  
- Hub VNet resource ID  
- Subnet IDs (used as inputs for subsequent phases)

---

### 📂 Folder / File Structure (Phase 1)

