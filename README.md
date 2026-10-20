#  Linux File Audit & Security Script

> Un script d'audit de sécurité automatisé écrit en **Bash**, conçu pour analyser l'intégrité, les métadonnées et les permissions des fichiers au sein d'une arborescence Linux.

---

##  Table des matières
- [À propos du projet](#-à-propos-du-projet)
- [Fonctionnalités](#-fonctionnalités)
- [Comment ça marche (Détails techniques)](#-comment-ça-marche-détails-techniques)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Exemple de sortie](#-exemple-de-sortie)
- [Auteur](#-auteur)

---

##  À propos du projet
Développé dans le cadre de mon parcours en cybersécurité et administration système Linux, ce script automatise la recherche de fichiers modifiés récents et l'identification de failles potentielles de permissions (comme les fichiers *world-writable*), qui représentent un risque majeur d'élévation de privilèges ou de compromission.

##  Fonctionnalités
* **Recherche récursive ciblée** : Analyse les fichiers modifiés au cours des 7 derniers jours (`-mtime -7`) dans un répertoire spécifié.
* **Collecte de métadonnées** : Récupère automatiquement le propriétaire (`stat -c "%U"`) et la date exacte de modification (`stat -c "%y"`) de chaque fichier.
* **Détection des risques de sécurité** : Identifie et signale en temps réel les fichiers dont les permissions d'écriture sont ouvertes à tous (`others` + `w`).
* **Journalisation propre** : Enregistre l'ensemble des résultats dans un fichier journal (`file_audit.log`) et nettoie les anciens rapports à chaque nouveau lancement.
* **Architecture modulaire** : Utilisation de fonctions Bash distinctes pour séparer la logique de parcours et la logique de vérification de sécurité.

---

##  Comment ça marche (Détails techniques)

Le script s'articule autour de plusieurs blocs logiques clés :

1. **La fonction de parcours (`process_files`)** :
   - Utilise la commande `find <dossier> -type f -mtime -7 2>/dev/null` pour lister récursivement tous les fichiers modifiés ces 7 derniers jours tout en masquant les erreurs d'accès refusé.
   - Extrait le propriétaire (`stat -c "%U"`) et la date de modification (`stat -c "%y"`).

2. **La fonction de sécurité (`check_world_writable`)** :
   - Vérifie si le fichier est inscriptible (`-w`).
   - Analyse les permissions en octal via `stat -c "%a"` et isole le chiffre des *others* (autres utilisateurs) avec `cut -c 3`. Si ce chiffre vaut `7` (`rwx`), une alerte est déclenchée.

3. **La gestion des arguments et des compteurs** :
   - Vérifie qu'un et un seul argument valide (un répertoire) est passé au script avant de lancer l'audit et de consigner le tout dans `file_audit.log`.

---

##  Prérequis
* Un système d'exploitation **Linux** (Ubuntu, Debian, Kali Linux, etc.).
* Un interpréteur **Bash** fonctionnel.

##  Installation
1. Clone le dépôt sur ta machine locale :
   ```bash
   git clone [https://github.com/Davy-Burck/linux-security-audit-tool.git](https://github.com/Davy-Burck/linux-security-audit-tool.git)
   cd linux-security-audit-tool

    Rends le script exécutable :
    Bash

    chmod +x audit.sh
   
Utilisation

./audit.sh /chemin/vers/le/dossier

Exemple de sortie

Scan complete. Results:
------------------------
Total files modified in last 7 days: 32
World-writable files: 0
Log saved to file_audit.log

Auteur

Davy-Burck

Parcours professionnel exigeant en reconversion vers la cybersécurité.
