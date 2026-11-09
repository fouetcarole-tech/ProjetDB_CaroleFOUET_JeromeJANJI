
USE labo_immunotherapie;


-- 1. Taille des identifiants

ALTER TABLE laboratoire   ADD CONSTRAINT ck_laboratoire_id   CHECK (id_laboratoire   BETWEEN 1 AND 9999);
ALTER TABLE equipe        ADD CONSTRAINT ck_equipe_id        CHECK (id_equipe        BETWEEN 1 AND 9999);
ALTER TABLE chercheur     ADD CONSTRAINT ck_chercheur_id     CHECK (id_chercheur     BETWEEN 1 AND 999999);
ALTER TABLE collaborateur ADD CONSTRAINT ck_collaborateur_id CHECK (id_collaborateur BETWEEN 1 AND 99999);
ALTER TABLE projet        ADD CONSTRAINT ck_projet_id        CHECK (id_projet        BETWEEN 1 AND 99999);
ALTER TABLE publication   ADD CONSTRAINT ck_publication_id   CHECK (id_publication   BETWEEN 1 AND 999999);
ALTER TABLE molecule      ADD CONSTRAINT ck_molecule_id      CHECK (id_molecule      BETWEEN 1 AND 99999);
ALTER TABLE essai         ADD CONSTRAINT ck_essai_id         CHECK (id_essai         BETWEEN 1 AND 999999);
ALTER TABLE patient       ADD CONSTRAINT ck_patient_id       CHECK (id_patient       BETWEEN 1 AND 999999);
ALTER TABLE equipement    ADD CONSTRAINT ck_equipement_id    CHECK (id_equipement    BETWEEN 1 AND 99999);
ALTER TABLE echantillon   ADD CONSTRAINT ck_echantillon_num  CHECK (num_echantillon  BETWEEN 1 AND 999999);


-- 2. Membres du laboratoire

-- Les membres sont des chercheurs, des techniciens ou des doctorants 
ALTER TABLE chercheur ADD CONSTRAINT ck_chercheur_metier
    CHECK (nom_metier IN ('chercheur', 'technicien', 'doctorant'));

-- Un membre a au plus un responsable direct  (déjà garanti par la colonne id_superieur)
-- Un membre ne peut pas être son propre responsable
ALTER TABLE chercheur ADD CONSTRAINT ck_chercheur_superieur
    CHECK (id_superieur IS NULL OR id_superieur <> id_chercheur);

-- ---------------------------------------------------------------------
-- 3. Projets et financements
-- ---------------------------------------------------------------------
ALTER TABLE projet ADD CONSTRAINT ck_projet_dates CHECK (date_fin >= date_debut);
ALTER TABLE finance ADD CONSTRAINT ck_finance_montant CHECK (montant > 0);


-- 4. Molécules et essais

-- un type : anticorps thérapeutique, vaccin anticancéreux ou thérapie cellulaire de type CAR-T 
ALTER TABLE molecule ADD CONSTRAINT ck_molecule_type
    CHECK (type_traitement IN ('anticorps thérapeutique', 'vaccin anticancéreux', 'thérapie cellulaire CAR-T'));

-- Les essais sont numérotés à l'intérieur de chaque projet  :
-- deux essais d'un même projet ne peuvent pas avoir le même numéro,
-- même s'ils portent sur des molécules différentes
ALTER TABLE essai ADD CONSTRAINT uq_essai_numero_projet UNIQUE (id_projet, id_essai);


-- 5. Patients

--  Chaque patient est désigné par un code anonyme unique 
ALTER TABLE patient ADD CONSTRAINT uq_patient_code UNIQUE (code_anonyme);

-- Le code anonyme commence par P, suivie d'un tiret et d'un numéro (ex. P-000042)
ALTER TABLE patient ADD CONSTRAINT ck_patient_code
    CHECK (code_anonyme REGEXP '^P-[0-9]{6}$');

ALTER TABLE patient ADD CONSTRAINT ck_patient_naissance
    CHECK (annee_naissance BETWEEN 1900 AND 2026);


-- 6. Dates qui ne peuvent pas être postérieures à la date du jour

DELIMITER //

CREATE TRIGGER trg_echantillon_bi BEFORE INSERT ON echantillon
FOR EACH ROW
BEGIN
    IF NEW.date_prelevement > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La date de prélèvement ne peut pas être postérieure à la date du jour';
    END IF;
END//

CREATE TRIGGER trg_echantillon_bu BEFORE UPDATE ON echantillon
FOR EACH ROW
BEGIN
    IF NEW.date_prelevement > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La date de prélèvement ne peut pas être postérieure à la date du jour';
    END IF;
END//

CREATE TRIGGER trg_participe_bi BEFORE INSERT ON participe
FOR EACH ROW
BEGIN
    IF NEW.date_participation > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La date de participation ne peut pas être postérieure à la date du jour';
    END IF;
END//

CREATE TRIGGER trg_participe_bu BEFORE UPDATE ON participe
FOR EACH ROW
BEGIN
    IF NEW.date_participation > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La date de participation ne peut pas être postérieure à la date du jour';
    END IF;
END//

DELIMITER ;


