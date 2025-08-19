// bicep/phase2-sharedServices/main.bicep
// Phase 2 – Shared Services (Hub Subscription)

@description('Location for shared services')
param location string = 'westeurope'

@description('Hub Virtual Network Id (output of phase 1)')
param hubVnetId string

@description('Name of the DDoS Protection Plan')
param ddosPlanName string = 'AvaDdos1'

@description('Name of the Azure Firewall')
param firewallName string = 'AvaFw1'

@description('Name of the Bastion Host')
param bastionName string = 'AvaBastion1'

//-----------------------------------------------------------
// DDoS Protection Plan
resource ddosPlan 'Microsoft.Network/ddosProtectionPlans@2023-09-01' = {
  name: ddosPlanName
  location: location
  sku: {
    name: 'Standard'
  }
}

//-----------------------------------------------------------
// Network Watcher (automatically enabled for region)
// Azure enables Network Watcher automatically, so we simply reference it:

resource networkWatcher 'Microsoft.Network/networkWatchers@2023-09-01' existing = {
  name: 'NetworkWatcher_westeurope'
}

//-----------------------------------------------------------
// Azure Firewall (classic mode)
// Firewall must be deployed in AzureFirewallSubnet which was created in Phase 1.

resource firewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: firewallName
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    virtualHub: null
    ipConfigurations: []
  }
}

//-----------------------------------------------------------
// Azure Bastion Host
// Bastion must be deployed in AzureBastionSubnet created in Phase 1.

resource bastion 'Microsoft.Network/bastionHosts@2023-09-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bastionIpConfig'
        properties: {
          subnet: {
            id: '${hubVnetId}/subnets/AzureBastionSubnet'
          }
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', '${bastionName}-pip')
          }
        }
      }
    ]
  }
}

// Public IP for Bastion
resource bastionPip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${bastionName}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

//-----------------------------------------------------------
// Private DNS zones (no record sets yet, created as placeholders)

resource dnsFirewall 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurefirewall.net'
  location: 'global'
}

resource dnsKeyvault 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'
}

output ddosPlanId string = ddosPlan.id
output firewallId string = firewall.id
output bastionId string = bastion.id
