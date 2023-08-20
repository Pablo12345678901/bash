#!/usr/bin/env bash

# Syntaxe :
# - : pas d'arguments.

# Liste des lignes avec Début / fin (3 lignes)
# Liste des arrêts sur une ligne
# Liste des horaires d'une ligne pour les passages sur un arrêt
# Chemin pour un bus (début avec 3 lignes) + nom du conducteur
# Liste des conducteurs
# COMMENTAIRE

echo -e "Script en cours de développement -> exit."
exit 0


NOM_DB="TPG_TEST_DEV"
NOM_TABLE_LIGNE_BUS="LISTE_LIGNES"

mysql <<-CREATIONDB
-- Commentaire sur une ligne
/* Commentaire sur plusieurs lignes */
CREATE DATABASE IF NOT EXISTS $NOM_DB; -- Création de la DB
CREATIONDB

mysql "$NOM_DB" <<CREATIONTABLE # création de la table
DROP TABLE $NOM_TABLE_LIGNE_BUS; -- Suppression de la DB s'il elle devient brouillon

CREATE TABLE IF NOT EXISTS $NOM_TABLE_LIGNE_BUS (
    NUMERO_LIGNE SMALLINT, -- = short int
    ARRET_DEBUT CHAR(50), -- = String max 50 char
    TERMINUS CHAR(50), -- = String max 50 char
    PRIMARY KEY (NUMERO_LIGNE)
);
CREATIONTABLE

TABLEAU_LIGNES=(1 2 3)
TABLEAU_ARRET_DEBUT=("Thônex, Hôpital Trois-Chêne" "Genève, Plage" "Grand-Saconnex, Gardiol")
TABLEAU_TERMINUS=("Genève, Jardin Botanique" "Genève, Bernex, Cressy" "Genève, Miremont")

for ((i=0; i<${#TABLEAU_LIGNES[@]}; i++))
do

    mysql "$NOM_DB" <<INSERTIONDATADSTABLE
    INSERT INTO $NOM_TABLE_LIGNE_BUS (NUMERO_LIGNE, ARRET_DEBUT, TERMINUS) -- ajout des datas de la ligne 1 dans la table
    VALUES (${TABLEAU_LIGNES[$i]},"${TABLEAU_ARRET_DEBUT[$i]}","${TABLEAU_TERMINUS[$i]}" );
INSERTIONDATADSTABLE

done

# Récupération des datas ligne par ligne et champs par champs
NB_COLONNE_TABLE=3
STR_MARQUANT_LA_FIN_DE_LIGNE=$'\n'
STR_SEPARATEUR_DE_CHAMPS=$'\b' # le char nul ne fonctionne pas
SEPARATEUR_CHAMPS_A_L_AFFICHAGE="\t\t" # ou $'\0'
NB_LIGNE_A_NE_PAS_AFFICHER=2 # évite d'afficher l'entête
# Affichage des datas
while read -r LIGNE || [ -n "$LIGNE" ]
do
  if [ $NB_LIGNE_A_NE_PAS_AFFICHER -eq 0 ]
  then
    STRING_AFFICHAGE="" # remise à vide à chaque lecture d'une nouvelle ligne
    for ((i=0; i<$NB_COLONNE_TABLE; i++))
    do
      # Récupération de chaque champs via son numéro de field selon le séparateur précisé ci-dessus.
      VALEUR="$(echo "$LIGNE" | gawk -v INDEX=$((i+1)) -F $STR_SEPARATEUR_DE_CHAMPS '{ printf ("%s",$INDEX) } ')"
      # Ajout du champs à l'affichage avec un séparateur.
      STRING_AFFICHAGE="${STRING_AFFICHAGE}${VALEUR}${SEPARATEUR_CHAMPS_A_L_AFFICHAGE}"
    done
    echo -e "$STRING_AFFICHAGE"
  else 
    ((NB_LIGNE_A_NE_PAS_AFFICHER--))
  fi
  # Obtention des datas séparées par des chars spéciaux pour pouvoir les récupérer
  # et travailler dessus (ou sur leur affichage) ensuite.
done < <(
# Utilisation de printf "%b" pour 'décoder' le char spéciaux injectés entre les champs et en fin de ligne (non interprêtés sinon). 
printf "%b" "$(mysql "$NOM_DB" <<AFFICHAGEDATA
SELECT GROUP_CONCAT(NUMERO_LIGNE, '$STR_SEPARATEUR_DE_CHAMPS', ARRET_DEBUT, '$STR_SEPARATEUR_DE_CHAMPS', TERMINUS SEPARATOR '$STR_MARQUANT_LA_FIN_DE_LIGNE') 
FROM $NOM_TABLE_LIGNE_BUS;
AFFICHAGEDATA
)"
)
