# RECIT-404 : Alternative Terraform pour IaC

**Type** : Récit Utilisateur  
**ID** : RECIT-404  
**Épopée** : [EPOP-004](../Épopées/EPOP-004-infrastructure-as-code.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer préférant Terraform  
**Je veux** des modules Terraform équivalents aux Bicep  
**Afin de** utiliser mon outil préféré

---

## ✅ Critères d'Acceptation

- [ ] Modules Terraform dans `infra/terraform/`
- [ ] Parité fonctionnelle avec Bicep
- [ ] Backend remote state (Azure Storage)
- [ ] Documentation choix Bicep vs Terraform

---

## 📊 Informations

**Priorité** : Could Have  
**Effort** : 13 points  
**Sprint** : Sprint 4  
**Assigné** : Jordan

---

## 🔗 Dépendances

- ✅ [RECIT-401](RECIT-401-bicep-relay.md) : Comprendre structure Relay (référence)
- ✅ [RECIT-402](RECIT-402-bicep-proxy.md) : Comprendre structure Proxy (référence)
- 📄 ADR à créer : "Bicep vs Terraform" (justifier pourquoi les deux)

---

## 📝 Structure Terraform

### infra/terraform/

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── backend.tf
├── modules/
│   ├── relay/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── proxy/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── keyvault/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/
    ├── dev.tfvars
    ├── staging.tfvars
    └── prod.tfvars
```

### modules/relay/main.tf

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_relay_namespace" "main" {
  name                = "relay-llm-gateway-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name

  tags = {
    Environment = var.environment
    Project     = "private-llm-gateway"
  }
}

resource "azurerm_relay_hybrid_connection" "main" {
  name                          = var.hybrid_connection_name
  resource_group_name           = var.resource_group_name
  relay_namespace_name          = azurerm_relay_namespace.main.name
  requires_client_authorization = true
}

resource "azurerm_relay_namespace_authorization_rule" "main" {
  name                = "RootManageSharedAccessKey"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_relay_namespace.main.name

  listen = true
  send   = true
  manage = true
}
```

### modules/relay/variables.tf

```hcl
variable "location" {
  type        = string
  description = "Azure region"
  default     = "canadacentral"
}

variable "environment" {
  type        = string
  description = "Environment name"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "sku_name" {
  type        = string
  description = "SKU name"
  default     = "Standard"
}

variable "hybrid_connection_name" {
  type        = string
  description = "Hybrid connection name"
  default     = "llm-gateway-hc"
}
```

### modules/relay/outputs.tf

```hcl
output "namespace_name" {
  value       = azurerm_relay_namespace.main.name
  description = "Relay namespace name"
}

output "hybrid_connection_name" {
  value       = azurerm_relay_hybrid_connection.main.name
  description = "Hybrid connection name"
}

output "connection_string" {
  value       = azurerm_relay_namespace_authorization_rule.main.primary_connection_string
  sensitive   = true
  description = "Primary connection string (store in Key Vault)"
}
```

### main.tf (root)

```hcl
terraform {
  required_version = ">= 1.5"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstatelllmgateway"
    container_name       = "tfstate"
    key                  = "llm-gateway.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-llm-gateway-${var.environment}"
  location = var.location
  
  tags = {
    Environment = var.environment
    Project     = "private-llm-gateway"
  }
}

module "relay" {
  source = "./modules/relay"
  
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

module "keyvault" {
  source = "./modules/keyvault"
  
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

module "proxy" {
  source = "./modules/proxy"
  
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  
  depends_on = [module.relay, module.keyvault]
}
```

---

## 🚀 Déploiement

### Initialisation

```bash
cd infra/terraform

# Créer backend (une fois)
./scripts/terraform-setup-backend.sh

# Initialiser
terraform init

# Sélectionner workspace
terraform workspace new dev
terraform workspace select dev
```

### Déploiement

```bash
# Plan
terraform plan \
  -var-file="environments/dev.tfvars" \
  -out=tfplan

# Apply
terraform apply tfplan

# Outputs
terraform output -json > outputs.json
```

---

## 🧪 Tests

### Tests Terraform

- [ ] `terraform validate` réussit
- [ ] `terraform plan` sans erreurs
- [ ] Déploiement dev successful
- [ ] State stocké dans Azure Storage
- [ ] Outputs correctement exportés
- [ ] Parité fonctionnelle avec Bicep

---

## 📋 Checklist Implémentation

- [ ] Créer structure répertoires
- [ ] Implémenter module `relay`
- [ ] Implémenter module `proxy`
- [ ] Implémenter module `keyvault`
- [ ] Créer `main.tf` root
- [ ] Créer `backend.tf`
- [ ] Créer variables par environnement
- [ ] Script setup backend
- [ ] Tester déploiement complet
- [ ] Documenter choix Bicep vs Terraform
- [ ] Créer ADR-200 (IaC Tool Selection)

---

## 📚 ADR-200 : Bicep vs Terraform

### Décision

Support **dual IaC** : Bicep ET Terraform

### Justification

| Critère | Bicep | Terraform |
|---------|-------|-----------|
| **Learning curve** | Plus facile pour Azure | Plus complexe |
| **Azure native** | ✅ Oui | ❌ Non |
| **Multi-cloud** | ❌ Non | ✅ Oui |
| **Communauté** | ⚠️ Moyenne | ✅ Large |
| **State management** | ❌ Local | ✅ Remote |

### Recommandation Projet

- **Bicep** : Recommandé par défaut (simplicité)
- **Terraform** : Alternative pour utilisateurs experts

---

_Dernière mise à jour : 2026-06-05_
