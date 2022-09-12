param location string = resourceGroup().location
param costing string = 'bill-payer'

@secure()
param dbPassword string
param dbAdmin string = 'michaeldevops'
param sqlDbName string = 'db-michael-prod'
param sqlServerName string = 'sql-server-michael'

resource sqlServer 'Microsoft.Sql/servers@2021-08-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: dbAdmin
    administratorLoginPassword: dbPassword
  }
  tags: {
    costing: costing
  }

  resource fwRuleAzureComs 'firewallRules@2022-02-01-preview' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  }

  resource fwRuleHome 'firewallRules@2022-02-01-preview' = {
    name: 'homeIp'
    properties: {
      startIpAddress: '85.229.132.213'
      endIpAddress: '85.229.132.213'
    }
  }

  resource db 'databases@2021-08-01-preview' = {
    name: sqlDbName
    location: location
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    tags: {
      costing: costing
    }
  }
}
