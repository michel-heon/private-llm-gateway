# RECIT-401 : Créer template Bicep pour Azure Relay

**Type** : Récit Utilisateur  
**ID** : RECIT-401  
**Épopée** : [EPOP-004](../Épopées/EPOP-004-infrastructure-as-code.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer  
**Je veux** un template Bicep pour provisionner Relay namespace + Hybrid Connection  
**Afin de** automatiser le déploiement Azure

---

## ✅ Critères d'Acceptation

- [ ] Fichier `infra/bicep/relay.bicep`
- [ ] Paramètres : location, sku, connection name
- [ ] Output : connection string (secured)
- [ ] Tests de déploiement sur subscription test

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 3  
**Assigné** : Jordan

---

## 🔗 Dépendances

- ☁️ Azure Subscription avec droits Contributor
- 🔧 Azure CLI ou Bicep CLI installé
- 📄 Décision ADR : Bicep vs Terraform (à créer si nécessaire)

---

## 📝 Template Bicep

### relay.bicep

```bicep
@description('Location for all resources')
param location string = resourceGroup().location

@description('Environment name (dev, staging, prod)')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

@description('Relay namespace SKU')
@allowed(['Standard'])
param sku string = 'Standard'

@description('Hybrid Connection name')
param hybridConnectionName string = 'llm-gateway-hc'

var relayNamespaceName = 'relay-llm-gateway-${environment}'

// Azure Relay Namespace
resource relayNamespace 'Microsoft.Relay/namespaces@2021-11-01' = {
  name: relayNamespaceName
  location: location
  sku: {
    name: sku
    tier: sku
  }
  properties: {}
  
  tags: {
    Environment: environment
    Project: 'private-llm-gateway'
  }
}

// Hybrid Connection
resource hybridConnection 'Microsoft.Relay/namespaces/hybridConnections@2021-11-01' = {
  parent: relayNamespace
  name: hybridConnectionName
  properties: {
    requiresClientAuthorization: true
  }
}

// Authorization Rule (Send + Listen)
resource authRule 'Microsoft.Relay/namespaces/authorizationRules@2021-11-01' = {
  parent: relayNamespace
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Send'
      'Listen'
      'Manage'
    ]
  }
}

// Outputs (connection string sécurisé)
output relayNamespaceName string = relayNamespace.name
output hybridConnectionName string = hybridConnection.name

@description('Connection string - MUST be stored in Key Vault')
output connectionString string = listKeys(authRule.id, authRule.apiVersion).primaryConnectionString
```

### relay.parameters.json

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": {
      "value": "canadacentral"
    },
    "environment": {
      "value": "dev"
    },
    "sku": {
      "value": "Standard"
    },
    "hybridConnectionName": {
      "value": "llm-gateway-hc"
    }
  }
}
```

---

## 🚀 Déploiement

### Via Azure CLI

```bash
# Créer resource group
az group create \
  --name rg-llm-gateway-dev \
  --location canadacentral

# Déployer template
az deployment group create \
  --resource-group rg-llm-gateway-dev \
  --template-file infra/bicep/relay.bicep \
  --parameters infra/bicep/relay.parameters.json

# Récupérer connection string (puis stocker dans Key Vault)
CONNECTION_STRING=$(az deployment group show \
  --resource-group rg-llm-gateway-dev \
  --name relay \
  --query properties.outputs.connectionString.value \
  --output tsv)
```

---

## 🧪 Tests

### Tests de Déploiement

- [ ] Déploiement réussit sur subscription test
- [ ] Relay namespace créé avec bon SKU
- [ ] Hybrid Connection créée
- [ ] Authorization rule fonctionnelle
- [ ] Connection string valide
- [ ] Tags appliqués correctement

### Tests d'Intégration

- [ ] Agent relay se connecte avec connection string
- [ ] Latency acceptable (<100ms)
- [ ] Coût conforme au budget (<10$/mois)

---

## 📋 Checklist Implémentation

- [ ] Créer répertoire `infra/bicep/`
- [ ] Créer `relay.bicep`
- [ ] Créer `relay.parameters.json` (dev)
- [ ] Créer `relay.parameters.prod.json` (prod)
- [ ] Tester déploiement local (what-if)
- [ ] Déployer sur subscription test
- [ ] Valider connexion agent
- [ ] Documenter commandes déploiement
- [ ] Intégrer avec [RECIT-301](RECIT-301-azure-key-vault.md) (Key Vault)
- [ ] Créer README dans `infra/`

---

## 💡 Améliorations Futures

- [ ] Intégrer Key Vault dans même template
- [ ] Managed Identity pour agent
- [ ] Diagnostic logs vers Log Analytics
- [ ] Alerts (connexions échouées, latence)

---

_Dernière mise à jour : 2026-06-05_
