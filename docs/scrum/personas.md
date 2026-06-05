# Personas — Private LLM Gateway

Personas identifiés pour guider le développement du projet.

---

## 👨‍💻 Persona 1 : Alex, Développeur Solo / Mainteneur

### Profil
- **Rôle** : Développeur Python, architecte du projet
- **Contexte** : Travaille seul ou en petite équipe, temps partiel sur le projet
- **Environnement** : macOS Apple Silicon (M1/M2/M3), VS Code, GitHub Copilot

### Objectifs
1. **Utiliser un LLM local** pour Copilot Chat sans envoyer de code en externe
2. **Éviter les coûts cloud** des API OpenAI/Azure OpenAI pour le développement quotidien
3. **Maintenir la confidentialité** du code propriétaire/personnel
4. **Optimiser les performances** sur Apple Silicon (macMLX > Ollama)

### Points de Frustration
- ❌ Configuration complexe multi-composants (Azure Relay, proxy, agent)
- ❌ Documentation éparpillée, manque de guides step-by-step
- ❌ Temps perdu à résoudre des problèmes de connectivité Azure Relay
- ❌ Overhead de gestion manuelle des sprints/backlog

### Besoins Prioritaires
- ✅ **Documentation claire** : guides setup rapides, troubleshooting
- ✅ **Automation** : scripts make/bash pour démarrer tous les composants
- ✅ **Monitoring simple** : logs structurés, health checks
- ✅ **Méthodologie légère** : Scrum adapté au solo/petite équipe

### User Stories Clés
- US-001 : Démarrer tout le stack en une commande (`make start`)
- US-010 : Documenter les patterns de troubleshooting courants
- US-020 : Ajouter health checks automatiques

---

## 👷 Persona 2 : Jordan, DevOps Engineer

### Profil
- **Rôle** : Ingénieur DevOps, responsable du déploiement Azure
- **Contexte** : Gère l'infrastructure Azure (Relay, proxy, Key Vault)
- **Environnement** : Azure CLI, Terraform/Bicep, GitHub Actions

### Objectifs
1. **Automatiser le déploiement** Azure Relay + HTTPS proxy
2. **Sécuriser les secrets** (connection strings, API keys) dans Key Vault
3. **Monitorer la santé** du relay et du proxy (métriques, alertes)
4. **Gérer les coûts** Azure (optimisation des SKUs, alertes budget)

### Points de Frustration
- ❌ Manque de templates IaC prêts à l'emploi (Bicep/Terraform)
- ❌ Configuration manuelle des Hybrid Connections
- ❌ Rotation des secrets non automatisée
- ❌ Pas de monitoring out-of-the-box

### Besoins Prioritaires
- ✅ **IaC complète** : Bicep/Terraform pour provisionner Azure Relay + proxy
- ✅ **CI/CD pipeline** : GitHub Actions pour déploiement automatisé
- ✅ **Observabilité** : Application Insights, Log Analytics
- ✅ **Documentation opérationnelle** : runbooks, disaster recovery

### User Stories Clés
- US-200 : Créer template Bicep pour Azure Relay + App Service proxy
- US-201 : Automatiser rotation des Relay connection strings
- US-202 : Intégrer Application Insights dans le proxy

---

## 🧑‍💼 Persona 3 : Sam, Utilisateur Final (Développeur Client)

### Profil
- **Rôle** : Développeur utilisant VS Code + GitHub Copilot
- **Contexte** : Veut utiliser le gateway comme endpoint personnalisé
- **Environnement** : VS Code (toutes plateformes), Copilot Chat BYOK

### Objectifs
1. **Configurer VS Code** pour pointer vers `https://llm.example.com/v1`
2. **Tester la connectivité** entre Copilot et le gateway
3. **Utiliser des modèles personnalisés** (ex: `qwen2.5-coder:32b`)
4. **Comprendre les limitations** (quelles features Copilot fonctionnent)

### Points de Frustration
- ❌ Incertitude sur les features Copilot supportées (BYOK scope flou)
- ❌ Erreurs de connexion obscures (auth, timeout, format de réponse)
- ❌ Manque de feedback sur les requêtes en échec
- ❌ Documentation VS Code settings insuffisante

### Besoins Prioritaires
- ✅ **Guide d'intégration clair** : configuration VS Code pas-à-pas
- ✅ **Test de connectivité** : script pour valider `curl` avant VS Code
- ✅ **Liste des modèles compatibles** : mapping Ollama/macMLX ↔ OpenAI
- ✅ **FAQ troubleshooting** : erreurs courantes et solutions

### User Stories Clés
- US-300 : Guide intégration VS Code Copilot BYOK
- US-301 : Script de test endpoint (`scripts/test-endpoint.sh`)
- US-302 : Documentation modèles compatibles

---

## 🔒 Persona 4 : Riley, Security Engineer

### Profil
- **Rôle** : Ingénieur sécurité, audit de conformité
- **Contexte** : Valide la posture de sécurité avant mise en production
- **Environnement** : Azure Security Center, SIEM, penetration testing

### Objectifs
1. **Valider l'architecture sécurité** : TLS, auth, isolation réseau
2. **Auditer les secrets** : pas de credentials hardcodés
3. **Tester la résilience** : rate limiting, DDoS mitigation
4. **Assurer la compliance** : logs auditables, RGPD si applicable

### Points de Frustration
- ❌ Absence de threat model documenté
- ❌ Pas de security best practices clairement listées
- ❌ Redaction des prompts/logs non garantie
- ❌ Manque de tests de sécurité automatisés

### Besoins Prioritaires
- ✅ **Threat modeling** : diagramme d'attaque surface
- ✅ **Security checklist** : validation pre-production
- ✅ **Secrets management** : Azure Key Vault intégré
- ✅ **Audit logging** : structured logs avec redaction PII

### User Stories Clés
- US-400 : Créer threat model diagram
- US-401 : Implémenter log redaction (prompts, API keys)
- US-402 : Intégrer Azure Key Vault pour secrets

---

## 📊 Matrice Personas vs Priorités

| Feature | Alex (Dev) | Jordan (DevOps) | Sam (User) | Riley (Sec) | Priorité |
|---------|------------|-----------------|------------|-------------|----------|
| **Documentation setup** | 🔴 Critique | 🟢 Nice-to-have | 🔴 Critique | 🟡 Important | **P0** |
| **Scripts automation** | 🔴 Critique | 🟡 Important | 🟢 Nice-to-have | 🟢 Nice-to-have | **P0** |
| **IaC templates** | 🟡 Important | 🔴 Critique | 🟢 Nice-to-have | 🟡 Important | **P1** |
| **Security hardening** | 🟡 Important | 🟡 Important | 🟢 Nice-to-have | 🔴 Critique | **P1** |
| **VS Code integration guide** | 🟡 Important | 🟢 Nice-to-have | 🔴 Critique | 🟢 Nice-to-have | **P0** |
| **Monitoring/Observability** | 🟡 Important | 🔴 Critique | 🟢 Nice-to-have | 🟡 Important | **P2** |

**Légende** :
- 🔴 Critique : Bloquant pour le persona
- 🟡 Important : Améliore significativement l'expérience
- 🟢 Nice-to-have : Bonus apprécié mais non essentiel

---

_Dernière mise à jour : 2026-06-05_
