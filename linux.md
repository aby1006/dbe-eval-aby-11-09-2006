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



 Démarrer l'enregistrement :


script -q --timing=docs/preuves/linux.tm docs/preuves/linux.log



 L2 — Générer vos données 

    Dossier pour la compilation
    mkdir -p out
    on cree un fichier pour enregistrer le code java avec nano src/GenerateurLogs.java`

    Commande pour compiler le code  :
    javac -d out src/GenerateurLogs.java

    1-Lancer le programme sans argument en envoyant la sortie d'erreur dans logs/gen.err,  puis afficher le code de retour.
    java -cp out GenerateurLogs 2> logs/gen.err
    Afficher le code de retour :**


echo $?


Résultat : 1


**3. Afficher le message d'erreur :**
cat logs/gen.err
2-Générer 2 000 lignes avec son matricule dans logs/access.log, vérifier le nombre de lignes et afficher la première.
java -cp out GenerateurLogs TON_MATRICULE 2000 > logs/access.log



compter le nombre de ligne :
    wc -l logs/access.log
Résultat 
    2000 logs/access.log
```

Afficher la première ligne :
    head -n 1 logs/access.log




---






