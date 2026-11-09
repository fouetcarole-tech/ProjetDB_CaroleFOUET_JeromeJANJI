
CREATE DATABASE IF NOT EXISTS labo_immunotherapie
    CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE labo_immunotherapie;


-- Suppression des tables 

DROP TABLE IF EXISTS utiliser;
DROP TABLE IF EXISTS participe;
DROP TABLE IF EXISTS echantillon;
DROP TABLE IF EXISTS essai;
DROP TABLE IF EXISTS publication;
DROP TABLE IF EXISTS finance;
DROP TABLE IF EXISTS etudier;
DROP TABLE IF EXISTS chercheur;
DROP TABLE IF EXISTS equipe;
DROP TABLE IF EXISTS laboratoire;
DROP TABLE IF EXISTS projet;
DROP TABLE IF EXISTS collaborateur;
DROP TABLE IF EXISTS molecule;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS equipement;


-- Entités fortes sans clé étrangère

CREATE TABLE laboratoire (
    id_laboratoire  INT,
    nom_laboratoire VARCHAR(100) NOT NULL,
    CONSTRAINT pk_laboratoire PRIMARY KEY (id_laboratoire)
);

CREATE TABLE collaborateur (
    id_collaborateur  INT,
    nom_collaborateur VARCHAR(100) NOT NULL,
    CONSTRAINT pk_collaborateur PRIMARY KEY (id_collaborateur)
);

CREATE TABLE projet (
    id_projet  INT,
    nom_projet VARCHAR(150) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin   DATE NOT NULL,
    CONSTRAINT pk_projet PRIMARY KEY (id_projet)
);

CREATE TABLE molecule (
    id_molecule     INT,
    nom_molecule    VARCHAR(100) NOT NULL,
    type_traitement VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_molecule PRIMARY KEY (id_molecule)
);

CREATE TABLE equipement (
    id_equipement    INT,
    nom_equipement   VARCHAR(100) NOT NULL,
    date_acquisition DATE NOT NULL,
    CONSTRAINT pk_equipement PRIMARY KEY (id_equipement)
);


CREATE TABLE patient (
    id_patient      INT,
    code_anonyme    VARCHAR(10) NOT NULL,
    type_cancer     VARCHAR(60) NOT NULL,
    annee_naissance SMALLINT    NOT NULL,
    CONSTRAINT pk_patient PRIMARY KEY (id_patient)
);


-- Entités avec clés étrangères 


CREATE TABLE equipe (
    id_equipe      INT,
    nom_equipe     VARCHAR(80) NOT NULL,
    id_laboratoire INT         NOT NULL,
    CONSTRAINT pk_equipe PRIMARY KEY (id_equipe),
    CONSTRAINT fk_equipe_laboratoire FOREIGN KEY (id_laboratoire)
        REFERENCES laboratoire (id_laboratoire)
);


CREATE TABLE chercheur (
    id_chercheur     INT,
    nom_chercheur    VARCHAR(50) NOT NULL,
    prenom_chercheur VARCHAR(50) NOT NULL,
    nom_metier       VARCHAR(30) NOT NULL,
    id_equipe        INT         NOT NULL,
    id_superieur     INT,
    CONSTRAINT pk_chercheur PRIMARY KEY (id_chercheur),
    CONSTRAINT fk_chercheur_equipe FOREIGN KEY (id_equipe)
        REFERENCES equipe (id_equipe),
    CONSTRAINT fk_chercheur_superieur FOREIGN KEY (id_superieur)
        REFERENCES chercheur (id_chercheur)
);


CREATE TABLE publication (
    id_publication   INT,
    titre            VARCHAR(250) NOT NULL,
    date_publication DATE         NOT NULL,
    id_projet        INT          NOT NULL,
    CONSTRAINT pk_publication PRIMARY KEY (id_publication),
    CONSTRAINT fk_publication_projet FOREIGN KEY (id_projet)
        REFERENCES projet (id_projet)
);

CREATE TABLE echantillon (
    num_echantillon        INT,
    id_patient             INT,
    type_echantillon       VARCHAR(50) NOT NULL,
    date_prelevement       DATE        NOT NULL,
    condition_conservation VARCHAR(50) NOT NULL,
    CONSTRAINT pk_echantillon PRIMARY KEY (num_echantillon, id_patient),
    CONSTRAINT fk_echantillon_patient FOREIGN KEY (id_patient)
        REFERENCES patient (id_patient)
);


CREATE TABLE essai (
    id_essai    INT,
    id_projet   INT,
    id_molecule INT,
    nom_essai   VARCHAR(150) NOT NULL,
    resultat    VARCHAR(200),
    CONSTRAINT pk_essai PRIMARY KEY (id_essai, id_projet, id_molecule),
    CONSTRAINT fk_essai_projet FOREIGN KEY (id_projet)
        REFERENCES projet (id_projet),
    CONSTRAINT fk_essai_molecule FOREIGN KEY (id_molecule)
        REFERENCES molecule (id_molecule)
);


-- Tables issues des associations de cardinalités (x,n) - (x,n)

CREATE TABLE etudier (
    id_chercheur INT,
    id_projet    INT,
    CONSTRAINT pk_etudier PRIMARY KEY (id_chercheur, id_projet),
    CONSTRAINT fk_etudier_chercheur FOREIGN KEY (id_chercheur)
        REFERENCES chercheur (id_chercheur),
    CONSTRAINT fk_etudier_projet FOREIGN KEY (id_projet)
        REFERENCES projet (id_projet)
);


CREATE TABLE finance (
    id_collaborateur INT,
    id_projet        INT,
    montant          DECIMAL(12,2) NOT NULL,
    date_financement DATE          NOT NULL,
    CONSTRAINT pk_finance PRIMARY KEY (id_collaborateur, id_projet),
    CONSTRAINT fk_finance_collaborateur FOREIGN KEY (id_collaborateur)
        REFERENCES collaborateur (id_collaborateur),
    CONSTRAINT fk_finance_projet FOREIGN KEY (id_projet)
        REFERENCES projet (id_projet)
);


CREATE TABLE participe (
    id_essai           INT,
    id_projet          INT,
    id_molecule        INT,
    id_patient         INT,
    date_participation DATE NOT NULL,
    CONSTRAINT pk_participe PRIMARY KEY (id_essai, id_projet, id_molecule, id_patient),
    CONSTRAINT fk_participe_essai FOREIGN KEY (id_essai, id_projet, id_molecule)
        REFERENCES essai (id_essai, id_projet, id_molecule),
    CONSTRAINT fk_participe_patient FOREIGN KEY (id_patient)
        REFERENCES patient (id_patient)
);


CREATE TABLE utiliser (
    id_essai      INT,
    id_projet     INT,
    id_molecule   INT,
    id_equipement INT,
    CONSTRAINT pk_utiliser PRIMARY KEY (id_essai, id_projet, id_molecule, id_equipement),
    CONSTRAINT fk_utiliser_essai FOREIGN KEY (id_essai, id_projet, id_molecule)
        REFERENCES essai (id_essai, id_projet, id_molecule),
    CONSTRAINT fk_utiliser_equipement FOREIGN KEY (id_equipement)
        REFERENCES equipement (id_equipement)
);
