# LandingZones-DEV-PROD-Ava-Client-submission-
Landing zones DEV/PROD for the skill test review
_________________________________________________
Initial Structure (Overview & Phase 1)

🔹Project Purpose
Short description of the landing zone architecture and what this repository delivers.

🔹Architecture Overview
Brief explanation of the hub & spoke setup (AVA naming convention, phased Bicep modules, GitHub Actions pipeline, environments dev and prod, region westeurope).

🔹Naming Convention
Description and a small table showing AVA + resource abbreviation + index (AvaVnetHub1, AvaVnetSpoke1, AvaAgw1, etc.).

🔹Deployment Flow

Clone repo

Configure GitHub environments (dev, prod)

Add Service Principal secrets to GitHub repository secrets

Trigger workflow → what-if on dev → deploy

Approved promotion to prod

🔹Phase 1 Description

Deploy Hub Virtual Network (AvaVnetHub1) in westeurope

Create subnets

FirewallSubnet

AzureBastionSubnet

(placeholder) GatewaySubnet

(Firewall resource itself will be deployed in Phase 2, this phase is only the network foundation)

Outputs: VNet resource ID + subnet IDs → consumed by future phases
