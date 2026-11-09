
USE labo_immunotherapie;

START TRANSACTION;

-- ---------------------------------------------------------------------
-- Laboratoires (3) et équipes (6)
-- ---------------------------------------------------------------------
INSERT INTO laboratoire (id_laboratoire, nom_laboratoire) VALUES
(1001, 'Laboratoire d''Immunothérapie des Tumeurs Solides'),
(1002, 'Laboratoire de Thérapie Cellulaire et Génique'),
(1003, 'Laboratoire d''Immunologie Tumorale et Biomarqueurs');

INSERT INTO equipe (id_equipe, nom_equipe, id_laboratoire) VALUES
(2001, 'Équipe Anticorps Bloqueurs de Points de Contrôle', 1001),
(2002, 'Équipe Vaccins Anticancéreux', 1001),
(2003, 'Équipe CAR-T Hématologie', 1002),
(2004, 'Équipe Ingénierie Lymphocytaire', 1002),
(2005, 'Équipe Biomarqueurs Prédictifs', 1003),
(2006, 'Équipe Microenvironnement Tumoral', 1003);

-- ---------------------------------------------------------------------
-- Membres (20) : les responsables sont insérés avant leurs subordonnés
-- (3 membres au sommet de la hiérarchie, sans responsable)
-- ---------------------------------------------------------------------
INSERT INTO chercheur (id_chercheur, nom_chercheur, prenom_chercheur, nom_metier, id_equipe, id_superieur) VALUES
(100001, 'Lefèvre',   'Camille',  'chercheur',  2001, NULL),
(100002, 'Moreau',    'Antoine',  'chercheur',  2003, NULL),
(100003, 'Bernard',   'Sophie',   'chercheur',  2005, NULL),
(100004, 'Garnier',   'Julien',   'chercheur',  2001, 100001),
(100005, 'Roche',     'Élodie',   'chercheur',  2002, 100001),
(100006, 'Petit',     'Nicolas',  'technicien', 2001, 100004),
(100007, 'Marchand',  'Léa',      'doctorant',  2001, 100004),
(100008, 'Faure',     'Thomas',   'technicien', 2002, 100005),
(100009, 'Girard',    'Inès',     'doctorant',  2002, 100005),
(100010, 'Dubois',    'Hugo',     'chercheur',  2003, 100002),
(100011, 'Mercier',   'Clara',    'chercheur',  2004, 100002),
(100012, 'Blanc',     'Maxime',   'technicien', 2003, 100010),
(100013, 'Lambert',   'Yasmine',  'doctorant',  2003, 100010),
(100014, 'Fontaine',  'Paul',     'doctorant',  2004, 100011),
(100015, 'Chevalier', 'Manon',    'technicien', 2004, 100011),
(100016, 'Rousseau',  'Karim',    'chercheur',  2005, 100003),
(100017, 'Lopez',     'Anaïs',    'chercheur',  2006, 100003),
(100018, 'Vidal',     'Romain',   'technicien', 2005, 100016),
(100019, 'Colin',     'Salomé',   'doctorant',  2006, 100017),
(100020, 'Perrin',    'Adrien',   'doctorant',  2005, 100016);

-- ---------------------------------------------------------------------
-- Collaborateurs (6), projets (8), molécules (7), équipements (8)
-- ---------------------------------------------------------------------
INSERT INTO collaborateur (id_collaborateur, nom_collaborateur) VALUES
(40001, 'Hôpital Universitaire Saint-Aurélien'),
(40002, 'Centre Hospitalier Régional de Valmont'),
(40003, 'NovaCell Pharma'),
(40004, 'Orphéa Biotherapeutics'),
(40005, 'Institut de Recherche Alvéo'),
(40006, 'Pharmavis Oncologie');

INSERT INTO projet (id_projet, nom_projet, date_debut, date_fin) VALUES
(50001, 'Blocage combiné PD-1/LAG-3 dans le mélanome avancé',          '2022-01-10', '2026-12-31'),
(50002, 'Vaccin à ARNm de néoantigènes contre le cancer colorectal',   '2023-03-01', '2027-02-28'),
(50003, 'CAR-T anti-CD19 de nouvelle génération dans les lymphomes B', '2021-09-01', '2026-08-31'),
(50004, 'CAR-T anti-BCMA pour le myélome multiple en rechute',         '2024-01-15', '2028-01-14'),
(50005, 'Biomarqueurs prédictifs de réponse aux anticorps anti-PD-1',  '2022-06-01', '2026-05-31'),
(50006, 'Vaccin thérapeutique anti-HPV du cancer du col de l''utérus', '2023-09-01', '2027-08-31'),
(50007, 'Anticorps anti-CTLA-4 modifié dans le cancer du rein',        '2025-02-03', '2029-02-02'),
(50008, 'Microenvironnement tumoral et résistance à l''immunothérapie', '2024-10-01', '2027-09-30');

INSERT INTO molecule (id_molecule, nom_molecule, type_traitement) VALUES
(70001, 'AcM-PD1-207',   'anticorps thérapeutique'),
(70002, 'AcM-LAG3-044',  'anticorps thérapeutique'),
(70003, 'AcM-CTLA4-118', 'anticorps thérapeutique'),
(70004, 'VAX-NEO-12',    'vaccin anticancéreux'),
(70005, 'VAX-HPV-05',    'vaccin anticancéreux'),
(70006, 'CART-CD19-A3',  'thérapie cellulaire CAR-T'),
(70007, 'CART-BCMA-B1',  'thérapie cellulaire CAR-T');

INSERT INTO equipement (id_equipement, nom_equipement, date_acquisition) VALUES
(90001, 'Cytomètre en flux à 18 couleurs',                '2021-03-15'),
(90002, 'Séquenceur de nouvelle génération',              '2020-11-02'),
(90003, 'Microscope confocal',                            '2019-06-20'),
(90004, 'Automate de culture cellulaire',                 '2022-09-05'),
(90005, 'Congélateur à très basse température (-80 °C)', '2018-04-12'),
(90006, 'Spectromètre de masse',                          '2023-01-30'),
(90007, 'Incubateur à CO2',                               '2021-10-18'),
(90008, 'Trieur cellulaire',                              '2024-05-27');

-- ---------------------------------------------------------------------
-- Associations : étudier (membres <-> projets), finance (collaborateurs <-> projets)
-- Chaque projet a au moins un membre et au moins un financeur
-- ---------------------------------------------------------------------
INSERT INTO etudier (id_chercheur, id_projet) VALUES
(100001, 50001), (100004, 50001), (100007, 50001),
(100005, 50002), (100008, 50002), (100009, 50002),
(100002, 50003), (100010, 50003), (100012, 50003), (100013, 50003),
(100011, 50004), (100014, 50004), (100015, 50004),
(100003, 50005), (100016, 50005), (100018, 50005), (100020, 50005),
(100005, 50006), (100009, 50006),
(100001, 50007), (100004, 50007), (100006, 50007),
(100003, 50008), (100017, 50008), (100019, 50008);

INSERT INTO finance (id_collaborateur, id_projet, montant, date_financement) VALUES
(40001, 50001,  450000.00, '2022-01-20'),
(40003, 50001, 1200000.00, '2022-02-15'),
(40003, 50002,  900000.00, '2023-03-20'),
(40005, 50002,  350000.00, '2023-04-05'),
(40002, 50003,  280000.00, '2021-10-12'),
(40004, 50003, 1500000.00, '2021-11-03'),
(40004, 50004, 2100000.00, '2024-02-01'),
(40001, 50004,  600000.00, '2024-02-20'),
(40006, 50005,  520000.00, '2022-06-15'),
(40005, 50005,  180000.00, '2022-07-01'),
(40003, 50006,  750000.00, '2023-09-18'),
(40002, 50006,  220000.00, '2023-10-02'),
(40006, 50007,  980000.00, '2025-02-20'),
(40005, 50008,  410000.00, '2024-10-15'),
(40001, 50008,  300000.00, '2024-11-04');

-- ---------------------------------------------------------------------
-- Publications (9) : certains projets n'en ont aucune
-- ---------------------------------------------------------------------
INSERT INTO publication (id_publication, titre, date_publication, id_projet) VALUES
(600001, 'Efficacité du blocage combiné PD-1/LAG-3 sur la survie sans progression dans le mélanome métastatique', '2024-05-14', 50001),
(600002, 'Profil de tolérance de l''association anti-PD-1 et anti-LAG-3 : analyse intermédiaire',                 '2023-11-09', 50001),
(600003, 'Immunogénicité d''un vaccin à ARNm de néoantigènes chez la souris porteuse de tumeurs colorectales',    '2024-09-23', 50002),
(600004, 'CAR-T anti-CD19 de seconde génération : rémissions à 12 mois dans le lymphome B diffus',                '2025-03-18', 50003),
(600005, 'Persistance des lymphocytes CAR-T et syndrome de relargage cytokinique',                                '2023-06-27', 50003),
(600006, 'Signature transcriptomique prédictive de la réponse aux anti-PD-1',                                     '2024-02-08', 50005),
(600007, 'Lymphocytes infiltrants et réponse aux anti-PD-1 : une cohorte rétrospective',                          '2025-07-30', 50005),
(600008, 'Ciblage de BCMA par CAR-T : résultats précliniques dans le myélome multiple',                           '2024-12-04', 50004),
(600009, 'Rôle des fibroblastes associés au cancer dans la résistance à l''immunothérapie',                       '2026-03-17', 50008);

-- ---------------------------------------------------------------------
-- Essais cliniques (11) : numérotés à l'intérieur de chaque projet ;
-- résultat NULL = essai en cours
-- ---------------------------------------------------------------------
INSERT INTO essai (id_essai, id_projet, id_molecule, nom_essai, resultat) VALUES
(1, 50001, 70001, 'Phase I : escalade de dose de AcM-PD1-207 en monothérapie',                    'Dose recommandée de 3 mg/kg ; bonne tolérance chez les 3 patients'),
(2, 50001, 70002, 'Phase II : AcM-LAG3-044 dans le mélanome avancé en deuxième ligne',            'Réponse partielle chez 2 patients sur 3'),
(3, 50001, 70002, 'Phase III : AcM-LAG3-044 versus traitement standard dans le mélanome',         NULL),
(1, 50002, 70004, 'Phase I : VAX-NEO-12 dans le cancer colorectal métastatique',                  'Réponse immunitaire spécifique détectée chez les 2 patients ; aucun effet indésirable grave'),
(1, 50003, 70006, 'Phase I : CART-CD19-A3 dans le lymphome B diffus en rechute',                  'Rémission complète chez 2 patients sur 3'),
(2, 50003, 70006, 'Phase II : CART-CD19-A3 en deuxième ligne',                                    NULL),
(1, 50004, 70007, 'Phase I : CART-BCMA-B1 dans le myélome multiple en rechute',                   NULL),
(1, 50005, 70001, 'Phase II : AcM-PD1-207 dans le cancer du poumon non à petites cellules',       'Signature de 12 gènes associée à la réponse au traitement'),
(1, 50006, 70005, 'Phase I/II : VAX-HPV-05 dans le cancer du col de l''utérus',                   NULL),
(1, 50007, 70003, 'Phase I : AcM-CTLA4-118 dans le cancer du rein avancé',                        NULL),
(1, 50008, 70001, 'Phase II exploratoire : AcM-PD1-207 et microenvironnement tumoral',            NULL);

-- ---------------------------------------------------------------------
-- Patients (16, anonymisés)
-- ---------------------------------------------------------------------
INSERT INTO patient (id_patient, code_anonyme, type_cancer, annee_naissance) VALUES
(800001, 'P-000001', 'mélanome',                              1958),
(800002, 'P-000002', 'mélanome',                              1971),
(800003, 'P-000003', 'mélanome',                              1964),
(800004, 'P-000004', 'cancer du poumon non à petites cellules', 1955),
(800005, 'P-000005', 'cancer du poumon non à petites cellules', 1962),
(800006, 'P-000006', 'cancer colorectal',                     1969),
(800007, 'P-000007', 'cancer colorectal',                     1977),
(800008, 'P-000008', 'lymphome B diffus à grandes cellules',  1980),
(800009, 'P-000009', 'lymphome B diffus à grandes cellules',  1973),
(800010, 'P-000010', 'lymphome B diffus à grandes cellules',  1966),
(800011, 'P-000011', 'myélome multiple',                      1959),
(800012, 'P-000012', 'myélome multiple',                      1954),
(800013, 'P-000013', 'cancer du col de l''utérus',            1985),
(800014, 'P-000014', 'cancer du col de l''utérus',            1990),
(800015, 'P-000015', 'cancer du rein',                        1961),
(800016, 'P-000016', 'mélanome',                              1975);

-- ---------------------------------------------------------------------
-- participe : patients <-> essais (avec la date de participation)
-- ---------------------------------------------------------------------
INSERT INTO participe (id_essai, id_projet, id_molecule, id_patient, date_participation) VALUES
(1, 50001, 70001, 800001, '2022-09-12'),
(1, 50001, 70001, 800002, '2022-10-03'),
(1, 50001, 70001, 800003, '2022-11-21'),
(2, 50001, 70002, 800002, '2023-06-14'),
(2, 50001, 70002, 800003, '2023-07-05'),
(2, 50001, 70002, 800016, '2023-08-22'),
(3, 50001, 70002, 800001, '2025-09-10'),
(3, 50001, 70002, 800016, '2025-10-01'),
(1, 50002, 70004, 800006, '2024-01-15'),
(1, 50002, 70004, 800007, '2024-02-12'),
(1, 50003, 70006, 800008, '2022-03-08'),
(1, 50003, 70006, 800009, '2022-04-19'),
(1, 50003, 70006, 800010, '2022-05-30'),
(2, 50003, 70006, 800009, '2024-10-07'),
(2, 50003, 70006, 800010, '2024-09-16'),
(1, 50004, 70007, 800011, '2024-06-04'),
(1, 50004, 70007, 800012, '2024-07-23'),
(1, 50005, 70001, 800004, '2022-11-08'),
(1, 50005, 70001, 800005, '2022-12-13'),
(1, 50006, 70005, 800013, '2023-12-05'),
(1, 50006, 70005, 800014, '2024-01-30'),
(1, 50007, 70003, 800015, '2025-05-19'),
(1, 50008, 70001, 800001, '2024-11-12'),
(1, 50008, 70001, 800003, '2024-12-03');

-- ---------------------------------------------------------------------
-- utiliser : essais <-> équipements
-- ---------------------------------------------------------------------
INSERT INTO utiliser (id_essai, id_projet, id_molecule, id_equipement) VALUES
(1, 50001, 70001, 90001), (1, 50001, 70001, 90005),
(2, 50001, 70002, 90001), (2, 50001, 70002, 90002),
(3, 50001, 70002, 90001), (3, 50001, 70002, 90006),
(1, 50002, 70004, 90002), (1, 50002, 70004, 90004),
(1, 50003, 70006, 90004), (1, 50003, 70006, 90007), (1, 50003, 70006, 90008),
(2, 50003, 70006, 90004), (2, 50003, 70006, 90008),
(1, 50004, 70007, 90004), (1, 50004, 70007, 90008), (1, 50004, 70007, 90005),
(1, 50005, 70001, 90002), (1, 50005, 70001, 90006),
(1, 50006, 70005, 90003), (1, 50006, 70005, 90001),
(1, 50007, 70003, 90001),
(1, 50008, 70001, 90003), (1, 50008, 70001, 90002);

-- ---------------------------------------------------------------------
-- Échantillons (23) : numérotés à l'intérieur des prélèvements de chaque patient
-- ---------------------------------------------------------------------
INSERT INTO echantillon (num_echantillon, id_patient, type_echantillon, date_prelevement, condition_conservation) VALUES
(1, 800001, 'sang',           '2022-09-12', '-80 °C'),
(2, 800001, 'tissu tumoral',  '2022-09-12', 'azote liquide (-196 °C)'),
(3, 800001, 'plasma',         '2025-09-10', '-80 °C'),
(1, 800002, 'sang',           '2022-10-03', '-80 °C'),
(2, 800002, 'plasma',         '2023-06-14', '-80 °C'),
(1, 800003, 'tissu tumoral',  '2022-11-21', 'azote liquide (-196 °C)'),
(1, 800004, 'sang',           '2022-11-08', '+4 °C'),
(2, 800004, 'tissu tumoral',  '2022-11-08', 'azote liquide (-196 °C)'),
(1, 800005, 'plasma',         '2022-12-13', '-80 °C'),
(1, 800006, 'tissu tumoral',  '2024-01-15', 'azote liquide (-196 °C)'),
(2, 800006, 'sang',           '2024-02-26', '-80 °C'),
(1, 800007, 'sang',           '2024-02-12', '-80 °C'),
(1, 800008, 'sang',           '2022-03-08', '-80 °C'),
(2, 800008, 'moelle osseuse', '2022-06-21', 'azote liquide (-196 °C)'),
(1, 800009, 'sang',           '2022-04-19', '-80 °C'),
(1, 800010, 'sang',           '2022-05-30', '-80 °C'),
(2, 800010, 'plasma',         '2024-09-16', '-80 °C'),
(1, 800011, 'moelle osseuse', '2024-06-04', 'azote liquide (-196 °C)'),
(2, 800011, 'sang',           '2024-06-18', '+4 °C'),
(1, 800012, 'plasma',         '2024-07-23', '-80 °C'),
(1, 800013, 'tissu tumoral',  '2023-12-05', 'azote liquide (-196 °C)'),
(1, 800014, 'sang',           '2024-01-30', '-80 °C'),
(1, 800016, 'sang',           '2023-08-22', '-80 °C');

COMMIT;

-- =====================================================================
-- Vérifications (à lancer après l'insertion)
-- =====================================================================

-- Nombre de lignes par table
SELECT 'laboratoire' AS table_nom, COUNT(*) AS nb_lignes FROM laboratoire
UNION ALL SELECT 'equipe', COUNT(*) FROM equipe
UNION ALL SELECT 'chercheur', COUNT(*) FROM chercheur
UNION ALL SELECT 'collaborateur', COUNT(*) FROM collaborateur
UNION ALL SELECT 'projet', COUNT(*) FROM projet
UNION ALL SELECT 'publication', COUNT(*) FROM publication
UNION ALL SELECT 'molecule', COUNT(*) FROM molecule
UNION ALL SELECT 'essai', COUNT(*) FROM essai
UNION ALL SELECT 'patient', COUNT(*) FROM patient
UNION ALL SELECT 'equipement', COUNT(*) FROM equipement
UNION ALL SELECT 'echantillon', COUNT(*) FROM echantillon
UNION ALL SELECT 'etudier', COUNT(*) FROM etudier
UNION ALL SELECT 'finance', COUNT(*) FROM finance
UNION ALL SELECT 'participe', COUNT(*) FROM participe
UNION ALL SELECT 'utiliser', COUNT(*) FROM utiliser;

-- Cardinalités minimales 1,n que le DDL ne peut pas imposer : chaque requête doit renvoyer 0 ligne
-- Projets sans aucun membre
SELECT p.id_projet FROM projet p
WHERE NOT EXISTS (SELECT 1 FROM etudier e WHERE e.id_projet = p.id_projet);

-- Projets sans aucun financeur
SELECT p.id_projet FROM projet p
WHERE NOT EXISTS (SELECT 1 FROM finance f WHERE f.id_projet = p.id_projet);

-- Laboratoires sans équipe
SELECT l.id_laboratoire FROM laboratoire l
WHERE NOT EXISTS (SELECT 1 FROM equipe e WHERE e.id_laboratoire = l.id_laboratoire);

-- Équipes de moins de 2 membres (« une équipe compte plusieurs membres »)
SELECT e.id_equipe FROM equipe e
LEFT JOIN chercheur c ON c.id_equipe = e.id_equipe
GROUP BY e.id_equipe HAVING COUNT(c.id_chercheur) < 2;
