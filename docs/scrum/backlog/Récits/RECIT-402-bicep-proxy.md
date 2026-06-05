# RECIT-402 : Créer template Bicep pour HTTPS proxy

**Type** : Récit Utilisateur  
**ID** : RECIT-402  
**Épopée** : [EPOP-004](../Épopées/EPOP-004-infrastructure-as-code.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer  
**Je veux** un template Bicep pour App Service ou Container App proxy  
**Afin de** déployer le point d'entrée HTTPS public

---

## ✅ Critères d'Acceptation

- [ ] Fichier `infra/bicep/proxy.bicep`
- [ ] Support App Service ou Container Apps (paramétrable)
- [ ] Managed Identity configurée
- [ ] Custom domain + SSL certificate

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 13 points  
**Sprint** : Sprint 3  
**Assigné** : Jordan

---

## 🔗 Dépendances

- ✅ [RECIT-401](RECIT-401-bicep-relay.md) : Relay namespace (requis pour connection string)
- 📄 Décision : App Service vs Container Apps
- 📄 Custom domain enregistré (ex: llm.example.com)

---

## 📝 Template Bicep

### Option A : Azure App Service

```bicep
@description('Location for all resources')
param location string = resourceGroup().location

@description('Environment name')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

@description('App Service Plan SKU')
@allowed(['B1', 'S1', 'P1v2'])
param sku string = 'B1'

@description('Custom domain name (optional)')
param customDomain string = ''

@description('Azure Relay connection string')
@secure()
param relayConnectionString string

var appServicePlanName = 'asp-llm-gateway-${environment}'
var appServiceName = 'app-llm-gateway-${environment}'

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
  }
  properties: {
    reserved: true  // Linux
  }
  
  tags: {
    Environment: environment
    Project: 'private-llm-gateway'
  }
}

// App Service
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.11'
      alwaysOn: true
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'AZURE_RELAY_CONNECTION_STRING'
          value: '@Microsoft.KeyVault(SecretUri=https://kv-llm-gateway.vault.azure.net/secrets/AzureRelayConnectionString)'
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
      ]
    }
  }
  
  tags: {
    Environment: environment
    Project: 'private-llm-gateway'
  }
}

// Custom Domain (if provided)
resource customDomainBinding 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = if (!empty(customDomain)) {
  parent: appService
  name: customDomain
  properties: {
    sslState: 'SniEnabled'
    thumbprint: managedCertificate.properties.thumbprint
  }
}

// Managed Certificate (if custom domain)
resource managedCertificate 'Microsoft.Web/certificates@2022-09-01' = if (!empty(customDomain)) {
  name: '${customDomain}-cert'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    canonicalName: customDomain
  }
}

// Outputs
output appServiceName string = appService.name
output appServiceUrl string = 'https://${appService.properties.defaultHostName}'
output customDomainUrl string = !empty(customDomain) ? 'https://${customDomain}' : ''
output managedIdentityPrincipalId string = appService.identity.principalId
```

### Option B : Azure Container Apps

```bicep
@description('Location for all resources')
param location string = resourceGroup().location

@description('Environment name')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

@description('Container image')
param containerImage string = 'ghcr.io/yourusername/llm-gateway-proxy:latest'

var containerAppEnvName = 'cae-llm-gateway-${environment}'
var containerAppName = 'ca-llm-gateway-${environment}'

// Container Apps Environment
resource containerAppEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: containerAppEnvName
  location: location
  properties: {
    zoneRedundant: false
  }
  
  tags: {
    Environment: environment
    Project: 'private-llm-gateway'
  }
}

// Container App
resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: containerAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      ingress: {
        external: true
        targetPort: 8080
        transport: 'http2'
        allowInsecure: false
      }
      secrets: [
        {
          name: 'relay-connection-string'
          keyVaultUrl: 'https://kv-llm-gateway.vault.azure.net/secrets/AzureRelayConnectionString'
          identity: 'system'
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'proxy'
          image: containerImage
          env: [
            {
              name: 'AZURE_RELAY_CONNECTION_STRING'
              secretRef: 'relay-connection-string'
            }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 3
      }
    }
  }
  
  tags: {
    Environment: environment
    Project: 'private-llm-gateway'
  }
}

// Outputs
output containerAppUrl string = 'https://${containerApp.properties.configuration.ingress.fqdn}'
output managedIdentityPrincipalId string = containerApp.identity.principalId
```

---

## 🚀 Déploiement

### App Service

```bash
az deployment group create \
  --resource-group rg-llm-gateway-dev \
  --template-file infra/bicep/proxy.bicep \
  --parameters \
    environment=dev \
    sku=B1 \
    customDomain=llm-dev.example.com \
    relayConnectionString="@Microsoft.KeyVault(...)"
```

### Container Apps

```bash
az deployment group create \
  --resource-group rg-llm-gateway-dev \
  --template-file infra/bicep/proxy-containerapp.bicep \
  --parameters \
    environment=dev \
    containerImage=ghcr.io/yourusername/llm-gateway-proxy:latest
```

---

## 🧪 Tests

### Tests de Déploiement

- [ ] App Service / Container App créé
- [ ] Managed Identity configurée
- [ ] HTTPS forcé (HTTP redirect)
- [ ] TLS 1.2 minimum
- [ ] Connection Relay fonctionnelle

### Tests Fonctionnels

- [ ] Endpoint https://app-llm-gateway.azurewebsites.net répond
- [ ] Custom domain (si configuré) résout
- [ ] SSL certificate valide
- [ ] Requête LLM transite correctement

---

## 📋 Checklist Implémentation

- [ ] Décider : App Service vs Container Apps
- [ ] Créer `proxy.bicep` (option choisie)
- [ ] Créer parameters.json
- [ ] Tester déploiement (what-if)
- [ ] Déployer sur subscription test
- [ ] Configurer custom domain (GoDaddy DNS)
- [ ] Valider certificat SSL
- [ ] Assigner RBAC Key Vault à Managed Identity
- [ ] Tester end-to-end
- [ ] Documenter dans README

---

_Dernière mise à jour : 2026-06-05_
