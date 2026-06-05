# RECIT-301 : Intégrer Azure Key Vault pour secrets

**Type** : Récit Utilisateur  
**ID** : RECIT-301  
**Épopée** : [EPOP-003](../Épopées/EPOP-003-securite.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer  
**Je veux** stocker les secrets dans Azure Key Vault  
**Afin de** ne jamais commiter de credentials dans le code

---

## ✅ Critères d'Acceptation

- [ ] Provisionner Key Vault via script ou IaC
- [ ] Stocker `AZURE_RELAY_CONNECTION_STRING` dans Key Vault
- [ ] Agent relay récupère secrets via Managed Identity
- [ ] Documentation rotation des secrets

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 2  
**Assigné** : Jordan

---

## 🔗 Dépendances

- ☁️ Azure Subscription active
- 📄 [RECIT-401](RECIT-401-bicep-relay.md) : Bicep Relay (Key Vault peut être inclus)
- 📄 [docs/reference/security.md](../../../reference/security.md) : Baseline sécurité

---

## 📝 Spécifications Techniques

### 1. Provisionner Key Vault

**Option A : Azure CLI**
```bash
#!/usr/bin/env bash
# scripts/keyvault-provision.sh

az keyvault create \
  --name "kv-llm-gateway-prod" \
  --resource-group "rg-llm-gateway" \
  --location "canadacentral" \
  --enable-rbac-authorization true
```

**Option B : Bicep (recommandé)**
```bicep
resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv-llm-gateway-${environment}'
  location: location
  properties: {
    enableRbacAuthorization: true
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
}
```

### 2. Stocker Connection String

```bash
# Stocker secret
az keyvault secret set \
  --vault-name "kv-llm-gateway-prod" \
  --name "AzureRelayConnectionString" \
  --value "$AZURE_RELAY_CONNECTION_STRING"
```

### 3. Agent Relay avec Managed Identity

**relay_agent.py (modification)** :
```python
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

# Configuration
KEY_VAULT_NAME = os.getenv("AZURE_KEY_VAULT_NAME")
KEY_VAULT_URI = f"https://{KEY_VAULT_NAME}.vault.azure.net"

# Récupération secret via MI
credential = DefaultAzureCredential()
client = SecretClient(vault_url=KEY_VAULT_URI, credential=credential)
connection_string = client.get_secret("AzureRelayConnectionString").value
```

### 4. RBAC Assignments

```bash
# Assigner rôle Key Vault Secrets User à la Managed Identity
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee-object-id "<MI_OBJECT_ID>" \
  --scope "/subscriptions/<SUB_ID>/resourceGroups/rg-llm-gateway/providers/Microsoft.KeyVault/vaults/kv-llm-gateway-prod"
```

---

## 🧪 Tests

### Tests Fonctionnels

- [ ] Secret récupéré correctement via MI
- [ ] Agent démarre sans .env local
- [ ] Erreur claire si MI non configurée
- [ ] Logs ne contiennent pas le secret

### Tests de Sécurité

- [ ] Secret non loggé
- [ ] Secret non affiché dans exceptions
- [ ] RBAC minimal (principe du moindre privilège)

---

## 📋 Checklist Implémentation

- [ ] Décider : CLI vs Bicep (recommandé Bicep)
- [ ] Créer Bicep template Key Vault
- [ ] Provisionner Key Vault (Sprint 2)
- [ ] Stocker connection string
- [ ] Installer SDK Azure Identity Python
- [ ] Modifier `relay_agent.py`
- [ ] Configurer Managed Identity
- [ ] Assigner RBAC rôles
- [ ] Tester récupération secret
- [ ] Documenter rotation secrets
- [ ] Mettre à jour documentation

---

## 📚 Documentation Rotation Secrets

### Procédure (à documenter)

1. Créer nouvelle connection string dans Azure Relay
2. Stocker nouvelle version dans Key Vault
3. Agent récupère automatiquement dernière version
4. Invalider ancienne connection string après validation

### Fréquence Recommandée

- **Rotation** : Tous les 90 jours
- **Audit** : Mensuel (via Azure Monitor)

---

_Dernière mise à jour : 2026-06-05_
