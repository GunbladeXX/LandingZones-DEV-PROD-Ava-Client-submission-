// bicep/phase3-policy/main.bicep
// Phase 3 – Policy Assignment (Hub + Spoke)

@description('Subscription ID of the Hub subscription')
param hubSubscriptionId string

@description('Subscription ID of the Spoke subscription')
param spokeSubscriptionId string

// Built-in policy definition: “Deny public IP address”  
var policyDefinitionId = '/providers/Microsoft.Authorization/policyDefinitions/40cd1c0c-ede9-4a2b-9838-169df4c25346'

//-----------------------------------------------------------
// Policy Assignment (Hub Subscription Scope)
resource policyAssignmentHub 'Microsoft.Authorization/policyAssignments@2022-10-01' = {
  name: 'AvaDenyPublicIP'
  scope: subscriptionResourceId(hubSubscriptionId)
  properties: {
    displayName: 'Deny Public IP (Hub)'
    policyDefinitionId: policyDefinitionId
    enforcementMode: 'Default'
  }
}

//-----------------------------------------------------------
// Policy Assignment (Spoke Subscription Scope)
resource policyAssignmentSpoke 'Microsoft.Authorization/policyAssignments@2022-10-01' = {
  name: 'AvaDenyPublicIP'
  scope: subscriptionResourceId(spokeSubscriptionId)
  properties: {
    displayName: 'Deny Public IP (Spoke)'
    policyDefinitionId: policyDefinitionId
    enforcementMode: 'Default'
  }
}
