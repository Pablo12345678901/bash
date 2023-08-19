#!/usr/bin/env bash

# Liste des lignes avec Début / fin (3 lignes)
# Liste des arrêts sur une ligne
# Liste des horaires d'une ligne pour les passages sur un arrêt
# Chemin pour un bus (début avec 3 lignes) + nom du conducteur
# Liste des conducteurs
# COMMENTAIRE

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

# Affichage des datas
mysql "$NOM_DB" <<AFFICHAGEDATA
SELECT NUMERO_LIGNE, ARRET_DEBUT, TERMINUS from $NOM_TABLE_LIGNE_BUS 
AFFICHAGEDATA



# Ci-dessous - autres exemples

# OK - SELECT GROUP_CONCAT( NUMERO_LIGNE, 0x1D, ARRET_DEBUT, 0x1D, TERMINUS SEPARATOR 0x1D ) from $NOM_TABLE_LIGNE_BUS 

: <<"OK"
mysql "$NOM_DB" <<OBTENTIONNOMCOLONNE
select column_name 
  from information_schema.columns 
 where table_schema = '$NOM_DB' 
   and table_name = '$NOM_TABLE_LIGNE_BUS'
OBTENTIONNOMCOLONNE
OK

: <<"DEVIDEV"
mysql "$NOM_DB" <<OBTENTIONNOMCOLONNE
select column_name 
  from information_schema.columns 
 where table_schema = '$NOM_DB' 
   and table_name = '$NOM_TABLE_LIGNE_BUS'
OBTENTIONNOMCOLONNE
DEVIDEV