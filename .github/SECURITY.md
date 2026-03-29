# Politique de sécurité

## Versions supportées
Seule la dernière version stable du projet reçoit des correctifs de sécurité.

| Version | Support |
|--------|---------|
| 1.x    | ✔️ Actif |
| 0.x    | ❌ Non supporté |

## Signalement d’une vulnérabilité
Si vous découvrez une faille :
1. Ne la divulguez pas publiquement.
2. Contactez immédiatement les mainteneurs via un canal privé.
3. Fournissez :
   - Description du problème
   - Étapes de reproduction
   - Impact potentiel
   - Correctif proposé (si possible)

Nous nous engageons à :
- Accuser réception sous 72h
- Évaluer la gravité
- Proposer un correctif dans un délai raisonnable
- Publier un avis de sécurité si nécessaire

## Bonnes pratiques internes
Le projet applique :
- Scripts Bash stricts (`set -euo pipefail`)
- Vérification des permissions
- Durcissement système (UFW, AppArmor, sysctl)
- Audit régulier via Lynis
- Revue de code obligatoire pour les PR sensibles
