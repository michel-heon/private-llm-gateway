---
adr: 607
title: "Gestion des Options dans les Scripts Bash"
status: "accepted"
date: 2026-06-05
classification:
  lifecycle: "accepted"
  domain: "devops"
  impact: "low"
  quality:
    - "usability"
    - "maintainability"
    - "portability"
  reversibility: "easy"
  scope: "tactical"
  tech_areas:
    - "bash"
superseded_by: null
replaces: null
related_adrs: [601, 605]
related_issues: []
stakeholders: ["@dev-team", "@devops-team"]
effort: "low"
tags: ["bash", "getopts", "options", "UX", "scripting", "dry-run", "help", "devops"]
---

# ADR-607 : Gestion des Options dans les Scripts Bash

## Vue d'Ensemble

**Problème** : `getopts` (POSIX) ne supporte pas les options longues (`--help`, `--dry-run`). Les scripts du projet utilisaient des conventions ad hoc, ou seulement des options courtes.

**Décision** : Utiliser le patron `while/case/shift` pour l'analyse des options, avec un jeu d'options standard et une fonction `_usage()` obligatoire.

**Impact** : UX uniforme, scripts auto-documentés, interopérables avec les cibles Makefile.

---

## Contexte

### Limitation de `getopts`

La commande intégrée `getopts` est définie par POSIX et **ne gère que les options courtes** (un seul caractère, ex. `-h`, `-v`). Toute tentative de lui passer `--help` ou `--output` produit une erreur ou un comportement indéfini.

```bash
# ❌ getopts — options longues impossibles
while getopts "hvo:" opt; do
    case "$opt" in
        h) _usage ;;   # fonctionne pour -h
        # --help → ignoré ou planté
    esac
done
```

### Besoin

Les scripts d'automatisation du projet doivent :

- Supporter les options longues explicites (`--help`, `--dry-run`, `--output`) pour la lisibilité
- Rester compatibles avec les équivalents courts (`-h`, `-n`, `-o`) pour la rapidité
- Documenter leurs options via `--help` afin d'être auto-découvrables
- Proposer un mode `--dry-run` pour inspecter la configuration résolue sans effets de bord

---

## Décision

### 1. Patron d'analyse des options : `while/case/shift`

```bash
# ✅ Patron obligatoire — supporte short ET long options
VERBOSE=false
DRY_RUN=false
OUTPUT_ARG=""
POSITIONAL=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)    _usage; exit 0 ;;
        -v|--verbose) VERBOSE=true ;;
        -n|--dry-run) DRY_RUN=true ;;
        -o|--output)
            if [[ $# -lt 2 ]]; then
                printf "${RED}✘ %s requiert un argument${RESET}\n" "$1" >&2
                _usage >&2; exit 1
            fi
            OUTPUT_ARG="$2"; shift ;;
        --)           shift; break ;;
        -*)           printf "${RED}✘ Option inconnue : %s${RESET}\n" "$1" >&2
                      _usage >&2; exit 1 ;;
        *)            [[ -z "$POSITIONAL" ]] && POSITIONAL="$1" ;;
    esac
    shift
done
# Arguments positionnels restants après --
[[ $# -gt 0 && -z "$POSITIONAL" ]] && POSITIONAL="$1"
```

**Points clés** :

| Élément | Règle |
|---------|-------|
| `shift` en fin de boucle | Avance systématiquement au prochain argument |
| `shift` dans le cas d'option à valeur | Consomme l'argument de valeur (`$2`) avant le `shift` de boucle |
| `$# -lt 2` avant `$2` | Détecte l'option sans argument (ex. `-o` en fin de ligne) |
| `--` | Termine le parsing ; arguments suivants sont positionnels |
| `-*` | Capture toute option inconnue → erreur + aide |
| Argument positionnel | Capturé dans la branche `*)`, premier seulement |

---

### 2. Options standard

Tout script exposé aux utilisateurs ou aux cibles Makefile DOIT implémenter :

| Option courte | Option longue | Comportement | Obligatoire |
|---------------|---------------|--------------|-------------|
| `-h` | `--help` | Affiche l'aide et quitte avec code 0 | ✅ Oui |
| `-v` | `--verbose` | Active les sorties détaillées | Recommandé |
| `-n` | `--dry-run` | Affiche la config résolue, quitte sans effet | Recommandé |
| `-o <f>` | `--output <f>` | Redirige la sortie vers un fichier | Si applicable |

---

### 3. Fonction `_usage()`

Chaque script doit définir une fonction `_usage()` **avant** la boucle d'analyse.

```bash
_usage() {
    printf "${BOLD}mon-script.sh${RESET} — description courte\n\n"
    printf "${BOLD}Usage :${RESET}\n"
    printf "  mon-script.sh [-h] [-v] [-n] [-o <fichier>] [<argument>]\n\n"
    printf "${BOLD}Options :${RESET}\n"
    printf "  ${GREEN}-h, --help${RESET}               Affiche cette aide et quitte\n"
    printf "  ${GREEN}-v, --verbose${RESET}            Sorties détaillées\n"
    printf "  ${GREEN}-n, --dry-run${RESET}            Config résolue sans exécution\n"
    printf "  ${GREEN}-o, --output${RESET} ${BOLD}<fichier>${RESET}  Fichier de sortie\n\n"
    printf "${BOLD}Argument :${RESET}\n"
    printf "  ${GREEN}<argument>${RESET}               Description (défaut : valeur)\n\n"
    printf "${BOLD}Exemples :${RESET}\n"
    printf "  mon-script.sh\n"
    printf "  mon-script.sh --dry-run\n"
    printf "  mon-script.sh -v -o /tmp/out.txt\n"
}
```

**Règles** :
- Préfixe `_` (fonction interne, non exportée)
- Utiliser `printf` exclusivement (cf. ADR-605)
- Variables couleur dans la **chaîne de format**, jamais dans un argument `%s`

---

### 4. Variables couleur dans `printf` — piège fréquent

Les variables ANSI (`$GREEN`, `$RESET`, `$BOLD`…) **doivent apparaître dans la chaîne de format** de `printf`, pas comme argument `%s`. Sinon les séquences d'échappement sont affichées littéralement (`\033[0;32m`).

```bash
# ❌ Mauvais — couleur passée comme argument %s
printf "%s Option :${RESET}\n" "${GREEN}-h, --help"

# ❌ Mauvais — valeur par défaut avec couleur dans substitution
printf "%s\n" "${OUTPUT_ARG:-${YELLOW}(stdout)${RESET}}"

# ✅ Correct — couleur dans la chaîne de format littérale
printf "  ${GREEN}-h, --help${RESET}   Affiche l'aide\n"

# ✅ Correct — conditionnel si la valeur est variable
if [[ -n "$OUTPUT_ARG" ]]; then
    printf "  Output : %s\n" "$OUTPUT_ARG"
else
    printf "  Output : ${YELLOW}(stdout)${RESET}\n"
fi
```

> Voir aussi ADR-605 pour les couleurs dans les Makefiles.

---

### 5. Convention `--dry-run`

Le mode `--dry-run` affiche la **configuration résolue** (chemins absolus, URL, valeurs par défaut appliquées) sans exécuter aucune action.

```bash
if $DRY_RUN; then
    printf "${BOLD}[dry-run] Configuration résolue :${RESET}\n"
    printf "  Relay Connection : %s\n" "$AZURE_RELAY_CONNECTION_STRING"
    if [[ -n "$OUTPUT_ARG" ]]; then
        printf "  Sortie   : %s\n" "$OUTPUT_ARG"
    else
        printf "  Sortie   : ${YELLOW}(stdout)${RESET}\n"
    fi
    printf "  Gateway URL : %s\n" "$GATEWAY_URL"
    printf "  Verbose     : %s\n" "$VERBOSE"
    printf "${YELLOW}Aucune action exécutée (dry-run).${RESET}\n"
    exit 0
fi
```

**Règles** :
- Toujours afficher les valeurs **après résolution** (chemins absolus, fallbacks appliqués)
- Quitter avec code `0`
- Message terminal indiquant clairement qu'aucune action n'a été effectuée

---

### 6. Commentaire d'en-tête obligatoire

La ligne `# Usage :` en en-tête du script doit refléter les options réelles :

```bash
#!/usr/bin/env bash
# shellcheck shell=bash
# scripts/mon-script.sh
# Description courte du script
#
# Usage : mon-script.sh [-h] [-v] [-n] [-o <fichier>] [<argument>]
```

---

## Conséquences

### Positives ✅

- **Auto-documentation** : `mon-script.sh --help` affiche usage et options sans lire le code
- **Cohérence** : tous les scripts du projet partagent le même patron de parsing et les mêmes options standard
- **Portabilité** : `while/case/shift` est compatible Bash ≥ 4, zsh, et tout environnement Unix
- **Testabilité** : `--dry-run` permet de valider la résolution de config sans lancer le vrai traitement
- **UX** : les options longues sont lisibles dans les cibles Makefile et les scripts CI

### Négatives ⚠️

- Légèrement plus verbeux que `getopts` pour les scripts à options courtes uniquement
- Le `shift` double (option + valeur) peut induire en erreur si mal placé

---

## Implémentation de Référence

Scripts existants dans le projet :
- `scripts/check-local-endpoint.sh`
- `scripts/check-public-endpoint.sh`
- `scripts/start-litellm.sh`
- `scripts/start-local-agent.sh`
- `scripts/start-ollama.sh`

À adapter avec les options standard (`-h`, `-v`, `-n`) selon les besoins.

---

## Alternatives Rejetées

| Alternative | Raison du rejet |
|-------------|-----------------|
| `getopts` seul | Ne supporte pas les options longues (limitation POSIX) |
| `getopt` (GNU) | Non disponible sur macOS sans Homebrew ; comportement variable entre implémentations |
| Bibliothèque externe (`shflags`, etc.) | Dépendance inutile pour un besoin simple et maîtrisé |
| Options longues simulées par convention (`--help → -help`) | Non-standard, source de confusion |

---

**Projet**: private-llm-gateway  
**Repo**: https://github.com/michel-heon/private-llm-gateway  
**Date**: 2026-06-05
