param environmentName string = 'prod'
param location string = resourceGroup().location
param appName string = 'devops22-michael'
param costing string = 'bill-payer'

@secure()
param dbPassword string 
param dbAdmin string = 'michaeldevops'
param sqlDbName string = 'db-michael'
param sqlServerName string = 'sql-server-michael'

var appFullName = 'app-${appName}-${toLower(environmentName)}'
var planName = 'plan-devops22'

var skuName = 'F1'
var skuCapacity = 1
var appIds = ['Test','Prod','UAT']

resource appPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  location: location
  name: planName
  kind: 'app'
  properties: {
    elasticScaleEnabled: false
    reserved: false
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  tags: {
    costing: costing
  }
}

resource app 'Microsoft.Web/sites@2022-03-01' = [for id in appIds: {
  kind: 'api'
  dependsOn: [
    appInsightsModule
  ]
  location: location
  name: bool(id == 0) ? '${appFullName}' : '${appFullName}-${id}'
  properties: {
    enabled: true
    serverFarmId: appPlan.id
    reserved: false
    hostNamesDisabled: false
    httpsOnly: true
    siteConfig: {
      
      minTlsVersion: '1.2'
      http20Enabled: true
      ftpsState: 'Disabled'
      remoteDebuggingEnabled: false
      appSettings: [
        {
          name: 'EmailFrom'
          value: 'iac@nackademin.se'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsModule.outputs.instrumentationKey
        }
      ]
      connectionStrings: [
        {
          name: 'OrdersConnectionString'
          connectionString: 'Data Source=tcp:${sqlServerName}.database.windows.net,1433;Initial Catalog=${sqlDbName};User Id=${dbAdmin};Password=${dbPassword}'
          type: 'SQLAzure'
        }
      ]
    }
  }
  tags: {
    costing: costing
  }
}]

module appInsightsModule 'appinsights.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    environmentName: environmentName
    location: location
    appName: appName
    costing: costing
  }
}
