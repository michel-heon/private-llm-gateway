# RECIT-403 : Ajouter GitHub Actions workflow CI/CD

**Type** : Récit Utilisateur  
**ID** : RECIT-403  
**Épopée** : [EPOP-004](../Épopées/EPOP-004-infrastructure-as-code.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer  
**Je veux** un pipeline GitHub Actions pour déployer automatiquement  
**Afin de** avoir une CI/CD complète

---

## ✅ Critères d'Acceptation

- [ ] Workflow `.github/workflows/deploy-azure.yml`
- [ ] Trigger sur push main ou tag release
- [ ] Déploie Bicep templates avec Azure CLI
- [ ] Secrets stockés dans GitHub Secrets

---

## 📊 Informations

**Priorité** : Should Have  
**Effort** : 8 points  
**Sprint** : Sprint 3  
**Assigné** : Jordan

---

## 🔗 Dépendances

- ✅ [RECIT-401](RECIT-401-bicep-relay.md) : Template Bicep Relay (requis)
- ✅ [RECIT-402](RECIT-402-bicep-proxy.md) : Template Bicep Proxy (requis)
- 🔐 Azure Service Principal avec droits Contributor
- 🐙 GitHub repository avec Actions enabled

---

## 📝 GitHub Actions Workflow

### .github/workflows/deploy-azure.yml

```yaml
name: Deploy to Azure

on:
  push:
    branches:
      - main
    tags:
      - 'v*'
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'dev'
        type: choice
        options:
          - dev
          - staging
          - prod

env:
  AZURE_RESOURCE_GROUP: rg-llm-gateway-${{ github.event.inputs.environment || 'dev' }}
  AZURE_LOCATION: canadacentral

jobs:
  validate:
    name: Validate Bicep Templates
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Validate Relay template
        run: |
          az deployment group validate \
            --resource-group ${{ env.AZURE_RESOURCE_GROUP }} \
            --template-file infra/bicep/relay.bicep \
            --parameters infra/bicep/relay.parameters.json
      
      - name: Validate Proxy template
        run: |
          az deployment group validate \
            --resource-group ${{ env.AZURE_RESOURCE_GROUP }} \
            --template-file infra/bicep/proxy.bicep \
            --parameters infra/bicep/proxy.parameters.json

  deploy:
    name: Deploy Infrastructure
    needs: validate
    runs-on: ubuntu-latest
    environment:
      name: ${{ github.event.inputs.environment || 'dev' }}
      url: ${{ steps.deploy-proxy.outputs.appServiceUrl }}
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Create Resource Group
        run: |
          az group create \
            --name ${{ env.AZURE_RESOURCE_GROUP }} \
            --location ${{ env.AZURE_LOCATION }}
      
      - name: Deploy Azure Relay
        id: deploy-relay
        run: |
          az deployment group create \
            --resource-group ${{ env.AZURE_RESOURCE_GROUP }} \
            --template-file infra/bicep/relay.bicep \
            --parameters infra/bicep/relay.parameters.json \
            --name relay-$(date +%Y%m%d-%H%M%S)
      
      - name: Deploy HTTPS Proxy
        id: deploy-proxy
        run: |
          OUTPUT=$(az deployment group create \
            --resource-group ${{ env.AZURE_RESOURCE_GROUP }} \
            --template-file infra/bicep/proxy.bicep \
            --parameters infra/bicep/proxy.parameters.json \
            --name proxy-$(date +%Y%m%d-%H%M%S) \
            --query 'properties.outputs.appServiceUrl.value' \
            --output tsv)
          
          echo "appServiceUrl=$OUTPUT" >> $GITHUB_OUTPUT
      
      - name: Deploy success
        run: |
          echo "✅ Déploiement réussi"
          echo "🌐 URL: ${{ steps.deploy-proxy.outputs.appServiceUrl }}"

  test:
    name: Test Deployment
    needs: deploy
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Health Check
        run: |
          ./scripts/endpoint-check-public.sh \
            --url "${{ needs.deploy.outputs.appServiceUrl }}/health"
```

---

## 🔐 GitHub Secrets

### Configuration Requise

```bash
# Créer Service Principal Azure
az ad sp create-for-rbac \
  --name "sp-llm-gateway-github" \
  --role contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/rg-llm-gateway \
  --sdk-auth

# Output JSON à stocker dans AZURE_CREDENTIALS
```

### Secrets GitHub

| Secret Name | Description | Exemple |
|-------------|-------------|---------|
| `AZURE_CREDENTIALS` | Service Principal JSON | `{"clientId":"...","clientSecret":"..."}` |
| `AZURE_SUBSCRIPTION_ID` | Subscription ID | `12345678-1234-1234-1234-123456789abc` |

---

## 🧪 Tests

### Tests Workflow

- [ ] Trigger sur push main fonctionne
- [ ] Trigger manuel (workflow_dispatch) fonctionne
- [ ] Validation Bicep réussit
- [ ] Déploiement Relay réussit
- [ ] Déploiement Proxy réussit
- [ ] Health check post-déploiement passe
- [ ] Erreurs bien remontées

### Tests d'Intégration

- [ ] Déploiement dev successful
- [ ] Déploiement prod successful (tag)
- [ ] Rollback possible si erreur

---

## 📋 Checklist Implémentation

- [ ] Créer Service Principal Azure
- [ ] Ajouter secrets dans GitHub
- [ ] Créer `.github/workflows/deploy-azure.yml`
- [ ] Tester validation Bicep
- [ ] Tester déploiement dev (manual trigger)
- [ ] Tester déploiement sur push main
- [ ] Documenter process dans README
- [ ] Ajouter badges status dans README

---

## 💡 Améliorations Futures

- [ ] Environnement de staging automatique
- [ ] Tests d'intégration automatiques post-deploy
- [ ] Rollback automatique si health check fail
- [ ] Notifications Slack/Teams
- [ ] Cost estimation avant deploy

---

_Dernière mise à jour : 2026-06-05_
