
-- SCÉNARIO
-- Lundi 9 novembre 2026. Camille Lefèvre, responsable scientifique, prépare le
-- comité de suivi annuel du laboratoire. Elle interroge la base pour dresser le
-- bilan (équipes, financements, publications, essais, patients, équipements).
-- Dans la semaine, l'ingénieur de données saisit un nouveau patient inclus dans
-- un essai, corrige une erreur de saisie, enregistre un résultat d'essai et
-- met à jour un financement. Enfin, il vérifie que les contraintes protègent
-- bien la base contre les saisies invalides.

USE labo_immunotherapie;


-- PARTIE A : consultation (SELECT)


-- A1. Annuaire : chaque membre avec son équipe et son laboratoire 
SELECT l.nom_laboratoire, e.nom_equipe, c.nom_chercheur, c.prenom_chercheur, c.nom_metier
FROM chercheur c
JOIN equipe e      ON e.id_equipe = c.id_equipe
JOIN laboratoire l ON l.id_laboratoire = e.id_laboratoire
ORDER BY l.nom_laboratoire, e.nom_equipe, c.nom_chercheur;

-- A2. Effectif de chaque équipe et nombre de doctorants 
SELECT l.nom_laboratoire, e.nom_equipe,
       COUNT(*) AS nb_membres,
       SUM(CASE WHEN c.nom_metier = 'doctorant' THEN 1 ELSE 0 END) AS nb_doctorants
FROM equipe e
JOIN laboratoire l ON l.id_laboratoire = e.id_laboratoire
JOIN chercheur c   ON c.id_equipe = e.id_equipe
GROUP BY l.nom_laboratoire, e.id_equipe, e.nom_equipe
ORDER BY nb_membres DESC, e.nom_equipe;

-- A3. Organigramme : chaque membre et son responsable direct 

SELECT c.id_chercheur,
       CONCAT(c.prenom_chercheur, ' ', c.nom_chercheur) AS membre,
       c.nom_metier,
       CONCAT(s.prenom_chercheur, ' ', s.nom_chercheur) AS responsable_direct
FROM chercheur c
LEFT JOIN chercheur s ON s.id_chercheur = c.id_superieur
ORDER BY c.id_chercheur;

-- A4. Toutes les personnes placées sous la responsabilité de Camille Lefèvre

WITH RECURSIVE sous_hierarchie (id_chercheur, nom_chercheur, prenom_chercheur, nom_metier, niveau) AS (
    SELECT id_chercheur, nom_chercheur, prenom_chercheur, nom_metier, 0
    FROM chercheur
    WHERE id_chercheur = 100001
    UNION ALL
    SELECT c.id_chercheur, c.nom_chercheur, c.prenom_chercheur, c.nom_metier, h.niveau + 1
    FROM chercheur c
    JOIN sous_hierarchie h ON c.id_superieur = h.id_chercheur
)
SELECT niveau, prenom_chercheur, nom_chercheur, nom_metier
FROM sous_hierarchie
WHERE niveau > 0
ORDER BY niveau, nom_chercheur;

-- A5. Financement total par projet, pour les projets financés à plus d'1 M€ 
SELECT p.id_projet, p.nom_projet,
       COUNT(f.id_collaborateur) AS nb_financeurs,
       SUM(f.montant) AS total_euros
FROM projet p
JOIN finance f ON f.id_projet = p.id_projet
GROUP BY p.id_projet, p.nom_projet
HAVING SUM(f.montant) > 1000000
ORDER BY total_euros DESC;

-- A6. Projets dont le financement total dépasse la moyenne des projets (sous-requête)
SELECT p.nom_projet, SUM(f.montant) AS total_euros
FROM projet p
JOIN finance f ON f.id_projet = p.id_projet
GROUP BY p.id_projet, p.nom_projet
HAVING SUM(f.montant) > (
    SELECT AVG(total_projet)
    FROM (SELECT SUM(montant) AS total_projet FROM finance GROUP BY id_projet) t
)
ORDER BY total_euros DESC;

-- A7. Publications avec leur projet, dates au format JJ/MM/AAAA
SELECT p.nom_projet, pu.titre, DATE_FORMAT(pu.date_publication, '%d/%m/%Y') AS date_publication
FROM publication pu
JOIN projet p ON p.id_projet = pu.id_projet
ORDER BY pu.date_publication DESC;

-- A8. Projets sans aucune publication 
SELECT p.id_projet, p.nom_projet
FROM projet p
LEFT JOIN publication pu ON pu.id_projet = p.id_projet
WHERE pu.id_publication IS NULL;

-- A9. Essais en cours (résultat pas encore connu) avec leur projet et leur molécule
SELECT p.nom_projet, e.id_essai AS numero_essai, e.nom_essai, m.nom_molecule, m.type_traitement
FROM essai e
JOIN projet p   ON p.id_projet = e.id_projet
JOIN molecule m ON m.id_molecule = e.id_molecule
WHERE e.resultat IS NULL
ORDER BY p.nom_projet, e.id_essai;

-- A10. Essais accueillant au moins 3 patients (jointure sur la clé composite de l'essai)
SELECT p.nom_projet, e.id_essai AS numero_essai, e.nom_essai, COUNT(pa.id_patient) AS nb_patients
FROM essai e
JOIN projet p    ON p.id_projet = e.id_projet
JOIN participe pa ON pa.id_essai = e.id_essai
                 AND pa.id_projet = e.id_projet
                 AND pa.id_molecule = e.id_molecule
GROUP BY p.nom_projet, e.id_projet, e.id_essai, e.nom_essai
HAVING COUNT(pa.id_patient) >= 3
ORDER BY nb_patients DESC, p.nom_projet;

-- A11. Patients ayant participé à plus d'un essai
SELECT pt.code_anonyme, pt.type_cancer, COUNT(*) AS nb_essais
FROM patient pt
JOIN participe pa ON pa.id_patient = pt.id_patient
GROUP BY pt.id_patient, pt.code_anonyme, pt.type_cancer
HAVING COUNT(*) > 1
ORDER BY nb_essais DESC, pt.code_anonyme;

-- A12. Nombre d'échantillons par type et par condition de conservation
SELECT type_echantillon, condition_conservation, COUNT(*) AS nb_echantillons
FROM echantillon
GROUP BY type_echantillon, condition_conservation
ORDER BY type_echantillon, nb_echantillons DESC;

-- A13. Patients sans aucun échantillon (NOT EXISTS)
SELECT pt.code_anonyme, pt.type_cancer
FROM patient pt
WHERE NOT EXISTS (SELECT 1 FROM echantillon ech WHERE ech.id_patient = pt.id_patient);

-- A14. Équipements utilisés dans au moins 4 essais, avec leur date d'acquisition
SELECT eq.nom_equipement,
       DATE_FORMAT(eq.date_acquisition, '%d/%m/%Y') AS date_acquisition,
       COUNT(*) AS nb_essais
FROM equipement eq
JOIN utiliser u ON u.id_equipement = eq.id_equipement
GROUP BY eq.id_equipement, eq.nom_equipement, eq.date_acquisition
HAVING COUNT(*) >= 4
ORDER BY nb_essais DESC;

-- A15. Molécules testées dans plusieurs projets
SELECT m.nom_molecule, m.type_traitement,
       COUNT(DISTINCT e.id_projet) AS nb_projets,
       COUNT(*) AS nb_essais
FROM molecule m
JOIN essai e ON e.id_molecule = m.id_molecule
GROUP BY m.id_molecule, m.nom_molecule, m.type_traitement
HAVING COUNT(DISTINCT e.id_projet) > 1;

-- A16. Âge moyen des patients par type de cancer (en 2026)
SELECT type_cancer, COUNT(*) AS nb_patients,
       ROUND(AVG(YEAR(CURDATE()) - annee_naissance), 1) AS age_moyen
FROM patient
GROUP BY type_cancer
ORDER BY age_moyen DESC;

-- =====================================================================
-- PARTIE B : mise à jour des données (INSERT, UPDATE, DELETE)
-- =====================================================================
START TRANSACTION;

-- B1. Un nouveau patient est inclus dans l'essai n°1 du projet 50007 (AcM-CTLA4-118)
INSERT INTO patient (id_patient, code_anonyme, type_cancer, annee_naissance)
VALUES (800017, 'P-000017', 'cancer du rein', 1968);

INSERT INTO participe (id_essai, id_projet, id_molecule, id_patient, date_participation)
VALUES (1, 50007, 70003, 800017, '2026-11-02');

-- B2. Deux prélèvements sont saisis le même jour (le second est un doublon par erreur)
INSERT INTO echantillon (num_echantillon, id_patient, type_echantillon, date_prelevement, condition_conservation)
VALUES (1, 800017, 'sang', '2026-11-02', '-80 °C'),
       (2, 800017, 'sang', '2026-11-02', '-80 °C');

-- B3. Correction de l'erreur de saisie : suppression du doublon
DELETE FROM echantillon
WHERE id_patient = 800017 AND num_echantillon = 2;

-- B4. L'essai n°2 du projet 50003 est terminé : on enregistre son résultat
UPDATE essai
SET resultat = 'Rémission complète chez 1 patient sur 2 à 12 mois'
WHERE id_essai = 2 AND id_projet = 50003 AND id_molecule = 70006;

-- B5. Orphéa Biotherapeutics augmente de 10 % son financement du projet 50004
UPDATE finance
SET montant = ROUND(montant * 1.10, 2)
WHERE id_collaborateur = 40004 AND id_projet = 50004;

COMMIT;

-- Vérification des modifications
SELECT pt.code_anonyme, ech.num_echantillon, ech.type_echantillon
FROM patient pt
JOIN echantillon ech ON ech.id_patient = pt.id_patient
WHERE pt.id_patient = 800017;

SELECT nom_essai, resultat FROM essai WHERE id_projet = 50003 AND id_essai = 2;

SELECT id_collaborateur, id_projet, montant FROM finance
WHERE id_collaborateur = 40004 AND id_projet = 50004;


-- PARTIE C : tests des contraintes (chaque requête doit être REFUSÉE)

-- C1. Date de participation dans le futur -> refusée par le trigger trg_participe_bi
-- INSERT INTO participe VALUES (1, 50007, 70003, 800001, '2030-01-01');

-- C2. Date de prélèvement dans le futur -> refusée par le trigger trg_echantillon_bi
-- INSERT INTO echantillon VALUES (3, 800017, 'plasma', '2030-01-01', '-80 °C');

-- C3. Code anonyme au mauvais format -> refusé par ck_patient_code
-- INSERT INTO patient VALUES (800018, 'X-12', 'mélanome', 1970);

-- C4. Code anonyme déjà attribué -> refusé par uq_patient_code
-- INSERT INTO patient VALUES (800018, 'P-000001', 'mélanome', 1970);

-- C5. Métier inconnu -> refusé par ck_chercheur_metier
-- INSERT INTO chercheur VALUES (100021, 'Martin', 'Louis', 'stagiaire', 2001, NULL);

-- C6. Deux essais avec le même numéro dans un même projet -> refusé par uq_essai_numero_projet
-- INSERT INTO essai VALUES (1, 50001, 70002, 'Essai en double', NULL);

-- C7. Type de traitement hors liste -> refusé par ck_molecule_type
-- INSERT INTO molecule VALUES (70008, 'XYZ-001', 'radiothérapie');

-- C8. Suppression d'un patient encore référencé par des participations -> refusée (clé étrangère)
-- DELETE FROM patient WHERE id_patient = 800001;
