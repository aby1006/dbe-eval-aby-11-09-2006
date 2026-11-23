#!/usr/bin/env bash
set -euo pipefail
usage() {
    echo "Usage : bash scripts/analyse.sh <fichier.log> [--top N]" >&2
}
verifier_arguments() {
    if [[ $# -ne 1 && $# -ne 3 ]]; then
        usage
        return 1
    fi

    if [[ $# -eq 3 && "$2" != "--top" ]]; then
        usage
        return 1
    fi

    if [[ $# -eq 3 && ! "$3" =~ ^[1-9][0-9]*$ ]]; then
        usage
        return 1
    fi
}
verifier_fichier() {
    if [[ ! -f "$1" ]]; then
        echo "Erreur : le fichier n'existe pas" >&2
        return 2
    fi
}
verifier_donnees() {
    if [[ ! -s "$1" || -z "${MATRICULE:-}" ]]; then
        echo "Erreur : fichier vide ou MATRICULE non défini" >&2
        return 3
    fi
}
calculer_statistiques() {
    local fichier="$1"

    echo "Nombre total de requêtes : $(wc -l < "$fichier")"

    for code in 2 3 4 5; do
        awk -v code="$code" '$9 ~ ("^" code) {n++}
        END {print "Nombre de requêtes " code "xx : " n+0}' "$fichier"
    done
}
top_endpoints() {
    local fichier="$1"
    local limite="$2"

    echo "Top $limite des endpoints :"
    awk '{print $7}' "$fichier" |
        sed 's/?page=.*//' |
        sort |
        uniq -c |
        sort -rn |
        head -n "$limite"
}
ip_suspecte() {
    local fichier="$1"

    echo "IP suspecte (échecs 401 sur /api/auth/login) :"

    awk '$9 == 401 && $7 == "/api/auth/login" {print $1}' "$fichier" |
        sort |
        uniq -c |
        sort -rn |
        head -n 1
}
temps_moyen() {
    local fichier="$1"

    echo "Temps de réponse moyen (HTTP 200) :"
    awk '$9 == 200 {
        gsub(/ms/, "", $11)
        somme += $11
        n++
    }
    END {
        if (n > 0)
            printf "%.1f ms\n", somme/n
        else
            print "Aucune requête HTTP 200"
    }' "$fichier"
}
generer_rapport() {
    local fichier="$1"
    local limite="$2"
    local date_rapport
    local nom_rapport

    date_rapport=$(date +"%Y%m%d_%H%M")
    nom_rapport="rapports/rapport_${MATRICULE}_${date_rapport}.txt"

    {
        echo "===== RAPPORT D'ANALYSE ====="
        echo "Date : $(date)"
        echo "Utilisateur / Machine : $(whoami)@$(hostname)"
        echo "Matricule : $MATRICULE"
        echo "SHA256 : $(sha256sum "$fichier" | awk '{print $1}')"
        echo

        calculer_statistiques "$fichier"
        echo

        top_endpoints "$fichier" "$limite"
        echo

        ip_suspecte "$fichier"
        echo

        temps_moyen "$fichier"

    } > "$nom_rapport"

    echo "Rapport créé : $nom_rapport"
}
main() {
    verifier_arguments "$@" || return 1

    local fichier="$1"
    local limite=3

    if [[ $# -eq 3 ]]; then
        limite="$3"
    fi

    verifier_fichier "$fichier" || return $?

    verifier_donnees "$fichier" || return $?

    mkdir -p rapports
    generer_rapport "$fichier" "$limite"
}

main "$@"
