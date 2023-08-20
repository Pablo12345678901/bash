CREATE TABLE IF NOT EXISTS TABLE_TEST (
    NUMERO_LIGNE SMALLINT, -- = short int
    ARRET_DEBUT CHAR(50), -- = String max 50 char
    TERMINUS CHAR(50), -- = String max 50 char
    PRIMARY KEY (NUMERO_LIGNE)
);

INSERT INTO TABLE_TEST (NUMERO_LIGNE, ARRET_DEBUT, TERMINUS) -- ajout des datas de la ligne 1 dans la table
VALUES (1, "Thônex, Hôpital Trois-Chêne", "Genève, Jardin Botanique");
INSERT INTO TABLE_TEST (NUMERO_LIGNE, ARRET_DEBUT, TERMINUS) -- ajout des datas de la ligne 1 dans la table
VALUES (2, "Genève, Plage", "Genève, Bernex, Cressy");
INSERT INTO TABLE_TEST (NUMERO_LIGNE, ARRET_DEBUT, TERMINUS) -- ajout des datas de la ligne 1 dans la table
VALUES (3, "Grand-Saconnex, Gardiol", "Genève, Miremont");