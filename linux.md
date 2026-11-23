 PARTIE 2 — LINUX PRATIQUE

    L1 — Environnement et preuves (2 pts)
        Question 1 : Création des dossiers

            1-Créer en une seule commande le dossier `~/dbe-eval-MATRICULE` et ses sous-   dossiers `src`, `scripts`, `logs`, `docs/preuves`, `rapports` et `rendus`.
                mkdir -p ~/dbe-eval-MATRICULE/{src,scripts,logs,docs/preuves,rapports,rendus}

            Question 2 : Configuration du Bash

            Ajouter les variables MATRICULE et HISTTIMEFORMAT dans le fichier ~/.bashrc, recharger la configuration puis afficher MATRICULE.


            echo 'export MATRICULE="aby-11-09-2006"' >> ~/.bashrc



            echo 'export HISTTIMEFORMAT="%F %T "' >> ~/.bashrc
            source ~/.bashrc


            Afficher le matricule :

echo $MATRICULE




Le matricule personnel s'affiche dans le terminal.

Question 3 : Enregistrement de la session



 Démarrer l'enregistrement :**


script -q --timing=docs/preuves/linux.tm docs/preuves/linux.log








