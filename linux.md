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


Afficher le message d'erreur :
cat logs/gen.err
2-Générer 2 000 lignes avec son matricule dans logs/access.log, vérifier le nombre de lignes et afficher la première.
java -cp out GenerateurLogs TON_MATRICULE 2000 > logs/access.log



compter le nombre de ligne :
    wc -l logs/access.log
Résultat 
    2000 logs/access.log


Afficher la première ligne :
    head -n 1 logs/access.log




L3 — ANALYSER LE JOURNAL 



 a. Le nombre de requêtes par code HTTP, du plus fréquent au moins fréquent.
    awk '{print $9}' logs/access.log | sort | uniq -c | sort -rn


 b. Les 3 endpoints les plus appelés, sans la partie page=...
    awk '{print $7}' logs/access.log | sed 's/?page=.*//' | sort | uniq -c | sort  -rn | head -n 3


 c. Le nombre d'adresses IP distinctes.


awk '{print $1}' logs/access.log | sort -u | wc -l


d. L'IP qui a le plus d'échecs 401 sur `/api/auth/login`, avec son nombre d'échecs.
    awk '$9 == 401 && $7 == "/api/auth/login" {print $1}' logs/access.log | sort | uniq -c | sort -rn | head -n 1


 e. Le temps de réponse moyen des requêtes en 200, avec une décimale (utilisez awk).
    awk '$9 == 200 {gsub(/ms/, "", $11); somme += $11; n++} END {if(n) printf "%.1f ms\n", somme/n}' logs/access.log


 f. La ligne complète de la requête la plus lente.
    awk '{ligne=$0; gsub(/ms/, "", $11); if ($11+0 > max) {max=$11+0; meilleure=ligne}} END {print meilleure}' logs/access.log

 g. Le nombre de requêtes par heure (08, 09, 10...).
    awk '{split($4,a,":"); print a[2]}' logs/access.log | sort | uniq -c


 h. Toutes les erreurs 5xx copiées dans `logs/errors_5xx.log` avec grep -E, puis leur nombre.
    grep -E ' 5[0-9]{2} ' logs/access.log | tee logs/errors_5xx.log | wc -l


 i. Une copie anonymisée `logs/access_anonyme.log` où chaque IP est remplacée par x.x.x.x (avec sed -E).
    sed -E 's/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/x.x.x.x/' logs/access.log > logs/access_anonyme.log


j. Tous les fichiers `.log` du projet modifiés il y a moins de 60 minutes et de plus de 1 Ko, avec leur nombre de lignes, en une seule commande find.
    find . -type f -name "*.log" -mmin -60 -size +1k -exec wc -l {} +











