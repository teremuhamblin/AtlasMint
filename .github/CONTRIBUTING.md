---

📄 CONTRIBUTING.md

`markdown

Contribuer au projet

Merci de votre intérêt pour mint-postinstall !  
Les contributions sont les bienvenues, qu’il s’agisse de corrections, d’améliorations ou de nouveaux modules.

Comment contribuer

1. Fork & branche
- Forkez le dépôt
- Créez une branche dédiée :
  `bash
  git checkout -b feature/ma-fonctionnalite
  `

2. Style et bonnes pratiques
- Scripts en Bash POSIX ou Bash strict (set -euo pipefail)
- Noms de fichiers explicites
- Logging via utils/logging.sh
- Pas de commandes destructives sans confirmation
- Commentaires clairs et concis

3. Tests manuels
Avant toute PR :
- Vérifiez que le script fonctionne sur Linux Mint (dernière version)
- Testez en mode root et non-root
- Vérifiez qu’aucune dépendance inutile n’est ajoutée

4. Pull Request
Une PR doit inclure :
- Une description claire
- Le problème résolu ou la fonctionnalité ajoutée
- Les impacts potentiels
- Les tests effectués

Code de conduite
Toutes les contributions doivent respecter le fichier CODEOFCONDUCT.md.

Merci de rendre ce projet meilleur !
`

---
