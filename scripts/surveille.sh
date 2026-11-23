#!/usr/bin/env bash

trap 'echo "arrêt propre" >> logs/surveillance.log; exit 0' SIGTERM

while true
do
    heure=$(date "+%Y-%m-%d %H:%M:%S")
    nombre=$(wc -l < logs/access.log)

    echo "$heure - Nombre de lignes : $nombre" >> logs/surveillance.log

    sleep 5
done
