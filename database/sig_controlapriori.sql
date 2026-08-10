-- =============================================
-- Fichier: sig_controlapriori_postgres.sql
-- Description: Conversion de la base MySQL vers PostgreSQL.
-- Auteur: Assistant IA
-- Date: 2026-08-06
-- =============================================

-- --------------------------------------------------------
-- Désactiver les vérifications des contraintes pour l'import
-- (Équivalent de SET FOREIGN_KEY_CHECKS=0; en PostgreSQL)
-- --------------------------------------------------------
SET session_replication_role = 'replica';

-- --------------------------------------------------------
-- Base de données : sig_controlapriori
-- --------------------------------------------------------
-- (Optionnel: Création de la base et connexion)
-- CREATE DATABASE sig_controlapriori;
-- \c sig_controlapriori;

-- --------------------------------------------------------
-- Table: acte_adm_epn
-- --------------------------------------------------------
DROP TABLE IF EXISTS "acte_adm_epn";

CREATE TABLE "acte_adm_epn" (
  "id_epn" SERIAL PRIMARY KEY,
  "ref_epn" VARCHAR(50) NOT NULL,
  "objet_epn" VARCHAR(50) NOT NULL,
  "type_epn" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "acte_adm_epn" IS 'Structure de la table acte_adm_epn';

INSERT INTO "acte_adm_epn" ("id_epn", "ref_epn", "objet_epn", "type_epn") VALUES
(1, 'Epn100', 'Riz', 'Deliberation'),
(2, 'Epn200', 'Sucre', 'CA'),
(3, 'Epn300', 'Carton sigara', 'Deliberation');

-- --------------------------------------------------------
-- Table: acte_adm_pers
-- --------------------------------------------------------
DROP TABLE IF EXISTS "acte_adm_pers";

CREATE TABLE "acte_adm_pers" (
  "id_pers" SERIAL PRIMARY KEY,
  "ref_pers" VARCHAR(50) NOT NULL,
  "objet_pers" VARCHAR(50) NOT NULL,
  "type_pers" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "acte_adm_pers" IS 'Structure de la table acte_adm_pers';

INSERT INTO "acte_adm_pers" ("id_pers", "ref_pers", "objet_pers", "type_pers") VALUES
(2, 'Pers002', 'Arrete', 'Avancement'),
(3, 'Pers300', 'Decision', 'Nomination'),
(4, 'Ref500', 'Arrete', 'Avancement');

-- --------------------------------------------------------
-- Table: admin
-- --------------------------------------------------------
DROP TABLE IF EXISTS "admin";

CREATE TABLE "admin" (
  "id_admin" SERIAL PRIMARY KEY,
  "nom" VARCHAR(60) NOT NULL,
  "prenoms" VARCHAR(60) NOT NULL,
  "im" VARCHAR(20) NOT NULL,
  "role" VARCHAR(15) NOT NULL,
  "login" VARCHAR(60) NOT NULL,
  "admin_pass" VARCHAR(50) NOT NULL,
  "etat" VARCHAR(10) NOT NULL,
  "exercice" INTEGER NOT NULL
);

COMMENT ON TABLE "admin" IS 'Structure de la table admin';

INSERT INTO "admin" ("id_admin", "nom", "prenoms", "im", "role", "login", "admin_pass", "etat", "exercice") VALUES
(1, 'Rakotomanga   ', 'Erick', '293122', 'admin', '293122', '293122', 'actif  ', 2023),
(3, 'RAKOTOMANGA ', 'Erick', '293122', 'responsable', '293122', '293122', 'actif', 2023),
(4, 'RAKOTOMANGA', 'Andriniaina', '313749', 'admin', '313749', '313749', 'actif', 2023);

-- --------------------------------------------------------
-- Table: delegation
-- --------------------------------------------------------
DROP TABLE IF EXISTS "delegation";

CREATE TABLE "delegation" (
  "id_delegation" SERIAL PRIMARY KEY,
  "cf_code" VARCHAR(30) NOT NULL,
  "lib_delegation" VARCHAR(100) NOT NULL,
  "abrev" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "delegation" IS 'Structure de la table delegation';

INSERT INTO "delegation" ("id_delegation", "cf_code", "lib_delegation", "abrev") VALUES
(1, '10101.110 ', 'CONTROLE FINANCIER/ AFFAIRES ETRANGERES', ''),
(2, '10101.360', 'CONTROLE FINANCIER COMMERCE', ''),
(3, '10101.510', 'CONTROLE FINANCIER ENERGIE', ''),
(4, '10101.440', 'CONTROLE FINANCIER ENVIRONNEMENT', ''),
(5, '10101.310', 'CONTROLE FINANCIER TRAVAIL ET LOIS SOCIALES', ''),
(6, '10101.370', 'CONTROLE FINANCIER COMMUNICATION', ''),
(7, '10101.520', 'CONTROLE FINANCIER EAU ET ASSAINISSEMENT', ''),
(8, '10101.480', 'CONTROLE FINANCIER AGRICULTURE ET ELEVAGE', ''),
(9, '10101.122', 'CONTROLE FINANCIER DEFENSE ET SECURITE', ''),
(10, '10101.762', 'CONTROLE FINANCIER DEVELOPPEMENT SOCIAL', ''),
(11, '10101.340', 'CONTROLE FINANCIER INDUSTRIE', ''),
(12, '10101.330', 'CONTROLE FINANCIER EMPLOI', ''),
(13, '10101.920', 'CONTROLE FINANCIER DROIT DE L''HOMME', ''),
(14, '10101.142', 'CONTROLE FINANCIER ADMINISTRATION DU TERRITOIRE ET DECENTRALISATION', ''),
(15, '10101.670', 'CONTROLE FINANCIER TIC', ''),
(16, '10101.840', 'CONTROLE FINANCIER ENSEIGNEMENT SUPERIEUR', ''),
(17, '10101.010', 'CONTROLE FINANCIER PRESIDENCE DE LA REPUBLIQUE', ''),
(18, '10101.862', 'CONTROLE FINANCIER CULTURE ET ARTISANAT', ''),
(19, '10101.910', 'CONTROLE FINANCIER DEMOCRATIE ET BONNE GOUVERNANCE', ''),
(20, '10101.012', 'CONTROLE FINANCIER MEEFT', ''),
(21, '10101.040', 'CONTROLE FINANCIER HAUTE COUR CONSTITUTIONNELLE', ''),
(22, '10101.540', 'CONTROLE FINANCIER HYDROCARBURES', ''),
(23, '10101.780', 'CONTROLE FINANCIER SPORTS', ''),
(24, '10101.460', 'CONTROLE FINANCIER DOMAINE ET SECURISATION FONCIERE', ''),
(25, '10101.620', 'CONTROLE FINANCIER AMENAGEMENT DU TERRITOIRE', ''),
(26, '10101.220', 'CONTROLE FINANCIER FINANCES ET BUDGET', ''),
(27, '10101.130', 'CONTROLE FINANCIER GENDARMERIE NATIONALE', ''),
(28, '10101.080', 'CONTROLE FINANCIER COOPERATION ET DEVELOPPEMENT', ''),
(29, '10101.290', 'CONTROLE FINANCIER PILOTAGE DE L''ECONOMIE', ''),
(30, '10101.830', 'CONTROLE FINANCIER ENSEIGNEMENT TECHNIQUE ET FORMATION PROFESSIONNELLE', ''),
(31, '10101.710', 'CONTROLE FINANCIER SANTE', ''),
(32, '10101.680', 'CONTROLE FINANCIER METEOROLOGIE', ''),
(33, '10101.430', 'CONTROLE FINANCIER PECHE', ''),
(34, '10101.013', 'DEL CF MEM', ''),
(35, '10101.660', 'CONTROLE FINANCIER POSTE ET TELECOMMUNICATION', ''),
(36, '10101.850', 'CONTROLE FINANCIER RECHERCHE SCIENTIFIQUE', ''),
(37, '10101.020', 'CONTROLE FINANCIER SENAT', ''),
(38, '10101.610', 'CONTROLE FINANCIER TRAVAUX PUBLICS', ''),
(39, '10101.530', 'CONTROLE FINANCIER MINES', ''),
(40, '10101.812', 'CONTROLE FINANCIER EDUCATION', ''),
(41, '10101.004', 'DEL CF MDN', ''),
(42, '10101.640', 'CONTROLE FINANCIER GRANDS TRAVAUX D''INFRASTRUCTURES ET EQUIPEMENTS', ''),
(43, '10101.630', 'CONTROLE FINANCIER TRANSPORT', ''),
(44, '10101.060', 'CONTROLE FINANCIER RECONCILIATION MALAGASY', ''),
(45, '10101.160', 'CONTROLE FINANCIER JUSTICE', ''),
(46, '10101.150', 'CONTROLE FINANCIER SECURITE PUBLIQUE', ''),
(47, '10101.050', 'CONTROLE FINANCIER PRIMATURE', 'PRIMATURE'),
(48, '10101.123', 'CONTROLE FINANCIER ARMEE MALAGASY', ''),
(49, '10101.750', 'CONTROLE FINANCIER JEUNESSE', ''),
(50, '10101.350', 'CONTROLE FINANCIER TOURISME', ''),
(51, '10101.320', 'CONTROLE FINANCIER FONCTION PUBLIQUE', ''),
(52, '10101.002', 'DEL CF MPRDAT', ''),
(53, '10101.930', 'CONTROLE FINANCIER HAUTE COUR DE JUSTICE', ''),
(54, '10101.470', 'CONTROLE FINANCIER MER', ''),
(55, '10101.030', 'CONTROLE FINANCIER ASSEMBLEE NATIONALE', ''),
(56, '10101.070', 'CONTROLE FINANCIER ELECTIONS', ''),
(57, '61905.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION MENABE', ''),
(58, '60406.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ANDROY', ''),
(59, '41210.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION BETSIBOKA', ''),
(60, '60101.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ATSIMO ANDREFANA', ''),
(61, '30101.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION HAUTE MATSIATRA', ''),
(62, '50302.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ALAOTRA MANGORO', ''),
(63, '50905.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ANALANJIROFO', ''),
(64, '41312.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION MELAKY', ''),
(65, '20705.100', 'POSTE CONTROLE FINANCIER DE NOSY BE', ''),
(66, '11707.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ITASY', ''),
(67, '40101.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION BOENY', ''),
(68, '31715.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION VATOVAVY', ''),
(69, '10101.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ANALAMANGA', ''),
(70, '31623.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION FITOVINANY', ''),
(71, '50101.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ATSINANANA', ''),
(72, '20101.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION DIANA', ''),
(73, '20824.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION SAVA', ''),
(74, '31307.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION IHOROMBE', ''),
(75, '30606.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION AMORON''I MANIA', ''),
(76, '11917.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION BONGOLAVA', ''),
(77, '61424.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ANOSY', ''),
(78, '30914.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION ATSIMO ATSINANANA', ''),
(79, '11001.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION VAKINANKARATRA', ''),
(80, '40711.100', 'DELEGATION REGIONALE CONTROLE FINANCIER DE LA REGION SOFIA', '');

-- --------------------------------------------------------
-- Table: del_aller1
-- --------------------------------------------------------
DROP TABLE IF EXISTS "del_aller1";

CREATE TABLE "del_aller1" (
  "id_del" SERIAL PRIMARY KEY,
  "numDef" VARCHAR(20) NOT NULL,
  "loginReception" VARCHAR(10) NOT NULL,
  "dateReception" DATE NOT NULL,
  "loginClotureDel" VARCHAR(10) NOT NULL,
  "dateClotureDel" DATE NOT NULL,
  "decisionforme" VARCHAR(20) NOT NULL,
  "decisionfond" VARCHAR(20) NOT NULL,
  "decisionfinale" VARCHAR(20) NOT NULL,
  "decisionObs" VARCHAR(20) NOT NULL,
  "instructions" VARCHAR(100) DEFAULT NULL,
  "etatDelVerif" VARCHAR(20) NOT NULL,
  "etatVerif2" INTEGER NOT NULL,
  "etat" INTEGER NOT NULL
);

COMMENT ON TABLE "del_aller1" IS 'Structure de la table del_aller1';

INSERT INTO "del_aller1" ("id_del", "numDef", "loginReception", "dateReception", "loginClotureDel", "dateClotureDel", "decisionforme", "decisionfond", "decisionfinale", "decisionObs", "instructions", "etatDelVerif", "etatVerif2", "etat") VALUES
(165, 'ENG2023000000297222', '343276', '2026-08-06', '343276', '2026-08-06', 'approuve', 'approuve', 'faitretour', 'approuve', 'rectification date', 'Cloturer', 0, 0);

-- --------------------------------------------------------
-- Table: del_aller2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "del_aller2";

CREATE TABLE "del_aller2" (
  "id_del" SERIAL PRIMARY KEY,
  "numDef" VARCHAR(20) NOT NULL,
  "loginReception" VARCHAR(10) NOT NULL,
  "dateReception" DATE NOT NULL,
  "loginClotureDel" VARCHAR(10) NOT NULL,
  "dateClotureDel" DATE NOT NULL,
  "decisionforme" VARCHAR(20) NOT NULL,
  "decisionfond" VARCHAR(20) NOT NULL,
  "decisionfinale" VARCHAR(20) NOT NULL,
  "decisionObs" VARCHAR(20) NOT NULL,
  "instructions" VARCHAR(200) NOT NULL,
  "etatDelVerif" VARCHAR(20) NOT NULL,
  "etatVerif2" INTEGER NOT NULL
);

COMMENT ON TABLE "del_aller2" IS 'Structure de la table del_aller2';

-- --------------------------------------------------------
-- Table: del_juridique
-- --------------------------------------------------------
DROP TABLE IF EXISTS "del_juridique";

CREATE TABLE "del_juridique" (
  "id_del" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(20) NOT NULL,
  "loginReception" VARCHAR(20) NOT NULL,
  "dateReception" TIMESTAMP NOT NULL,
  "loginCloture" VARCHAR(20) NOT NULL,
  "dateCloture" DATE NOT NULL,
  "decision" VARCHAR(20) NOT NULL,
  "observations_del" VARCHAR(100) NOT NULL,
  "faitretour_del" VARCHAR(100) NOT NULL,
  "numVisa" VARCHAR(20) NOT NULL,
  "etatDelVerif" VARCHAR(20) NOT NULL,
  "etatVerif2" INTEGER NOT NULL,
  "etatDelForme" INTEGER NOT NULL
);

COMMENT ON TABLE "del_juridique" IS 'Structure de la table del_juridique';

-- --------------------------------------------------------
-- Table: del_juridique2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "del_juridique2";

CREATE TABLE "del_juridique2" (
  "id_del" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(20) NOT NULL,
  "loginReception" VARCHAR(20) NOT NULL,
  "dateReception" DATE NOT NULL,
  "loginCloture" VARCHAR(20) NOT NULL,
  "dateCloture" DATE NOT NULL,
  "decision" VARCHAR(20) NOT NULL,
  "observations_del" VARCHAR(100) NOT NULL,
  "faitretour_del" VARCHAR(100) NOT NULL,
  "numVisa" VARCHAR(20) NOT NULL,
  "etatDelVerif" VARCHAR(20) NOT NULL,
  "etatVerif2" INTEGER NOT NULL
);

COMMENT ON TABLE "del_juridique2" IS 'Structure de la table del_juridique2';

-- --------------------------------------------------------
-- Table: engagement
-- --------------------------------------------------------
DROP TABLE IF EXISTS "engagement";

CREATE TABLE "engagement" (
  "id_eng" SERIAL PRIMARY KEY,
  "dateBdef" DATE DEFAULT NULL,
  "bdef" VARCHAR(20) DEFAULT NULL,
  "numDef" VARCHAR(25) DEFAULT NULL,
  "numdefdeg" VARCHAR(30) DEFAULT NULL,
  "ministere" VARCHAR(50) DEFAULT NULL,
  "mission" VARCHAR(4) DEFAULT NULL,
  "programme" VARCHAR(4) DEFAULT NULL,
  "soa" VARCHAR(20) DEFAULT NULL,
  "ordsec" VARCHAR(20) DEFAULT NULL,
  "cf_code" VARCHAR(10) DEFAULT NULL,
  "convention" VARCHAR(4) DEFAULT NULL,
  "financement" VARCHAR(12) DEFAULT NULL,
  "refMarche" VARCHAR(20) DEFAULT NULL,
  "tiersCode" VARCHAR(10) DEFAULT NULL,
  "tiersNom" VARCHAR(30) DEFAULT NULL,
  "compte" INTEGER DEFAULT NULL,
  "objet" VARCHAR(150) DEFAULT NULL,
  "categorie" INTEGER DEFAULT NULL,
  "dateEngagement" TIMESTAMP DEFAULT NULL,
  "region" VARCHAR(20) DEFAULT NULL,
  "montant" DOUBLE PRECISION DEFAULT NULL,
  "creditModifie" DOUBLE PRECISION DEFAULT NULL,
  "loiFinance" DOUBLE PRECISION DEFAULT NULL,
  "type_engagement" VARCHAR(12) DEFAULT NULL,
  "procedure" VARCHAR(20) DEFAULT NULL,
  "etatEng" VARCHAR(10) NOT NULL,
  "dateRejetVisa" TIMESTAMP DEFAULT NULL,
  "etat" INTEGER NOT NULL,
  "exercice" VARCHAR(10) NOT NULL
);

COMMENT ON TABLE "engagement" IS 'Structure de la table engagement';

INSERT INTO "engagement" ("id_eng", "dateBdef", "bdef", "numDef", "numdefdeg", "ministere", "mission", "programme", "soa", "ordsec", "cf_code", "convention", "financement", "refMarche", "tiersCode", "tiersNom", "compte", "objet", "categorie", "dateEngagement", "region", "montant", "creditModifie", "loiFinance", "type_engagement", "procedure", "etatEng", "dateRejetVisa", "etat", "exercice") VALUES
(5578, '2023-11-06', 'BDF2023000000022889', 'ENG2023000000258844', NULL, '32', '320', '015', '00-32-0-B10-00000', '00-320-5-000', '10101.320', '104', '10-M32-P01-A', '23-00032-023-029-001', 'I300009332', 'AUTO DIFFUSION SA', 2472, 'Fournitures et livraisons des vehicules  4x4 Pick-Up 5 places et un TOYOTA PRADO TX-L 7 places du MT', 5, NULL, NULL, 999000000, 2106000000, 2106000000, 'Marche', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5584, '2023-11-02', 'BDF2023000000025855', 'ENG2023000000330041', NULL, '05', '050', '005', '00-05-0-110-00000', '00-050-1-000', '10101.050', '123', '10-M05-P10-A', '23001005AOO004002', 'I500390918', 'CLARYSSE ARNA', 23173, 'LOT 2: Fourniture de viande (marche a commande) suivant marche n 01-PM/PRMP/UGPM-2023 et proforma n', 5, NULL, NULL, 123456789.12, 1200000000, 1200000000, 'Marche', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5585, '2023-11-15', 'BDF2023000000025854', 'ENG2023000000277237', NULL, '05', '050', '005', '00-05-0-110-00000', '00-050-1-000', '10101.050', '123', '10-M05-P10-A', '23001005AOO004001', 'I400391742', 'SOCIETE NY AINA', 23173, 'LOT 1: Fourniture du riz (marche a commande) suivant marche n 01-PM/PRMP/UGPM-2023 et proforma n 005', 5, NULL, NULL, 28200000, 1200000000, 1200000000, 'Marche', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5586, '2023-11-10', 'BDF2023000000025852', 'ENG2023000000287834', NULL, '05', '050', '005', '00-05-0-110-00000', '00-050-1-000', '10101.050', '123', '10-M05-P10-A', '2300001-5CPX001001', 'I500390918', 'CLARYSSE ARNA', 23173, 'Fourniture de bois de cuisson pour la Commandement de Bataillon de la Securite de la Primature suiva', 5, NULL, NULL, 9999000, 1200000000, 1200000000, 'Convention', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5587, '2023-11-12', 'BDF2023000000025853', 'ENG2023000000277173', NULL, '05', '050', '005', '00-05-0-110-00000', '00-050-1-000', '10101.050', '123', '10-M05-P10-A', '2300001-5CPX001001', 'I500390918', 'CLARYSSE ARNA', 23173, 'Fourniture de bois de cuisson pour le Commandement de Bataillon de la Securite de la Primature suiva', 5, NULL, NULL, 49500000, 1200000000, 1200000000, 'Convention', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5588, '2023-11-02', 'BDF2023000000025851', 'ENG2023000000287813', NULL, '05', '050', '005', '00-05-0-110-00000', '00-050-1-000', '10101.050', '123', '10-M05-P10-A', '23001005AOO004002', 'I500390918', 'CLARYSSE ARNA', 23173, 'LOT 2: Fourniture de viande (marche a commande) suivant marche n 01-PM/PRMP/UGPM-2023 et proforma n', 5, NULL, NULL, 8500000, 1200000000, 1200000000, 'Marche', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5589, '2023-11-12', 'BDF2023000000026389', 'ENG2023000000293003', NULL, '05', '050', '139', '00-05-0-130-00000', '00-050-3-000', '10101.050', '000', '10-001-001-A', '2300027-5CPX001001', 'I200019221', 'RAVONIARISOA JUDITH ANNA', 6213, 'Entretien et reparation de vehicule administratif 4X4 HYUNDAI GALLOPER N 2441 TAC pour la Direction ', 3, NULL, NULL, 9999400, 10000000, 10000000, 'Convention', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5624, '2023-11-08', 'BDF2023000000026772', 'ENG2023000000297232', NULL, '05', '050', '005', '00-05-0-061-00000', '00-050-7-000', '10101.050', '000', '10-001-001-A', NULL, 'T10101200', 'RECEVEUR GENERAL D''ANTANANARIV', 6031, 'Versement IRSA liee a l''indemnite de fonction mois de novembre 2023 aux personnels permanents Milita', 3, NULL, NULL, 3634375, 5818250000, 5818250000, 'Engagement g', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5625, '2023-11-08', 'BDF2023000000026772', 'ENG2023000000297242', NULL, '05', '050', '005', '00-05-0-061-00000', '00-050-7-000', '10101.050', '000', '10-001-001-A', NULL, 'T10101200', 'RECEVEUR GENERAL D''ANTANANARIV', 6031, 'Versement IRSA liee a l''indemnite de fonction mois de novembre 2023 aux personnels permanents Milita', 3, NULL, NULL, 3571875, 5818250000, 5818250000, 'Engagement g', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5626, '2023-11-08', 'BDF2023000000026771', 'ENG2023000000297222', NULL, '05', '050', '005', '00-05-0-061-00000', '00-050-7-00000', '10101.050', '000', '10-001-001-A', NULL, 'G000507000', 'ORDONNATEUR SECONDAIRE DU BUDG', 6031, 'Paiement Indemnite liee a la fonction aux personnels permanents Militaires, Gendarmes et Policiers d', 3, NULL, NULL, 118490624, 5818250000, 5818250000, 'Engagement g', 'Nouvel engagement', 'DEF', NULL, 1, '2023'),
(5627, '2023-11-08', 'BDF2023000000026771', 'ENG2023000000297267', NULL, '05', '050', '005', '00-05-0-061-00000', '00-050-7-000', '10101.050', '000', '10-001-001-A', NULL, 'G000507000', 'ORDONNATEUR SECONDAIRE DU BUDG', 6031, 'Paiement Indemnite liee a la fonction aux personnels permanents Militaires, Gendarmes et Policiers d', 3, NULL, NULL, 75900000, 5818250000, 5818250000, 'Engagement g', 'Nouvel engagement', 'DEF', NULL, 1, '2023'),
(5628, '2023-11-08', 'BDF2023000000026771', 'ENG2023000000297282', NULL, '05', '050', '005', '00-05-0-061-00000', '00-050-7-000', '10101.050', '000', '10-001-001-A', NULL, 'G000507000', 'ORDONNATEUR SECONDAIRE DU BUDG', 6031, 'Paiement Indemnite liee a la fonction aux personnels permanents Militaires, Gendarmes et Policiers d', 3, NULL, NULL, 42262500, 5818250000, 5818250000, 'Engagement g', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5629, '2023-11-08', 'BDF2023000000026771', 'ENG2023000000297276', NULL, '05', '050', '005', '00-05-0-061-00000', '00-050-7-000', '10101.050', '000', '10-001-001-A', NULL, 'G000507000', 'ORDONNATEUR SECONDAIRE DU BUDG', 6031, 'Paiement Indemnite liee a la fonction aux personnels permanents Militaires, Gendarmes et Policiers d', 3, NULL, NULL, 39165000, 5818250000, 5818250000, 'Engagement g', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5630, '2023-11-08', 'BDF2023000000026771', 'ENG2023000000297292', NULL, '05', '050', '005', '00-05-0-061-00000', '00-050-7-000', '10101.050', '000', '10-001-001-A', NULL, 'G000507000', 'ORDONNATEUR SECONDAIRE DU BUDG', 6031, 'Paiement Indemnite liee a la fonction aux personnels permanents Militaires, Gendarmes et Policiers d', 3, NULL, NULL, 22007000, 5818250000, 5818250000, 'Engagement g', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5631, '2023-11-08', 'BDF2023000000026771', 'ENG2023000000297260', NULL, '05', '050', '005', '00-05-0-061-00000', '00-050-7-000', '10101.050', '000', '10-001-001-A', NULL, 'G000507000', 'ORDONNATEUR SECONDAIRE DU BUDG', 6031, 'Paiement Indemnite liee a la fonction aux personnels permanents Militaires, Gendarmes et Policiers d', 3, NULL, NULL, 106615624, 5818250000, 5818250000, 'Engagement g', 'Nouvel engagement', 'DEF', NULL, 0, '2023'),
(5638, '2023-11-30', 'BDF2023000000032384', 'ENG2023000000335729', NULL, '05', '050', '005', '00-05-0-160-00000', '00-050-3-00000', '10101.050', '000', '10-001-001-A', '2300051-5CPX001001', 'I200006521', 'RAMANANDRAISOA PASCALINE-ECOCI', 6213, 'Entretien et reparation de vehicule administratif RENAULT Type 557N05, genre VP, 2537 TAJ suivant fa', 3, NULL, NULL, 4786000, 4800000, 4800000, 'Convention', 'Nouvel engagement', 'DEF', NULL, 0, '2023');

-- --------------------------------------------------------
-- Table: eng_juridique
-- --------------------------------------------------------
DROP TABLE IF EXISTS "eng_juridique";

CREATE TABLE "eng_juridique" (
  "id_eng_jur" SERIAL PRIMARY KEY,
  "ref_jur" VARCHAR(50) NOT NULL,
  "objet_jur" VARCHAR(100) NOT NULL,
  "type_jur" VARCHAR(50) NOT NULL,
  "cf_code" VARCHAR(20) DEFAULT NULL,
  "refCf" VARCHAR(20) DEFAULT NULL,
  "soa" VARCHAR(20) DEFAULT NULL,
  "expediteur" VARCHAR(20) NOT NULL,
  "compte" VARCHAR(5) NOT NULL,
  "observation" VARCHAR(20) DEFAULT NULL,
  "soumission" INTEGER DEFAULT NULL,
  "dateReception" TIMESTAMP NOT NULL,
  "loginReception" VARCHAR(10) DEFAULT NULL,
  "dateCloture" TIMESTAMP NOT NULL,
  "loginCloture" VARCHAR(10) DEFAULT NULL,
  "etatSecVerif" VARCHAR(20) DEFAULT NULL,
  "etatSec" INTEGER NOT NULL,
  "loginReceptionSec" VARCHAR(20) NOT NULL,
  "dateReceptionSec" DATE DEFAULT NULL,
  "loginClotureSec" VARCHAR(20) NOT NULL,
  "dateClotureSec" DATE DEFAULT NULL,
  "etatSec2" INTEGER NOT NULL,
  "etatSecService" VARCHAR(20) NOT NULL,
  "nomservice" VARCHAR(30) NOT NULL,
  "dateReceptionService" DATE DEFAULT NULL,
  "exercice" VARCHAR(4) NOT NULL
);

COMMENT ON TABLE "eng_juridique" IS 'Structure de la table eng_juridique';

-- --------------------------------------------------------
-- Table: eng_juridique2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "eng_juridique2";

CREATE TABLE "eng_juridique2" (
  "id_eng_jur2" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(20) DEFAULT NULL,
  "soumission" INTEGER DEFAULT NULL,
  "dateReception2" DATE DEFAULT NULL,
  "loginReception" VARCHAR(10) DEFAULT NULL,
  "dateCloture2" DATE DEFAULT NULL,
  "loginCloture2" VARCHAR(10) DEFAULT NULL,
  "etatSecVerif2" VARCHAR(20) DEFAULT NULL,
  "etatSec" INTEGER NOT NULL,
  "loginReceptionSec" VARCHAR(20) NOT NULL,
  "dateReceptionSec" DATE DEFAULT NULL,
  "loginClotureSec" VARCHAR(20) NOT NULL,
  "dateClotureSec" DATE DEFAULT NULL,
  "etatSec2" INTEGER NOT NULL,
  "etatSecService" VARCHAR(20) NOT NULL,
  "nomservice" VARCHAR(30) NOT NULL,
  "dateReceptionService" DATE DEFAULT NULL
);

COMMENT ON TABLE "eng_juridique2" IS 'Structure de la table eng_juridique2';

-- --------------------------------------------------------
-- Table: motif
-- --------------------------------------------------------
DROP TABLE IF EXISTS "motif";

CREATE TABLE "motif" (
  "id_motif" SERIAL PRIMARY KEY,
  "lib_motif" VARCHAR(200) NOT NULL
);

COMMENT ON TABLE "motif" IS 'Structure de la table motif';

INSERT INTO "motif" ("id_motif", "lib_motif") VALUES
(2, 'RaS'),
(4, 'Objet de la depense errone'),
(5, 'Renseignements ou remplissage des rubriques incomplets ou a mettre a jour'),
(6, 'N Marche ou Convention errone'),
(7, 'Fausse imputation ou different du marche/convention'),
(8, 'Decompte ou arretage en lettres errone (Proforma)'),
(9, 'Signature ou/et  date omisent'),
(10, 'Marche/Convention non vise (CF) '),
(11, 'Marche/Convention non enregistre (Impôt)'),
(12, 'Signature Ministre omise(>50 Millions)'),
(13, 'Type d''engagement ou procedure errone'),
(16, 'Pieces justificatives irregulieres (non conformes)  ou a mettre a jour'),
(18, 'Non respect de la regulation'),
(21, 'Montant de l''engagement errone'),
(25, 'Autres (probleme fiscal, favoritisme,.....)');

-- --------------------------------------------------------
-- Table: motif_marche
-- --------------------------------------------------------
DROP TABLE IF EXISTS "motif_marche";

CREATE TABLE "motif_marche" (
  "id_motif" INTEGER PRIMARY KEY DEFAULT 0,
  "lib_motif" VARCHAR(200) NOT NULL
);

COMMENT ON TABLE "motif_marche" IS 'Structure de la table motif_marche';

INSERT INTO "motif_marche" ("id_motif", "lib_motif") VALUES
(2, 'RaS'),
(4, 'Non respect des procedures ou  des reglementations en vigueur'),
(5, 'Renseignements ou remplissage des rubriques incomplets ou a mettre a jour'),
(6, 'Prix exorbitant'),
(7, 'Fausse imputation'),
(8, 'Decompte errone'),
(9, 'Prestataire /Fournisseur inapte'),
(10, 'Credit disponible insuffisant ou inexistant'),
(11, 'Cumul de fonction ORDSEC-PRMP'),
(12, 'Fractionnement'),
(13, 'Dossier incomplet'),
(14, 'Prix anormalement bas'),
(15, 'Depassement des quantites commandes par rapport aux quantites livrables'),
(16, 'Pieces justificatives irregulieres (non conformes)  ou a mettre a jour'),
(17, 'Engagement non autorise ou non prevu'),
(18, 'Non respect de la regulation'),
(19, 'Non conformite au PV de la CNM'),
(21, 'Autres (probleme fiscal, favoritisme,.....)');

-- --------------------------------------------------------
-- Table: pcop
-- --------------------------------------------------------
DROP TABLE IF EXISTS "pcop";

CREATE TABLE "pcop" (
  "id_pcop" SERIAL PRIMARY KEY,
  "compte" INTEGER DEFAULT NULL,
  "libelle_compte" VARCHAR(234) DEFAULT NULL
);

COMMENT ON TABLE "pcop" IS 'Structure de la table pcop';

INSERT INTO "pcop" ("id_pcop", "compte", "libelle_compte") VALUES
(1, 7551, 'Organismes prives locaux'),
(2, 7552, 'Organismes prives internationaux'),
(3, 7561, 'Aides directes'),
(4, 41118, 'Redevables - Recettes fiscales - Budget General - Autres recettes fiscales'),
(5, 41181, 'Redevables - Recettes fiscales - Autres - Exercice en cours'),
(6, 412111, 'Clients et redevables - Recettes non fiscales - Budget General - Redevances - Exercice en cours'),
(7, 412161, 'Clients et redevables - Recettes non fiscales - Budget General - Dons et legs - Exercice en cours'),
(8, 41222, 'Clients et redevables - Recettes non fiscales - Budgets Annexes - Exercices anterieurs'),
(9, 41241, 'Clients et redevables - Recettes non fiscales - Fonds de contre valeur - Exercice en cours'),
(10, 4131, 'Effets a recevoir - Recettes fiscales'),
(11, 7320, 'Droit de navigation'),
(12, 2846, 'Installations techniques - Materiel et outillage'),
(13, 2908, 'Autres immobilisations incorporelles'),
(14, 2951, 'Titres de participation et autres formes de participations'),
(15, 2955, 'Depots et cautionnements verses'),
(16, 3114, 'Produits, petits materiels'),
(17, 3115, 'Petit outillage et fournitures d''atelier'),
(18, 3212, 'Consommables medicaux'),
(19, 3712, 'Produits finis'),
(20, 3911, 'Fournitures et articles de bureau'),
(21, 3912, 'Imprimes, cachets et documents administratifs'),
(22, 3913, 'Consomptibles informatiques'),
(23, 3924, 'Produits veterinaires'),
(24, 3971, 'Produits intermediaires'),
(25, 3981, 'Matieres premieres'),
(26, 73401, 'TVA sur commerce exterieur remboursable(TVR)'),
(27, 7414, 'Taxes sur les spectacles'),
(28, 6278, 'Autres charges locatives'),
(29, 6320, 'Intervention economique'),
(30, 6440, 'Droits a l''importation'),
(31, 6513, 'Regions'),
(32, 6514, 'Communes'),
(33, 6621, 'Interets bancaires et operations de financements a court terme'),
(34, 6631, 'Interets des comptes courants'),
(35, 6660, 'Perte de changes'),
(36, 6751, 'Interets moratoires'),
(37, 2662, 'Entreprises privees non financieres'),
(38, 2664, 'Etablissements publics'),
(39, 2694, 'Etablissements publics'),
(40, 27210, 'Obligations: Recettes'),
(41, 27312, 'Prets a long et moyen terme ? part a moins d''un an'),
(42, 27710, 'Avances ordinaires: Recettes'),
(43, 2772, 'Avances retrocessions aux operateurs'),
(44, 6782, 'Quote-part de resultat sur operations faites en commun'),
(45, 6852, 'Dotations - Charges d''intervention'),
(46, 7010, 'Impots sur les benefices des societes - IBS'),
(47, 7112, 'Taxe additionnelle sur les ventes immobilieres et fonds de commerce'),
(48, 7113, 'Droits d''enregistrement sur les actes des societes ? DEAS'),
(49, 7120, 'Taxe annuelle sur les vehicules de tourismes des societes ? TSVTS'),
(50, 7231, 'Droit d''accise : DA'),
(51, 2457, 'Installations, agencements et amenagements ? Reseaux'),
(52, 2458, 'Autres constructions ou rehabilitations ? Reseaux'),
(53, 24612, 'Immobilisations corporelles en cours - Materiels techniques : Operation d''ordre'),
(54, 2468, 'Autres materiels et outillages'),
(55, 2472, 'Vehicules terrestres'),
(56, 24812, 'Immobilisations corporelles en cours - Cheptel : Operation d''ordre'),
(57, 6232, 'Frais de deplacement exterieur'),
(58, 6242, 'Indemnites de mission exterieure'),
(59, 6271, 'Location d''immeuble'),
(60, 6273, 'Location d''immeuble de bureau-logement'),
(61, 8028, 'Autres'),
(62, 86113, 'Bons du Tresor recus en approvisionnement'),
(63, 86118, 'Autres valeurs'),
(64, 86122, 'Valeurs afferentes au Service de l''Enregistrement et du timbre'),
(65, 8613, 'Comptes de prise en charge'),
(66, 86131, 'Tickets'),
(67, 4018221, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Virement - Avis de credit - Exercice en cours'),
(68, 4018222, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Virement - Avis de credit - N-1'),
(69, 4018811, 'Fournisseurs et comptes rattaches - Autres : Numeraire - Bons de caisse : Exercice en cours'),
(70, 4018824, 'Fournisseurs et comptes rattaches - Autres : Virement - Avis de credit : N-3'),
(71, 40511, 'Transferts et subventions - Budget General : Numeraire - Bons de caisse'),
(72, 405123, 'Transferts et subventions - Budget General : Virement - Avis de credit - N-2'),
(73, 405211, 'Transferts et subventions - Budgets Annexes - Numeraire - Bons de caisse - Exercice en cours'),
(74, 405413, 'Transferts et subventions - Fonds de Contre Valeur - Numeraire - Bons de caisse - N-2'),
(75, 405421, 'Transferts et subventions - Fonds de Contre Valeur - Virement - Avis de credit - Exercice en cours'),
(76, 405422, 'Transferts et subventions - Fonds de Contre Valeur - Virement - Avis de credit - N-1'),
(77, 405811, 'Transferts et subventions - Autres : Numeraire - Bons de caisse - Exercice en cours'),
(78, 405821, 'Transferts et subventions - Autres - Virement - Avis de credit - Exercice en cours'),
(79, 405823, 'Transferts et subventions - Autres - Virement - Avis de credit - N-2'),
(80, 40811, 'Fournisseurs : Depenses d''immobilisations - Budget General - Numeraire - Bons de caisse'),
(81, 408114, 'Fournisseurs : Depenses d''immobilisations - Budget General - Numeraire - Bons de caisse - N-3'),
(82, 408124, 'Fournisseurs : Depenses d''immobilisations - Budget General - Virement - Avis de credit - N-3'),
(83, 408213, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Numeraire - Bons de caisse - Exercice en cours - N-2'),
(84, 408422, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Virement - Avis de credit - N-1'),
(85, 40882, 'Fournisseurs : Depenses d''immobilisations - Autres - Virement - Avis de credit'),
(86, 40924, 'Creanciers ordinaires ? Comptes debiteurs - Regies d''avances non regularisees - Fonds de contre valeur'),
(87, 182321, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres d''un comptable public (autres que TG/TP de rattachement) - Numeraire'),
(88, 2437, 'Installations, agencements et amenagements ? Batiments'),
(89, 1823323, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Cheques - Domaines'),
(90, 18236, 'Compte de liaison entre TP et receveurs des administrations financieres - Virement a effectuer par le TG/TP de rattachement'),
(91, 1831, 'Operation concernant le compte courant du Tresor a la Banque Centrale'),
(92, 1014, 'Fonds de travaux reseaux electricite'),
(93, 1015, 'Fonds de travaux reseau eau'),
(94, 18112, 'Compte de liaison a l''initiative du PP - Depenses'),
(95, 1811211, 'Compte de liaison a l''initiative du PP - Depenses - Caisse de Retraite Civile et Militaire (CRCM)'),
(96, 181122, 'Compte de liaison a l''initiative du PP - Depenses - Bons de caisse et mandats de tresorerie'),
(97, 181123, 'Compte de liaison a l''initiative du PP - Depenses - Ordre de paiement'),
(98, 1811238, 'Compte de liaison a l''initiative du PP - Depenses - Ordre de paiement : Autres'),
(99, 18122, 'Compte de liaison a l''initiative du TG/TP - Depenses'),
(100, 181321, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres d''un comptable public (autres que TG/TP de rattachement) - Numeraire'),
(101, 181342, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres d''une Banque Primaire - Cheques'),
(102, 1821112, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Douanes - Impots locaux'),
(103, 1821132, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Domaines - Impots locaux'),
(104, 1822, 'Compte de liaison a l''initiative du TG/TP'),
(105, 184111, 'Compte de liaison entre TG/TP - Transferts de recettes - Budget General'),
(106, 1842111, 'Compte de liaison entre TG/TP - Transferts de depenses - Budget General - Bons de caisse et mandats de tresorerie'),
(107, 1842128, 'Compte de liaison entre TG/TP - Transferts de depenses - Autres comptes particuliers du Tresor'),
(108, 1314, 'Subventions d''equipements recues - Aides bilaterales'),
(109, 1321, 'Utilisation de FCV en investissement - Aides bilaterales'),
(110, 1390, 'Subvention d''investissement transferee au compte de resultat'),
(111, 1411, 'Cession d''immobilisation incorporelles- Frais de developpement, de recherche et d''etudes'),
(112, 1421, 'Terrains'),
(113, 1426, 'Materiel et outillage'),
(114, 1471, 'Ventes de titres de participation'),
(115, 1531, 'Provisions pour pensions'),
(116, 161110, 'Bons: Recettes'),
(117, 16112, 'Emprunts en Ariary a long et moyen terme : part a plus d''un an - Obligations'),
(118, 413128, 'Droits a percevoir sur quittance en portefeuille - Autres'),
(119, 77132, 'Redevance ad valorem sur les produits miniers et autres'),
(120, 77144, 'Prelevements et ristournes sur les produits (agricoles, forestiers, ?)'),
(121, 7718, 'Autres redevances'),
(122, 772114, 'Droit de demolition'),
(123, 772121, 'Droit WC'),
(124, 401113, 'Fournisseurs et comptes rattaches - Budget General : Numeraire - Bons de caisse : N-2'),
(125, 401211, 'Fournisseurs et comptes rattaches - Budgets Annexes : Numeraire - Bons de caisse - Exercice en cours'),
(126, 401214, 'Fournisseurs et comptes rattaches - Budgets Annexes : Numeraire - Bons de caisse - N-3'),
(127, 401221, 'Fournisseurs et comptes rattaches - Budgets Annexes : Virement - Avis de credit - Exercice en cours'),
(128, 401313, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Numeraire - Bons de caisse : N-2'),
(129, 401323, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Virement - Avis de credit : N-2'),
(130, 401412, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Numeraire - Bons de caisse : N-1'),
(131, 40142, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Virement - Avis de credit'),
(132, 4018, 'Autres'),
(133, 401821, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Numeraire - Bons de caisse'),
(134, 7728, 'Autres produits des activites de services'),
(135, 7732, 'Locations diverses'),
(136, 2438, 'Autres constructions ou rehabilitations ? Batiments'),
(137, 24381, 'Immobilisations corporelles en cours - Autres constructions ou rehabilitations - Batiments - Operation budgetaire'),
(138, 24421, 'Immobilisations corporelles en cours - Voies ferrees - Operation budgetaire'),
(139, 24441, 'Immobilisations corporelles en cours - Pistes d''aerodrome - Operation budgetaire'),
(140, 5191, 'Mobilisation de creances commerciales'),
(141, 5200, 'Instruments de tresorerie'),
(142, 5330, 'Caisse Agences Comptables des Postes Diplomatiques et Consulaires'),
(143, 54111, 'Armee'),
(144, 5413, 'Comptes Particuliers du Tresor'),
(145, 6031, 'Personnel permanent'),
(146, 6032, 'Personnel non permanent'),
(147, 6041, 'Personnel permanent'),
(148, 6131, 'Carburants et lubrifiants'),
(149, 6163, 'Variation des stocks de carburants, lubrifiants, et combustibles'),
(150, 6212, 'Entretien des autres infrastructures'),
(151, 6214, 'Entretien de materiels techniques'),
(152, 6215, 'Entretien et reparation des materiels et mobiliers'),
(153, 6222, 'Charges de representation - Visites officielles'),
(154, 41622, 'Redevables - Comptes de commerce - Exercices anterieurs'),
(155, 4163, 'Comptes d''investissement sur ressources exterieures'),
(156, 41632, 'Redevables - Comptes d''investissement sur ressources exterieures - Exercices anterieurs'),
(157, 41641, 'Redevables - Comptes d''avances - Exercice en cours'),
(158, 421112, 'Personnel : Salaires et accessoires - Budget General - Numeraire - Bons de caisse - N-1'),
(159, 421114, 'Personnel : Salaires et accessoires - Budget General - Numeraire - Bons de caisse - N-3'),
(160, 421212, 'Personnel : Salaires et accessoires - Budgets Annexes - Numeraire - Bons de caisse - N-1'),
(161, 161189, 'Autres emprunts: Depenses'),
(162, 473421, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables non centralisateurs - Douanes'),
(163, 473423, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables non centralisateurs - Perception Principale'),
(164, 47411, 'Credits a retablir apres recouvrement des trop payes - Fonctionnement'),
(165, 4764, 'Augmentation des dettes a court terme'),
(166, 4774, 'Diminution des dettes a court terme'),
(167, 4786145, 'Approvisionnement de fonds au profit des Agences Comptables des Postes Diplomatiques et Consulaires'),
(168, 478616, 'Avance de tresorerie accordee'),
(169, 478623, 'Depenses a classer et a regulariser - Comptables non centralisateurs - Perception Principale'),
(170, 478625, 'Depenses a classer et a regulariser - Comptables non centralisateurs - Domaine'),
(171, 478642, 'Envoi de fonds en faveur des Perceptions Principales via BOA'),
(172, 4787, 'Recettes a classer et a regulariser'),
(173, 47871, 'Recettes a classer et a regulariser - Comptables centralisateurs'),
(174, 478711, 'Recettes en attente de regularisation a l''ACCT/DP'),
(175, 2212, 'Amenagement'),
(176, 2213, 'Construction ou rehabilitation - Batiments'),
(177, 2225, 'Construction ou rehabilitation - Reseaux'),
(178, 2226, 'Installations techniques - Materiel et outillage'),
(179, 2239, 'Droit de l''affectant'),
(180, 2311, 'Formation'),
(181, 2312, 'Animation et encadrement'),
(182, 2315, 'Etudes et recherches'),
(183, 23151, 'Operation budgetaire'),
(184, 23175, 'Entretien et reparation'),
(185, 23522, 'Immobilisations incorporelles en cours - Concessions et droits similaires - Operation d''ordre'),
(186, 2414, 'Terrains de chantiers'),
(187, 24141, 'Immobilisations corporelles en cours - Terrains de chantiers - Operation budgetaire'),
(188, 24152, 'Immobilisations corporelles en cours - Terrains de voiries - Operation d''ordre'),
(189, 4787138, 'Autres'),
(190, 4787142, 'Envoi de fonds ACCT/DP en faveur des Perceptions Principales via BOA'),
(191, 478741, 'Envoi de fonds ACCT/DP en faveur des Tresoreries Principales via BOA'),
(192, 47878, 'Autres recettes a classer et a regulariser'),
(193, 4920, 'Perte de valeur sur les comptes de clients'),
(194, 5050, 'Titres'),
(195, 5090, 'Versements restant a effectuer sur VMP non liberees'),
(196, 511122, 'BCM - Comptes speciaux du Tresor en Euro'),
(197, 51181, 'BCM - Autres comptes en Ariary'),
(198, 51188, 'BCM - Autres comptes - Autres devises'),
(199, 51211, 'CCP ? Compte courant (Comptable centralisateur)'),
(200, 5178, 'Autres'),
(201, 24182, 'Immobilisations corporelles en cours - Autres - Operation d''ordre'),
(202, 2421, 'Amenagement de terrain'),
(203, 24221, 'Immobilisations corporelles en cours - Amenagement des aerodromes - Operation budgetaire'),
(204, 24231, 'Immobilisations corporelles en cours - Amenagement des Ports - Operation budgetaire'),
(205, 2424, 'Travaux d''irrigation'),
(206, 24241, 'Immobilisations corporelles en cours - Amenagement - Travaux d''irrigation - Operation budgetaire'),
(207, 24252, 'Immobilisations corporelles en cours - Amenagement - Travaux d''urbanisme - Operation d''ordre'),
(208, 24321, 'Immobilisations corporelles en cours - Batiments scolaires - Operation budgetaire'),
(209, 2434, 'Autres batiments techniques'),
(210, 421312, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Numeraire - Bons de caisse - N-1'),
(211, 421324, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Virement - Avis de credit - N-3'),
(212, 4214, 'Fonds de Contre Valeur'),
(213, 421413, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Bons de caisse - N-2'),
(214, 421814, 'Personnel : Salaires et accessoires - Autres - Numeraire - Bons de caisse - N-3'),
(215, 4251, 'Avances de solde'),
(216, 427122, 'Personnel - Oppositions - Budget General - Virement - Avis de credit - N-1'),
(217, 427221, 'Personnel - Oppositions - Budgets Annexes - Virement - Avis de credit - Exercice en cours'),
(218, 24342, 'Immobilisations corporelles en cours - Autres batiments techniques - Operation d''ordre'),
(219, 16121, 'Emprunts en Ariary a long et moyen terme : part a moins d''un an - Avances de la Banque Centrale'),
(220, 1670, 'Dettes sur contrat de location-financement'),
(221, 181111, 'Compte de liaison a l''initiative du PP - Recettes au profit du Budget General de l''Etat'),
(222, 21781, 'Immobilisations corporelles - Autres moyens de locomotion - Operation budgetaire'),
(223, 21822, 'Autres immobilisations corporelles - Emballages recuperables - Operation d''ordre'),
(224, 2183, 'Installations complexes specialisees'),
(225, 473224, 'Depenses avant ordonnancement - Budgets Annexes - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(226, 21421, 'Immobilisations corporelles - Voies ferrees - Operation budgetaire'),
(227, 21522, 'Immobilisations corporelles - Reseau d''assainissement - Operation d''ordre'),
(228, 472126, 'Imputation provisoire de depenses - Budget General - Comptables non centralisateurs - Topographie'),
(229, 47222, 'Imputation provisoire de depenses - Budgets Annexes - Comptables non centralisateurs'),
(230, 472324, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(231, 47242, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables non centralisateurs'),
(232, 21551, 'Immobilisations corporelles - Reseau d''electricite - Operation budgetaire'),
(233, 21572, 'Immobilisations corporelles - Installations, agencements et amenagements - Reseaux - Operation d''ordre'),
(234, 472425, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables non centralisateurs - Domaine'),
(235, 4731, 'Budget General'),
(236, 47312, 'Depenses avant ordonnancement - Budget General - Comptables non centralisateurs'),
(237, 473121, 'Depenses avant ordonnancement - Budget General - Comptables non centralisateurs - Douanes'),
(238, 47322, 'Depenses avant ordonnancement - Budgets Annexes - Comptables non centralisateurs'),
(239, 427321, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Virement - Avis de credit - Exercice en cours'),
(240, 42782, 'Personnel - Oppositions - Autres - Virement - Avis de credit'),
(241, 4316, 'CNAPS - Autres charges a payer'),
(242, 4327, 'CRCM - Retenue et contribution'),
(243, 4411, 'Dons et aides non remboursables a recevoir'),
(244, 4421, 'FCV - Subventions bilaterales a utiliser'),
(245, 45111, 'Comptabilites distinctes rattachees - Budgets annexes - Imprimerie Nationale'),
(246, 45118, 'Comptabilites distinctes rattachees - Budgets annexes - Autres'),
(247, 451182, 'Comptabilites distinctes rattachees - Budgets annexes - Autres - Investissement'),
(248, 4518, 'Autres'),
(249, 4521, 'Collectivites Territoriales Decentralisees'),
(250, 45222, 'Correspondants - Etablissements Publics Nationaux - Federation chambre de commerce'),
(251, 4528, 'Autres correspondants'),
(252, 4532, 'Comptes de depots avec interets'),
(253, 46342, 'Amende et transactions avant jugement - Centre Fiscal'),
(254, 46344, 'Amende et transactions avant jugement - Departement des Eaux et Forets'),
(255, 463625, 'Operations d''encaissement diverses - Departement des Eaux et Forets'),
(256, 4654, 'Comptables des etablissements publics'),
(257, 4688, 'Autres'),
(258, 4713, 'Recettes percues avant emission de titre'),
(259, 1851233, 'Compte de liaison a l''initiative des ACD - Depenses - Ordre de paiement - Remises'),
(260, 1851238, 'Compte de liaison a l''initiative des ACD - Depenses - Ordre de paiement - Autres'),
(261, 20122, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Animation et encadrement - Operation d''ordre'),
(262, 20142, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Logiciels informatiques et assimiles - Operation d''ordre'),
(263, 20161, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes : Suivi - Controles - Evaluation - Operation budgetaire'),
(264, 20162, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes : Suivi - Controles - Evaluation - Operation d''ordre'),
(265, 2111, 'Terrains nus'),
(266, 2113, 'Terrains de gisement'),
(267, 21131, 'Immobilisations corporelles - Terrains de gisement - Operation budgetaire'),
(268, 2114, 'Terrains de chantiers'),
(269, 4718, 'Autres'),
(270, 4721114, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - Paiements a imputer - Dette interieure - Lots servis aux titres d''emprunts'),
(271, 472112, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - Paiements a imputer - Dette exterieure'),
(272, 21152, 'Immobilisations corporelles - Terrains de voiries - Operation d''ordre'),
(273, 2118, 'Autres'),
(274, 2131, 'Batiments administratifs'),
(275, 21311, 'Immobilisations corporelles - Batiments administratifs - Operation budgetaire'),
(276, 21312, 'Immobilisations corporelles - Batiments administratifs - Operation d''ordre'),
(277, 21322, 'Immobilisations corporelles - Batiments scolaires - Operation d''ordre'),
(278, 183, 'Compte de liaison entre ACCTDP et TG/TP'),
(279, 311, 'Biens de fonctionnement general'),
(280, 371, 'Produits intermediaires et produits finis'),
(281, 243, 'Construction ou Rehabilitation - Batiments'),
(282, 245, 'Construction ou Rehabilitation - Reseaux'),
(283, 141, 'Cession d''immobilisation incorporelles'),
(284, 479, 'Operations en attente de regularisation'),
(285, 779, 'Degrevement, remise, reduction ou annulation'),
(286, 678, 'Autres charges diverses'),
(287, 739, 'Degrevement, remise, reduction ou annulation'),
(288, 742, 'Interet sur credit de droit'),
(289, 514, 'Interets courus'),
(290, 534, 'Caisse Regies des Administrations Financieres'),
(291, 473, 'Depenses avant ordonnancement'),
(292, 60313, 'prime de service'),
(293, 655612, 'Transfert pour charges d''intervention - Autres organismes-Heures complementaires'),
(294, 77214, 'Recette des ventes de cartes'),
(295, 7522, 'Collectivites Territoriales Decentralisees'),
(296, 7523, 'Etablissements Publics a caractere Industriel et Commercial'),
(297, 7550, 'Organismes prives locaux'),
(298, 411112, 'Redevables - Recettes fiscales - Budget General - Impots sur les revenus, benefices et gains - Exercices anterieurs'),
(299, 411121, 'Redevables - Recettes fiscales - Budget General - Impots sur les biens et services - Exercice en cours'),
(300, 411182, 'Redevables - Recettes fiscales - Budget General - Autres recettes fiscales - Exercices anterieurs'),
(301, 4112, 'Budgets Annexes'),
(302, 41122, 'Redevables - Recettes fiscales - Budgets Annexes - Exercices anterieurs'),
(303, 41142, 'Redevables - Recettes fiscales - Fonds de contre valeur - Exercices anterieurs'),
(304, 4121, 'Budget General'),
(305, 412122, 'Clients et redevables - Recettes non fiscales - Budget General - Produits des activites des services - Exercices anterieurs'),
(306, 412151, 'Clients et redevables - Recettes non fiscales - Budget General - Produits financiers - Exercice en cours'),
(307, 412152, 'Clients et redevables - Recettes non fiscales - Budget General - Produits financiers - Exercices anterieurs'),
(308, 412182, 'Clients et redevables - Recettes non fiscales - Budget General - Autres - Exercices anterieurs'),
(309, 7293, 'Annulation'),
(310, 2818, 'Autres immobilisations corporelles'),
(311, 2905, 'Concessions et droits similaires, brevets, licences, marques'),
(312, 2911, 'Terrains'),
(313, 2912, 'Amenagement'),
(314, 2954, 'Droits de souscription aux organismes internationaux'),
(315, 3113, 'Consomptibles informatiques'),
(316, 3214, 'Produits veterinaires'),
(317, 3311, 'Carburants et lubrifiants'),
(318, 3510, 'Prestations de services en cours'),
(319, 3612, 'Travaux en cours'),
(320, 3923, 'Produits pharmaceutiques'),
(321, 3950, 'Prestations de services en cours'),
(322, 3982, 'Marchandises destinees a etre revendues'),
(323, 7350, 'TVA sur produits petroliers'),
(324, 7393, 'Annulation'),
(325, 7432, 'Penalite de retard'),
(326, 7481, 'Taxe speciale pour la jeunesse et sport'),
(327, 7484, 'Activites minieres'),
(328, 7485, 'Activites touristiques'),
(329, 6548, 'Autres contributions obligatoires'),
(330, 6555, 'Transfert pour charges d''intervention - EPIC'),
(331, 6556, 'Transfert pour charges d''intervention - Autres organismes'),
(332, 6712, 'Degrevement sur titres emis'),
(333, 6713, 'Perte sur creances irrecouvrables'),
(334, 6714, 'Perte sur dons exterieurs'),
(335, 6720, 'Reversement sur trop percu'),
(336, 6741, 'Frais de justice'),
(337, 2668, 'Autres formes de participation'),
(338, 2722, 'Bons'),
(339, 27349, 'Autres titres representatifs de droits de creances : Depenses'),
(340, 2785, 'Interets courus sur depots et cautionnements verses'),
(341, 6753, 'Penalites'),
(342, 7024, 'Impot sur le revenu - IR'),
(343, 7093, 'Annulation'),
(344, 7261, 'Taxe sur les assurances - TSA'),
(345, 7275, 'Prelevement sur les produits de jeux ? PPJ'),
(346, 7276, 'Prelevements speciaux sur les jeux - PSJ'),
(347, 7280, 'Autres impots sur les biens et services'),
(348, 2461, 'Materiels techniques'),
(349, 24611, 'Immobilisations corporelles en cours - Materiels techniques : Operation budgetaire'),
(350, 24632, 'Immobilisations corporelles en cours - Materiels informatiques : Operation d''ordre'),
(351, 24641, 'Immobilisations corporelles en cours - Materiels et mobiliers de bureau : Operation budgetaire'),
(352, 2465, 'Materiels et mobiliers de logement'),
(353, 24662, 'Immobilisations corporelles en cours - Materiels et mobiliers scolaires : Operation d''ordre'),
(354, 24672, 'Immobilisations corporelles en cours - Outillages : Operation d''ordre'),
(355, 24681, 'Immobilisations corporelles en cours - Autres materiels et outillages : Operation budgetaire'),
(356, 24682, 'Immobilisations corporelles en cours - Autres materiels et outillages : Operation d''ordre'),
(357, 24752, 'Immobilisations corporelles en cours - Materiel naval : Operation d''ordre'),
(358, 24762, 'Immobilisations corporelles en cours - Materiel aerien : Operation d''ordre'),
(359, 24811, 'Immobilisations corporelles en cours - Cheptel : Operation budgetaire'),
(360, 6233, 'Location de materiels de transport'),
(361, 6236, 'Peage, parking et autres frais'),
(362, 6262, 'Redevances telephoniques'),
(363, 6263, 'Redevances telephoniques mobiles'),
(364, 7292, 'Remise et reduction'),
(365, 405122, 'Transferts et subventions - Budget General : Virement - Avis de credit - N-1'),
(366, 405222, 'Transferts et subventions - Budgets Annexes - Virement - Avis de credit - N-1'),
(367, 40532, 'Transferts et subventions - Comptes Particuliers du Tresor - Virement - Avis de credit'),
(368, 405822, 'Transferts et subventions - Autres - Virement - Avis de credit - N-1'),
(369, 405824, 'Transferts et subventions - Autres - Virement - Avis de credit - N-3'),
(370, 408112, 'Fournisseurs : Depenses d''immobilisations - Budget General - Numeraire - Bons de caisse - N-1'),
(371, 40821, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Numeraire - Bons de caisse'),
(372, 408312, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Numeraire - Bons de caisse - N-1'),
(373, 408323, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Virement - Avis de credit - N-2'),
(374, 408411, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Numeraire - Bons de caisse - Exercice en cours'),
(375, 408811, 'Fournisseurs : Depenses d''immobilisations - Autres - Numeraire - Bons de caisse - Exercice en cours'),
(376, 409218, 'Creanciers ordinaires ? Comptes debiteurs - Regies d''avances non regularisees - Budget General - Autres'),
(377, 1823121, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie -Cheques - Douanes'),
(378, 18233, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale'),
(379, 182331, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Numeraire'),
(380, 1823313, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Numeraire - Domaines'),
(381, 182332, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Cheques'),
(382, 1823322, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Cheques - Centre Fiscal'),
(383, 18311, 'Compte de liaison entre ACCT/DP et TG/TP - Operation concernant le compte courant du Tresor a la Banque Centrale - Compte courant en Ariary'),
(384, 1832, 'Transfert avances et prets'),
(385, 1833, 'Transfert Bons du Tresor et Obligations'),
(386, 1011, 'Contreparties d''integrations patrimoniales'),
(387, 1213, 'Resultat des Comptes Particuliers du Tresor'),
(388, 1811233, 'Compte de liaison a l''initiative du PP - Depenses - Ordre de paiement - Remises'),
(389, 18132, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres d''un comptable public (autres que TG/TP de rattachement)'),
(390, 1821128, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Centre Fiscal - Autres'),
(391, 1821141, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Topographie - Budget General'),
(392, 1823, 'Envoi de fonds et reglement de tresorerie entre comptables'),
(393, 1841212, 'Compte de liaison entre TG/TP - Transferts de recettes - Correspondants du Tresor - Collectivites Territoriales Decentralisees - Region'),
(394, 18422, 'Compte de liaison entre TG/TP - Transferts de depenses - Correspondants du Tresor'),
(395, 1843, 'Compte de liaison entre TG/TP : Envoi de fonds'),
(396, 18431, 'Compte de liaison entre TG/TP - Envoi de fonds - Numeraire'),
(397, 1851211, 'Compte de liaison a l''initiative des ACD - Depenses - Pensions francaises'),
(398, 185123, 'Compte de liaison a l''initiative des ACD - Depenses - Ordre de paiement'),
(399, 13132, 'Subvention d''equipement recue - Etablissements Publics a caractere'),
(400, 13133, 'Subvention d''equipement recue - Organismes prives nationaux'),
(401, 13138, 'Autres subventions d''equipements recues'),
(402, 1418, 'Autres immobilisations incorporelles'),
(403, 1428, 'Autres immobilisations corporelles'),
(404, 1538, 'Provisions pour autres obligations similaires'),
(405, 1580, 'Autres provisions pour charges'),
(406, 16111, 'Emprunts en Ariary a long et moyen terme : part a plus d''un an - Bons'),
(407, 4131122, 'Droits a percevoir sur obligations cautionnees - Douanes - Exercices anterieurs'),
(408, 413122, 'Droits a percevoir sur quittance en portefeuille - Douanes'),
(409, 7622, 'Revenus des prets a long et moyen terme'),
(410, 77133, 'Frais d''administration miniere'),
(411, 7714, 'Redevance sur autorisations administratives'),
(412, 772113, 'Droit de construction'),
(413, 40112, 'Fournisseurs et comptes rattaches - Budget General : Virement - Avis de credit'),
(414, 401213, 'Fournisseurs et comptes rattaches - Budgets Annexes : Numeraire - Bons de caisse - N-2'),
(415, 4013, 'Comptes Particuliers du Tresor'),
(416, 40131, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Numeraire - Bons de caisse'),
(417, 401311, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Numeraire - Bons de caisse : Exercice en cours'),
(418, 40132, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Virement - Avis de credit'),
(419, 401414, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Numeraire - Bons de caisse : N-3'),
(420, 4018123, 'Fournisseurs et comptes rattaches - Frais de justice criminelle - Virement - Avis de credit - N-2'),
(421, 7734, 'Confiscations'),
(422, 7776, 'Amendes et condamnation pecu niaires'),
(423, 7782, 'Recouvrement sur trop paye'),
(424, 7785, 'Frais et accessoires refactures'),
(425, 7816, 'Reprises financieres'),
(426, 2448, 'Autres constructions ou rehabilitations ? Voies'),
(427, 24522, 'Immobilisations corporelles en cours - Reseau d''assainissement : Operation d''ordre'),
(428, 5418, 'Autres'),
(429, 5458, 'Autres'),
(430, 5914, 'Organismes financiers'),
(431, 5915, 'Emprunts a court terme'),
(432, 6033, 'Personnel membre des Institutions'),
(433, 6063, 'Cotisations caisse de Prevoyance de Retraite'),
(434, 6121, 'Fournitures scolaires'),
(435, 6183, 'Emballages'),
(436, 6188, 'Autres achats divers'),
(437, 6216, 'Maintenance des materiels informatiques, electriques, electroniques et telephoniques'),
(438, 4131282, 'Droits a percevoir sur quittance en portefeuille - Autres - Exercices anterieurs'),
(439, 4152, 'Recettes non fiscales'),
(440, 4162, 'Comptes de commerce'),
(441, 41631, 'Redevables - Comptes d''investissement sur ressources exterieures - Exercice en cours'),
(442, 41642, 'Redevables - Comptes d''avances - Exercices anterieurs'),
(443, 4167, 'Comptes de participation'),
(444, 41911, 'Clients - Avances et acomptes recus - Centre Fiscal'),
(445, 4192, 'Clients et redevables - Trop percu'),
(446, 41928, 'Clients et redevables - Trop percu - Autres'),
(447, 421122, 'Personnel : Salaires et accessoires - Budget General - Virement - Avis de credit - N-1'),
(448, 421211, 'Personnel : Salaires et accessoires - Budgets Annexes - Numeraire - Bons de caisse - Exercice en cours'),
(449, 421214, 'Personnel : Salaires et accessoires - Budgets Annexes - Numeraire - Bons de caisse - N-3'),
(450, 473424, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(451, 47412, 'Credits a retablir apres recouvrement des trop payes - Investissement'),
(452, 4786133, 'Prise en charge rejet de transfert ? Depenses'),
(453, 4786144, 'Degagement de fonds des Regies Financieres aupres des Perceptions Principales'),
(454, 478632, 'Transfert assignataire - Depenses recues en instance de couverture'),
(455, 21882, 'Autres immobilisations corporelles - Installations, agencements et amenagements divers - Operation d''ordre'),
(456, 2217, 'Materiel de transport'),
(457, 2219, 'Droit du concedant'),
(458, 2221, 'Terrains'),
(459, 2222, 'Amenagement'),
(460, 23111, 'Operation budgetaire'),
(461, 23112, 'Operation d''ordre'),
(462, 2313, 'Assistance technique'),
(463, 2314, 'Logiciels informatiques et assimiles'),
(464, 2316, 'Suivi ? Controle ? Evaluation'),
(465, 23171, 'Frais de personnel'),
(466, 23174, 'Transport et mission'),
(467, 2318, 'Autres'),
(468, 23512, 'Immobilisations incorporelles en cours - Concessions et droits similaires - Operation d''ordre'),
(469, 24121, 'Immobilisations corporelles en cours - Terrains batis - Operation budgetaire'),
(470, 24122, 'Immobilisations corporelles en cours - Terrains batis - Operation d''ordre'),
(471, 24162, 'Immobilisations corporelles en cours - Cimetieres - Operation d''ordre'),
(472, 478723, 'Recettes a classer et a regulariser - Comptables non centralisateurs - Perception Principale'),
(473, 478724, 'Recettes a classer et a regulariser - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(474, 478733, 'Prise en charge rejet de transfert recettes - Recettes'),
(475, 478734, 'Transfert de recettes en provenance des Regies Financieres'),
(476, 47874, 'Envoi de fonds'),
(477, 478742, 'Envoi de fonds ACCT/DP en faveur des Perceptions Principales via BOA'),
(478, 4791, 'Compte d''ordre ? Operations centralisees'),
(479, 4794, 'Compte d''ordre ? Apurement des comptes non repris par le PCOP 2006'),
(480, 5129, 'CCP - Solde crediteur'),
(481, 5150, 'Emprunts a court terme'),
(482, 5174, 'Virement attendu'),
(483, 24222, 'Immobilisations corporelles en cours - Amenagement des aerodromes - Operation d''ordre'),
(484, 2425, 'Travaux d''urbanisme'),
(485, 24281, 'Immobilisations corporelles en cours - Autres amenagements - Operation budgetaire'),
(486, 421222, 'Personnel : Salaires et accessoires - Budgets Annexes - Virement - Avis de credit - N-1'),
(487, 421323, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Virement - Avis de credit - N-2'),
(488, 4218, 'Autres'),
(489, 421811, 'Personnel : Salaires et accessoires - Autres - Numeraire - Bons de caisse - Exercice en cours'),
(490, 42183, 'Personnel : Salaires et accessoires - Autres - Mandat de tresorerie'),
(491, 427124, 'Personnel - Oppositions - Budget General - Virement - Avis de credit - N-3'),
(492, 42721, 'Personnel - Oppositions - Budgets Annexes - Numeraire - Ordre de paiement'),
(493, 427213, 'Personnel - Oppositions - Budgets Annexes - Numeraire - Ordre de paiement - N-2'),
(494, 1621, 'Emprunts a long et moyen terme : part a plus d''un an'),
(495, 16210, 'Emprunts a long et moyen terme : part a plus d''un an - Recettes'),
(496, 1622, 'Emprunts a long et moyen terme : part a moins d''un an'),
(497, 1650, 'Depots et cautionnements recus'),
(498, 1730, 'Dettes rattachees a des societes en participation'),
(499, 2454, 'Reseau de communication'),
(500, 24562, 'Immobilisations corporelles en cours - Reseau d''irrigation : Operation d''ordre'),
(501, 21732, 'Immobilisations corporelles - Materiel fluvial - Operation d''ordre'),
(502, 21742, 'Immobilisations corporelles - Materiel ferroviaire - Operation d''ordre'),
(503, 21752, 'Immobilisations corporelles - Materiel naval - Operation budgetaire'),
(504, 47331, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Comptables Centralisateurs'),
(505, 473321, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Douanes'),
(506, 473322, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Centre Fiscal'),
(507, 21471, 'Immobilisations corporelles - Installations, agencements et amenagements - Voies - Operation budgetaire'),
(508, 472122, 'Imputation provisoire de depenses - Budget General - Comptables non centralisateurs - Centre Fiscal'),
(509, 4722, 'Budgets Annexes'),
(510, 47221, 'Imputation provisoire de depenses - Budgets Annexes - Comptables centralisateurs'),
(511, 472323, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables non centralisateurs - Perception Principale'),
(512, 472421, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables non centralisateurs - Douanes'),
(513, 21652, 'Immobilisations corporelles - Materiels et mobiliers de logement - Operation d''ordre'),
(514, 473126, 'Depenses avant ordonnancement - Budget General - Comptables non centralisateurs - Topographie'),
(515, 4732, 'Budgets Annexes'),
(516, 21532, 'Immobilisations corporelles - Reseau telephonique - Operation d''ordre'),
(517, 2155, 'Reseau d''electricite'),
(518, 427313, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Numeraire - Ordre de paiement - N-2'),
(519, 42741, 'Personnel - Oppositions - Fonds de contre valeur - Numeraire - Ordre de paiement'),
(520, 427412, 'Personnel - Oppositions - Fonds de contre valeur - Numeraire - Ordre de paiement - N-1'),
(521, 4281, 'Personnel - Charges a payer'),
(522, 4310, 'CNAPS - Cotisations a reverser'),
(523, 4511, 'Budgets annexes'),
(524, 451121, 'Comptabilites distinctes rattachees - Budgets annexes - Garage administratif - Fonctionnement'),
(525, 4513, 'Organismes etrangers'),
(526, 45181, 'Comptabilites distinctes rattachees - Autres - Operations avec la Paierie de France'),
(527, 45211, 'Correspondants - Collectivites Territoriales Decentralisees - Faritany'),
(528, 45213, 'Correspondants - Collectivites Territoriales Decentralisees - Communes'),
(529, 45224, 'Correspondants - Etablissements Publics Nationaux - Office Nationale des anciens combattants'),
(530, 45288, 'Correspondants - Autres correspondants'),
(531, 453131, 'Comptes de depots sans interets - Collectivites non dotees d''un comptable du Tresor'),
(532, 45314, 'Comptes de depots sans interets - Organismes specialises'),
(533, 45318, 'Comptes de depots sans interets - Autres deposants'),
(534, 4621, 'Consignations'),
(535, 4622, 'Successions vacantes'),
(536, 46318, 'Remise sur les obligations cautionnees - Autres'),
(537, 4632, 'Fonds commun du Tresor sur les obligations cautionnees'),
(538, 46343, 'Amende et transactions avant jugement - Tresor'),
(539, 46352, 'Part des porteurs de contraintes - Centre Fiscal'),
(540, 4677, 'Autres crediteurs'),
(541, 46772, 'Autres crediteurs - Provisions - CCAL'),
(542, 46773, 'Autres crediteurs - Provisions - JIRAMA'),
(543, 471311, 'Recettes percues avant emission de titre - Budget General - Comptables centralisateurs'),
(544, 1851232, 'Compte de liaison a l''initiative des ACD - Depenses - Ordre de paiement - Avis de delegations de credit'),
(545, 185124, 'Compte de liaison a l''initiative des ACD - Depenses - Frais de justice criminelle'),
(546, 18521, 'Compte de liaison a l''initiative de l''ACCPDC - Recettes'),
(547, 20132, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Assistance technique - Operation d''ordre'),
(548, 20152, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Etudes et recherches - Operation d''ordre'),
(549, 20172, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes : Frais de pre-exploitation - Operation d''ordre'),
(550, 20801, 'Autres immobilisations incorporelles - Operation budgetaire'),
(551, 20802, 'Autres immobilisations incorporelles - Operation d''ordre'),
(552, 4713122, 'Recettes percues avant emission de titre - Budget General - Comptables non centralisateurs - Centre Fiscal'),
(553, 4713128, 'Recettes percues avant emission de titre - Budget General - Comptables non centralisateurs - Autres'),
(554, 471332, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables non centralisateurs'),
(555, 4713322, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables non centralisateurs - Centre Fiscal'),
(556, 4713326, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables non centralisateurs - Topographie'),
(557, 47134, 'Recettes percues avant emission de titre - Fonds de contre valeur'),
(558, 4713421, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables non centralisateurs - Douanes'),
(559, 4721, 'Budget General'),
(560, 21162, 'Immobilisations corporelles - Cimetieres - Operation d''ordre'),
(561, 21211, 'Immobilisations corporelles - Amenagement de terrain - Operation budgetaire'),
(562, 21222, 'Immobilisations corporelles - Amenagement des aerodromes - Operation d''ordre'),
(563, 21231, 'Immobilisations corporelles - Amenagement des Ports - Operation budgetaire'),
(564, 2128, 'Autres amenagements'),
(565, 21282, 'Immobilisations corporelles - Autres amenagements - Operation d''ordre'),
(566, 2133, 'Batiments de centres de soins de sante'),
(567, 2141, 'Routes'),
(568, 182, 'Compte de liaison entre TG/TP et Receveurs des Administrations Financieres'),
(569, 295, 'Perte de valeur sur immobilisations financieres'),
(570, 414, 'Clients et redevables - Creances douteuses'),
(571, 216, 'Materiels et outillages'),
(572, 241, 'Terrains'),
(573, 252, 'Avances et acomptes verses sur commandes d''immobilisations corporelles'),
(574, 186, 'Biens et prestations de services echanges entre Etablissements'),
(575, 139, 'Subvention d''investissement transferee au compte de resultat'),
(576, 142, 'Cession d''immobilisations corporelles'),
(577, 633, 'Intervention structurelle'),
(578, 723, 'Droit d''accise : DA'),
(579, 728, 'Autres impots sur les biens et services'),
(580, 743, 'Amendes fiscales et penalites'),
(581, 773, 'Produits des activites annexes et accessoires'),
(582, 65, 'Transferts et subventions'),
(583, 655211, 'Transferts pour charges de services public - Autres organismes - Salaires et accessoires'),
(584, 65518, 'Transferts pour charges de services public - EPA - Transferts aux organismes public - Autres transferts'),
(585, 65558, 'Transfert pour charges d''intervention - EPIC - Transferts aux organismes public - Autres transferts'),
(586, 2040, 'Logiciel informatique et assimiles'),
(587, 7492, 'Remise et reduction'),
(588, 7571, 'Aides directes'),
(589, 411131, 'Redevables - Recettes fiscales - Budget General - Impots sur le commerce exterieur - Exercice en cours'),
(590, 41121, 'Redevables - Recettes fiscales - Budgets Annexes - Exercice en cours'),
(591, 41213, 'Clients et redevables - Recettes non fiscales - Budget General - Produits des activites annexes et accessoires'),
(592, 412141, 'Clients et redevables - Recettes non fiscales - Budget General - Contributions recues des tiers - Exercice en cours'),
(593, 412162, 'Clients et redevables - Recettes non fiscales - Budget General - Dons et legs - Exercices anterieurs'),
(594, 4122, 'Budgets Annexes'),
(595, 41242, 'Clients et redevables - Recettes non fiscales - Fonds de contre valeur - Exercices anterieurs'),
(596, 2816, 'Installations techniques - Materiel et outillage'),
(597, 2844, 'Construction ou rehabilitation - Voies'),
(598, 2847, 'Materiel de transport'),
(599, 2848, 'Autres immobilisations corporelles'),
(600, 2915, 'Constructions ou rehabilitation - Reseaux'),
(601, 2917, 'Materiel de transport'),
(602, 3111, 'Fournitures et articles de bureau'),
(603, 3211, 'Fournitures scolaires'),
(604, 3213, 'Produits pharmaceutiques'),
(605, 3611, 'Produits en cours'),
(606, 3812, 'Marchandises destinees a etre revendues'),
(607, 3813, 'Emballages'),
(608, 3917, 'Habillement'),
(609, 3926, 'Intrants agricoles'),
(610, 3932, 'Gaz'),
(611, 3962, 'Travaux en cours'),
(612, 7370, 'Taxe unique sur les produits petroliers'),
(613, 7482, 'Activites agricoles'),
(614, 7486, 'Telecommunications'),
(615, 6283, 'Prestations de service'),
(616, 6288, 'Autres services divers'),
(617, 6532, 'Bourses a l''exterieur'),
(618, 6533, 'Presalaire, pret d''honneur'),
(619, 6542, 'Contingents obligatoires'),
(620, 6561, 'Hospitalisation, traitement et soins'),
(621, 6563, 'Indemnisation'),
(622, 6564, 'Regularisation des droits acquis'),
(623, 6611, 'Interets des emprunts'),
(624, 6622, 'Interets des operations de financements a court terme'),
(625, 24882, 'Immobilisations corporelles en cours - Installations, agencements et amenagements divers : Operation d''ordre'),
(626, 2510, 'Avances et acomptes verses sur commandes d''immobilisations incorporelles'),
(627, 2691, 'Entreprises publiques non financieres'),
(628, 2721, 'Obligations'),
(629, 27220, 'Bons: Recettes'),
(630, 27311, 'Prets a long et moyen terme ? part a plus d''un an'),
(631, 273210, 'Retrocession : part a plus d''un an - Recettes'),
(632, 273220, 'Retrocession : part a moins d''un an - Recettes'),
(633, 2750, 'Depots et cautionnements verses'),
(634, 2771, 'Avances ordinaires'),
(635, 27720, 'Avances retrocessions aux operateurs: Recettes'),
(636, 2784, 'Interets courus sur droits de souscription aux organismes internationaux'),
(637, 6752, 'Amendes'),
(638, 6770, 'Election'),
(639, 6788, 'Autres'),
(640, 7022, 'Impot general sur les revenus salariaux - IRSA'),
(641, 70242, 'Impot sur les revenus des non-residents'),
(642, 7080, 'Autres impots sur le revenu'),
(643, 7116, 'Taxe de publicite fonciere - TPF'),
(644, 7191, 'Degrevement'),
(645, 72312, 'Droit d''accise intermittent'),
(646, 7251, 'Taxe sur les produits petroliers'),
(647, 7262, 'Taxe annexe sur les contrats d''assurance'),
(648, 2467, 'Outillages'),
(649, 24712, 'Immobilisations corporelles en cours - Renouvellement des vehicules du parc administratif : Operation d''ordre'),
(650, 2473, 'Materiel fluvial'),
(651, 24751, 'Immobilisations corporelles en cours - Materiel naval : Operation budgetaire'),
(652, 24782, 'Immobilisations corporelles en cours - Autres moyens de locomotion : Operation d''ordre'),
(653, 2481, 'Cheptel'),
(654, 2482, 'Emballages recuperables'),
(655, 8611, 'Valeurs chez le comptable'),
(656, 86111, 'Titres de rente - Actions'),
(657, 4018223, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Virement - Avis de credit - N-2'),
(658, 401823, 'N-2'),
(659, 40521, 'Transferts et subventions - Budgets Annexes - Numeraire - Bons de caisse'),
(660, 405214, 'Transferts et subventions - Budgets Annexes - Numeraire - Bons de caisse - N-3'),
(661, 405223, 'Transferts et subventions - Budgets Annexes - Virement - Avis de credit - N-2'),
(662, 4058, 'Autres'),
(663, 405812, 'Transferts et subventions - Autres : Numeraire - Bons de caisse - N-1'),
(664, 405813, 'Transferts et subventions - Autres : Numeraire - Bons de caisse - N-2'),
(665, 40582, 'Transferts et subventions - Autres - Virement - Avis de credit'),
(666, 408222, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Virement - Avis de credit - Exercice en cours - N-1'),
(667, 408314, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Numeraire - Bons de caisse - N-3'),
(668, 408324, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Virement - Avis de credit - N-3'),
(669, 4084, 'Fonds de Contre Valeur'),
(670, 408423, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Virement - Avis de credit - N-2'),
(671, 408823, 'Fournisseurs : Depenses d''immobilisations - Autres - Virement - Avis de credit - N-2'),
(672, 4088814, 'N-3'),
(673, 182311, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Numeraire'),
(674, 1823111, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Numeraire - Douanes'),
(675, 1823112, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Numeraire - Centre Fiscal'),
(676, 1823122, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Cheques - Centre Fiscal'),
(677, 182313, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Traites'),
(678, 182322, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres d''un comptable public (autres que TG/TP de rattachement) - Cheques'),
(679, 18235, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres CCP'),
(680, 1834, 'Transfert autres emprunts nationaux'),
(681, 1050, 'Ecart de reevaluation'),
(682, 1061, 'Reserves des budgets annexes'),
(683, 1215, 'Resultat en capital de la dette publique'),
(684, 181322, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres d''un comptable public (autres que TG/TP de rattachement) - Cheques'),
(685, 181332, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Cheques'),
(686, 18212, 'Compte de liaison a l''initiative du receveur des administrations financieres - Depenses'),
(687, 183512, 'Compte de liaison entre ACCT/DP et TG/TP - Transfert de tresorerie - Remises sur obligations cautionnees'),
(688, 1841121, 'Compte de liaison entre TG/TP - Transferts de recettes - Comptes Particuliers du Tresor - Caisse de Retraite Civile et Militaire (CRCM)'),
(689, 1841128, 'Compte de liaison entre TG/TP - Transferts de recettes - Comptes Particuliers du Tresor - Autres comptes particuliers du Tresor'),
(690, 1841211, 'Compte de liaison entre TG/TP - Transferts de recettes - Correspondants du Tresor - Collectivites Territoriales Decentralisees - Faritany'),
(691, 184122, 'Compte de liaison entre TG/TP - Transferts de recettes - Correspondants du Tresor - Etablissements Publics'),
(692, 184182, 'Compte de liaison entre TG/TP - Autres transferts de recettes - Carburants et lubrifiants'),
(693, 1842112, 'Compte de liaison entre TG/TP - Transferts de depenses - Budget General - Ordre de paiement'),
(694, 18421128, 'Compte de liaison entre TG/TP - Transferts de depenses - Budget General - Ordre de paiement - Autres'),
(695, 1851, 'Compte de liaison a l''initiative des ACPDC'),
(696, 185118, 'Compte de liaison a l''initiative des ACD - Autres recettes'),
(697, 1425, 'Reseaux'),
(698, 1474, 'Remboursements d''avances accordees'),
(699, 161120, 'Obligations: Recettes'),
(700, 4131221, 'Droits a percevoir sur quittance en portefeuille - Douanes - Exercice en cours'),
(701, 7630, 'Revenus des autres creances'),
(702, 7680, 'Autres produits financiers'),
(703, 77146, 'Droits relatifs aux cartes d''identite d''etrangers'),
(704, 772124, 'Dina'),
(705, 772125, 'Droit Fitsaram-pasana'),
(706, 40111, 'Fournisseurs et comptes rattaches - Budget General : Numeraire - Bons de caisse'),
(707, 401321, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Virement - Avis de credit : Exercice en cours'),
(708, 401411, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Numeraire - Bons de caisse - Exercice en cours'),
(709, 401424, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Virement - Avis de credit : N-3'),
(710, 40181, 'Fournisseurs et comptes rattaches - Frais de justice criminelle'),
(711, 4018111, 'Fournisseurs et comptes rattaches - Frais de justice criminelle : Numeraire - Bons de caisse - Exercice en cours'),
(712, 401812, 'Fournisseurs et comptes rattaches - Frais de justice criminelle - Virement - Avis de credit'),
(713, 4018214, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Numeraire - Bons de caisse - N-3'),
(714, 7724, 'Produits residuels'),
(715, 7726, 'Marchandises'),
(716, 7742, 'Immobilisation corporelle'),
(717, 7771, 'Plus-values sur cessions d''immobilisations'),
(718, 7788, 'Autres produits occasionnels'),
(719, 7793, 'Annulation'),
(720, 24422, 'Immobilisations corporelles en cours - Voies ferrees - Operation d''ordre'),
(721, 2443, 'Voies d''eau'),
(722, 24481, 'Immobilisations corporelles en cours - Installations, agencements et amenagements ? Voies - Autres constructions ou rehabilitations - Voies : Operation budgetaire'),
(723, 5320, 'Caisse PP'),
(724, 5414, 'Fonds de Contre Valeur'),
(725, 6022, 'Personnel non permanent'),
(726, 6043, 'Personnel membre des Institutions'),
(727, 6112, 'Imprimes, cachets et documents administratifs'),
(728, 6124, 'Produits veterinaires'),
(729, 6128, 'Fournitures menageres'),
(730, 6161, 'Variation des stocks de biens de fonctionnement general'),
(731, 6168, 'Variation des stocks d''autres achats'),
(732, 6211, 'Entretien de batiments'),
(733, 6221, 'Fetes et ceremonies officielles'),
(734, 6228, 'Autres charges de  representation, d''information, de documentation et d''encadrement'),
(735, 41321, 'Effets a recevoir - Recettes non fiscales - Exercice en cours'),
(736, 4138, 'Effets a recevoir - Autres'),
(737, 4166, 'Comptes de reprets'),
(738, 4191, 'Clients - Avances et acomptes recus'),
(739, 41921, 'Clients et redevables - Trop percu - Centre Fiscal'),
(740, 421123, 'Personnel : Salaires et accessoires - Budget General - Virement - Avis de credit - N-2'),
(741, 421124, 'Personnel : Salaires et accessoires - Budget General - Virement - Avis de credit - N-3'),
(742, 4212, 'Budgets Annexes'),
(743, 4748, 'Autres credits a retablir'),
(744, 478615, 'Pensions francaises'),
(745, 47862, 'Depenses a classer et a regulariser - Comptables non centralisateurs'),
(746, 478622, 'Depenses a classer et a regulariser - Comptables non centralisateurs - Centre Fiscal'),
(747, 47864, 'Envoi de fonds'),
(748, 478644, 'Degagement de fonds des Regies Financieres aupres des Perceptions Principales'),
(749, 2216, 'Installations techniques - Materiel et outillage'),
(750, 2231, 'Terrains'),
(751, 2237, 'Materiel de transport'),
(752, 23122, 'Operation d''ordre'),
(753, 2412, 'Terrains batis'),
(754, 24131, 'Immobilisations corporelles en cours - Terrains de gisement - Operation budgetaire'),
(755, 24142, 'Immobilisations corporelles en cours - Terrains de chantiers - Operation d''ordre'),
(756, 2416, 'Cimetieres'),
(757, 478721, 'Recettes a classer et a regulariser - Comptables non centralisateurs - Douanes'),
(758, 478728, 'Recettes a classer et a regulariser - Comptables non centralisateurs - Autres'),
(759, 478743, 'Envoi de fonds en faveur des Regies Financieres (sous compte ouvert a la Banque Centrale)'),
(760, 478744, 'Degagement de fonds des Regies Financieres aupres des Perceptions Principales'),
(761, 4793, 'Contrepartie ? Reprise solde au 31/12/92'),
(762, 5116, 'BCM - Aides non remboursables'),
(763, 5127, 'CCP - Emission de cheque CCP ou ordre de virement CCP'),
(764, 5146, 'Interets courus a payer'),
(765, 5171, 'Cheques a encaisser'),
(766, 51722, 'Cheques CCP remis a l''encaissement'),
(767, 24181, 'Immobilisations corporelles en cours - Autres - Operation budgetaire'),
(768, 2432, 'Batiments scolaires'),
(769, 24331, 'Immobilisations corporelles en cours - Batiments de centres de soins de sante - Operation budgetaire'),
(770, 24332, 'Immobilisations corporelles en cours - Batiments de centres de soins de sante - Operation d''ordre'),
(771, 421412, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Bons de caisse - N-1'),
(772, 421414, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Bons de caisse - N-3'),
(773, 421422, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Virement - Avis de credit - N-1'),
(774, 42181, 'Personnel : Salaires et accessoires - Autres - Numeraire - Bons de caisse'),
(775, 42182, 'Personnel : Salaires et accessoires - Autres - Virement - Avis de credit'),
(776, 4252, 'Acomptes au personnel'),
(777, 427112, 'Personnel - Oppositions - Budget General - Numeraire - Ordre de paiement - N-1'),
(778, 427114, 'Personnel - Oppositions - Budget General - Numeraire - Ordre de paiement - N-3'),
(779, 427123, 'Personnel - Oppositions - Budget General - Virement - Avis de credit - N-2'),
(780, 42722, 'Personnel - Oppositions - Budgets Annexes - Virement - Avis de credit'),
(781, 427222, 'Personnel - Oppositions - Budgets Annexes - Virement - Avis de credit - N-1'),
(782, 427223, 'Personnel - Oppositions - Budgets Annexes - Virement - Avis de credit - N-2'),
(783, 161210, 'Avances de la Banque Centrale: Recettes'),
(784, 1680, 'Autres emprunts et dettes assimiles'),
(785, 1688, 'Interets courus sur emprunts et dettes assimiles'),
(786, 1811111, 'Compte de liaison a l''initiative du PP - Recettes au profit du Budget General de l''Etat : Recettes percues sur titre'),
(787, 24532, 'Immobilisations corporelles en cours - Reseau telephonique : Operation d''ordre'),
(788, 21741, 'Immobilisations corporelles - Materiel ferroviaire - Operation budgetaire'),
(789, 21761, 'Immobilisations corporelles - Materiel aerien - Operation budgetaire'),
(790, 21762, 'Immobilisations corporelles - Materiel aerien - Operation d''ordre'),
(791, 21831, 'Autres immobilisations corporelles - Installations complexes specialisees - Operation budgetaire'),
(792, 473228, 'Depenses avant ordonnancement - Budgets Annexes - Comptables non centralisateurs - Autres'),
(793, 47332, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Comptables non centralisateurs'),
(794, 473328, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Autres'),
(795, 4734, 'Fonds de Contre Valeur'),
(796, 2144, 'Pistes d''aerodrome'),
(797, 21481, 'Immobilisations corporelles - Autres constructions ou rehabilitations - Voies - Operation budgetaire'),
(798, 472124, 'Imputation provisoire de depenses - Budget General - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(799, 472125, 'Imputation provisoire de depenses - Budget General - Comptables non centralisateurs - Domaine'),
(800, 472222, 'Imputation provisoire de depenses - Budgets Annexes - Comptables non centralisateurs - Centre Fiscal'),
(801, 2158, 'Autres constructions ou rehabilitations ? Reseaux'),
(802, 21671, 'Immobilisations corporelles - Outillages - Operation budgetaire'),
(803, 2172, 'Vehicules terrestres'),
(804, 47288, 'Autres'),
(805, 473118, 'Depenses avant ordonnancement - Budget General - Comptables Centralisateurs - Autres'),
(806, 473124, 'Depenses avant ordonnancement - Budget General - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(807, 427311, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Numeraire - Ordre de paiement - Exercice en cours'),
(808, 427413, 'Personnel - Oppositions - Fonds de contre valeur - Numeraire - Ordre de paiement - N-2'),
(809, 427811, 'Personnel - Oppositions - Autres - Numeraire - Ordre de paiement - Exercice en cours'),
(810, 427812, 'Personnel - Oppositions - Autres - Numeraire - Ordre de paiement - N-1'),
(811, 427824, 'Personnel - Oppositions - Autres - Virement - Avis de credit - N-3'),
(812, 451132, 'Comptabilites distinctes rattachees - Budgets annexes - Parcs et ateliers des Travaux Publics - Investissement'),
(813, 45225, 'Correspondants - Etablissements Publics Nationaux - OHE'),
(814, 45282, 'Correspondants - Autres correspondants - OPCI - Organismes Publics de Cooperation inter-Communale'),
(815, 45283, 'Correspondants - Collectivites Territoriales Decentralisees - Autres - Operations des ex-Fivondronana'),
(816, 453112, 'Comptes de depots sans interets - Budget General - Regies d''avances - Electricite - Cash power'),
(817, 45312, 'Comptes de depots sans interets - Comptes Particuliers du Tresor'),
(818, 4628, 'Autres consignations'),
(819, 4631, 'Remise sur les obligations cautionnees'),
(820, 4636, 'Operations d''encaissement diverses'),
(821, 463624, 'Operations d''encaissement diverses - Departement des mines'),
(822, 4638, 'Autres'),
(823, 4658, 'Autres'),
(824, 46761, 'Autres debiteurs - Societes d''Etat'),
(825, 46762, 'Autres debiteurs - Societes privees'),
(826, 46771, 'Autres crediteurs - Provisions de delegation de credits'),
(827, 4691, 'Annulation de creances'),
(828, 4695, 'Annulation de debet des comptables'),
(829, 185128, 'Compte de liaison a l''initiative des ACD - Depenses - Autres'),
(830, 1852, 'Compte de liaison a l''initiative de l''ACCPDC'),
(831, 1909, 'Solde negatif'),
(832, 20131, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Assistance technique - Operation budgetaire'),
(833, 2051, 'Concessions et droits similaires'),
(834, 20511, 'Immobilisations incorporelles - Concessions et droits similaires - Operation budgetaire'),
(835, 21111, 'Immobilisations corporelles - Terrains nus - Operation budgetaire'),
(836, 2112, 'Terrains batis'),
(837, 4713118, 'Recettes percues avant emission de titre - Budget General - Comptables centralisateurs - Autres operations'),
(838, 4713121, 'Recettes percues avant emission de titre - Budget General - Comptables non centralisateurs - Douanes'),
(839, 4713123, 'Recettes percues avant emission de titre - Budget General - Comptables non centralisateurs - Perception Principale'),
(840, 4713125, 'Recettes percues avant emission de titre - Budget General - Comptables non centralisateurs - Domaines'),
(841, 4713126, 'Recettes percues avant emission de titre - Budget General - Comptables non centralisateurs - Topographie'),
(842, 471321, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables centralisateurs'),
(843, 4713225, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables non centralisateurs - Domaines'),
(844, 4713424, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(845, 4713425, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables non centralisateurs - Domaine'),
(846, 4713426, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables non centralisateurs - Topographie'),
(847, 47211, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs'),
(848, 21161, 'Immobilisations corporelles - Cimetieres - Operation budgetaire'),
(849, 21181, 'Immobilisations corporelles - Autres - Operation budgetaire'),
(850, 21212, 'Immobilisations corporelles - Amenagement de terrain - Operation d''ordre'),
(851, 21381, 'Immobilisations corporelles - Autres constructions ou rehabilitations - Batiments - Operation budgetaire'),
(852, 21382, 'Immobilisations corporelles - Autres constructions ou rehabilitations - Batiments - Operation d''ordre'),
(853, 433, 'Caisse de prevoyance et de retraite'),
(854, 242, 'Amenagement'),
(855, 247, 'Materiel de transport'),
(856, 248, 'Autres immobilisations corporelles'),
(857, 474, 'Credits a retablir'),
(858, 478, 'Autres comptes d''attente'),
(859, 632, 'Intervention economique'),
(860, 671, 'Remises gracieuses, degrevement et perte sur titres emis'),
(861, 681, 'Dotations - actifs non courants'),
(862, 729, 'Degrevement, remise, reduction ou annulation'),
(863, 731, 'Droit de douane - DD'),
(864, 463, 'Operations diverses'),
(865, 472, 'Imputation provisoire de depenses'),
(866, 65142, 'Subventions pour les Centres de Sante de Base (CSB)'),
(867, 65144, 'Subvention pour les Ecoles Primaires Publiques (EPP)'),
(868, 655213, 'Transferts pour charges de services public - Autres organismes-Vacation'),
(869, 655613, 'Transfert pour charges d''intervention - Autres organismes-Vacation'),
(870, 65553, 'Transfert pour charges d''intervention - EPIC - Transferts aux organismes public - Bourses et presalaires'),
(871, 65524, 'Transferts pour charges de services public - Autres organismes - Transferts aux organismes public - Subventions d''investissement'),
(872, 77170, 'Droit de poinconnages des lingots d''or'),
(873, 2050, 'Conscession, droit de brevet, Licence'),
(874, 7491, 'Degrevement'),
(875, 7562, 'Aides sur fonds de contre-valeur'),
(876, 7610, 'Produits des prises de participation'),
(877, 7621, 'Revenus des obligations et bons a plus d''un an'),
(878, 411111, 'Redevables - Recettes fiscales - Budget General - Impots sur les revenus, benefices et gains - Exercice en cours'),
(879, 411132, 'Redevables - Recettes fiscales - Budget General - Impots sur le commerce exterieur - Exercices anterieurs'),
(880, 4114, 'Fonds de Contre Valeur'),
(881, 41211, 'Clients et redevables - Recettes non fiscales - Budget General - Redevances'),
(882, 412112, 'Clients et redevables - Recettes non fiscales - Budget General - Redevances - Exercices anterieurs'),
(883, 412142, 'Clients et redevables - Recettes non fiscales - Budget General - Contributions recues des tiers - Exercices anterieurs'),
(884, 41281, 'Clients et redevables - Recettes non fiscales - Autres - Exercice en cours'),
(885, 41282, 'Clients et redevables - Recettes non fiscales - Autres - Exercices anterieurs'),
(886, 41311, 'Droits a percevoir sur obligations cautionnees'),
(887, 7331, 'Taxe d''importations'),
(888, 2813, 'Construction ou rehabilitation - Batiments'),
(889, 2819, 'Immobilisations recues au titre d''une mise a disposition'),
(890, 2841, 'Terrains'),
(891, 2913, 'Constructions ou rehabilitation - Batiments'),
(892, 2914, 'Constructions ou rehabilitation - Voies'),
(893, 2918, 'Autres immobilisations corporelles'),
(894, 2932, 'Perte de valeur sur immobilisations corporelles en cours'),
(895, 3117, 'Habillement'),
(896, 3217, 'Fournitures sportives'),
(897, 3218, 'Fournitures menageres'),
(898, 3410, 'Stocks de marchandises'),
(899, 3811, 'Matieres premieres'),
(900, 3921, 'Fournitures scolaires'),
(901, 3931, 'Carburants et lubrifiants'),
(902, 3933, 'Autres combustibles'),
(903, 3940, 'Stocks de marchandises'),
(904, 7411, 'Droit de timbre sur etats'),
(905, 7413, 'Droit de timbre sur VISA'),
(906, 7483, 'Activites industrielles'),
(907, 6275, 'Location de materiels'),
(908, 6284, 'Assurances'),
(909, 6330, 'Intervention structurelle'),
(910, 6450, 'Impots locaux'),
(911, 6512, 'Provinces autonomes'),
(912, 6521, 'CRCM'),
(913, 6534, 'Prix et recompenses officiels'),
(914, 6540, 'Contributions obligatoires'),
(915, 6565, 'Subvention au secteur prive'),
(916, 6711, 'Remises gracieuses'),
(917, 6718, 'Autres'),
(918, 2488, 'Autres immobilisations corporelles'),
(919, 2520, 'Avances et acomptes verses sur commandes d''immobilisations corporelles'),
(920, 26120, 'Entreprises privees non financieres : Recettes'),
(921, 27219, 'Obligations: Depenses'),
(922, 273129, 'Prets a long et moyen terme : part a moins d''un an - Depenses'),
(923, 2732, 'Retrocession'),
(924, 2738, 'Autres creances immobilisees'),
(925, 2787, 'Interets courus sur avances accordees'),
(926, 2808, 'Autres immobilisations incorporelles'),
(927, 6812, 'Dotations - Charges d''intervention'),
(928, 6856, 'Dotations - Charges financieres'),
(929, 7021, 'Impot sur les revenus non salariaux - IRNS'),
(930, 70241, 'Impot sur les revenus des residents'),
(931, 7040, 'Impots sur les plus values immobilieres - IPVI'),
(932, 7130, 'Taxe sur les vehicules a moteur ? VIGNETTE'),
(933, 7213, 'TVA sur marche public'),
(934, 7232, 'Taxe de consommation'),
(935, 7263, 'Taxe annexe sur les contrats d''assurance des vehicules automobiles'),
(936, 7264, 'Prelevement sur les honoraires des greffiers et notaires'),
(937, 2462, 'Materiels agricoles'),
(938, 24652, 'Immobilisations corporelles en cours - Materiels et mobiliers de logement : Operation d''ordre'),
(939, 2471, 'Renouvellement des vehicules terrestres du parc administratif'),
(940, 24781, 'Immobilisations corporelles en cours - Autres moyens de locomotion : Operation budgetaire'),
(941, 6234, 'Transport administratif'),
(942, 7852, 'Reprise sur intervention'),
(943, 8021, 'Avals, cautions et garanties'),
(944, 86114, 'Cheques carburants et lubrifiants'),
(945, 401822, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Virement - Avis de credit'),
(946, 4018812, 'Fournisseurs et comptes rattaches - Autres : Numeraire - Bons de caisse : N-1'),
(947, 4018813, 'Fournisseurs et comptes rattaches - Autres : Numeraire - Bons de caisse : N-2'),
(948, 4018814, 'Fournisseurs et comptes rattaches - Autres : Numeraire - Bons de caisse : N-3'),
(949, 4018822, 'Fournisseurs et comptes rattaches - Autres : Virement - Avis de credit : N-1'),
(950, 405113, 'Transferts et subventions - Budget General : Numeraire - Bons de caisse - N-2'),
(951, 4052, 'Budgets Annexes'),
(952, 405213, 'Transferts et subventions - Budgets Annexes - Numeraire - Bons de caisse - N-2'),
(953, 405322, 'Transferts et subventions - Comptes Particuliers du Tresor - Virement - Avis de credit - N-1'),
(954, 405324, 'Transferts et subventions - Comptes Particuliers du Tresor - Virement - Avis de credit - N-3'),
(955, 40812, 'Fournisseurs : Depenses d''immobilisations - Budget General - Virement - Avis de credit'),
(956, 408214, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Numeraire - Bons de caisse - Exercice en cours - N-3'),
(957, 408221, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Virement - Avis de credit - Exercice en cours'),
(958, 4083, 'Comptes Particuliers du Tresor'),
(959, 408311, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Numeraire - Bons de caisse - Exercice en cours'),
(960, 4084814, 'N-3'),
(961, 4088, 'Autres'),
(962, 408824, 'Fournisseurs : Depenses d''immobilisations - Autres - Virement - Avis de credit - N-3'),
(963, 409212, 'Creanciers ordinaires ? Comptes debiteurs - Regies d''avances non regularisees - Budget General - Gendarmerie Nationale'),
(964, 40922, 'Creanciers ordinaires ? Comptes debiteurs - Regies d''avances non regularisees - Budgets Annexes'),
(965, 41111, 'Redevables - Recettes fiscales - Budget General - Impots sur les revenus, benefices et gains'),
(966, 18231, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres TG/ TP de rattachement'),
(967, 1823113, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Numeraire - Domaines'),
(968, 1823114, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Numeraire - Topographie'),
(969, 182312, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Cheques'),
(970, 18232, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres d''un comptable public (autres que TG/TP de rattachement)'),
(971, 18312, 'Compte de liaison entre ACCT/DP et TG/TP - Operation concernant le compte courant du Tresor a la Banque Centrale - Compte courant en devises'),
(972, 18351, 'Remises des agents du Tresor'),
(973, 1013, 'Dotations : autres collectivites ou organismes publics'),
(974, 10611, 'Fonds de reserves des budgets annexes'),
(975, 10618, 'Autres reserves des budgets annexes'),
(976, 1068, 'Autres reserves'),
(977, 181121, 'Compte de liaison a l''initiative du PP - Pensions'),
(978, 1811213, 'Pensions francaises'),
(979, 181124, 'Compte de liaison a l''initiative du PP - Depenses - Frais de justice criminelle'),
(980, 181128, 'Compte de liaison a l''initiative du PP - Depenses - Autres'),
(981, 181311, 'Compte de liaison entre TG/TP et PP - Numeraire'),
(982, 181331, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Numeraire'),
(983, 182112, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Centre Fiscal'),
(984, 1821148, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Topographie - Autres'),
(985, 18222, 'Compte de liaison a l''initiative du TG/TP - Depenses'),
(986, 1841112, 'Compte de liaison entre TG/TP - Transferts de recettes - Budget General - Recettes sans titre'),
(987, 18412, 'Compte de liaison entre TG/TP - Transferts de recettes - Correspondants du Tresor'),
(988, 18418, 'Compte de liaison entre TG/TP - Autres transferts de recettes'),
(989, 184212, 'Compte de liaison entre TG/TP - Transferts de depenses - Comptes Particuliers du Tresor'),
(990, 1842121, 'Compte de liaison entre TG/TP - Transferts de depenses - Comptes Particuliers du Tresor - Caisse de Retraite Civile et Militaire (CRCM)'),
(991, 184213, 'Comptes Particuliers du Tresor'),
(992, 184288, 'Compte de liaison entre TG/TP - Transferts de depenses - Autres'),
(993, 18512, 'Compte de liaison a l''initiative des ACD - Depenses'),
(994, 1216, 'Resultat sur operations de tresorerie'),
(995, 13123, 'Subventions d''equipement recues - Commune'),
(996, 1423, 'Batiments'),
(997, 1424, 'Voies'),
(998, 1427, 'Materiels de transport'),
(999, 161119, 'Bons: Depenses'),
(1000, 413121, 'Droits a percevoir sur quittance en portefeuille - Centre Fiscal'),
(1001, 77138, 'Autres redevances'),
(1002, 77143, 'Prelevements sur les extractions des terres, sables, pierres'),
(1003, 77145, 'Droits de delivrance des tickets de mutation'),
(1004, 7721, 'Prestation de service'),
(1005, 401112, 'Fournisseurs et comptes rattaches - Budget General : Numeraire - Bons de caisse : N-1'),
(1006, 40121, 'Fournisseurs et comptes rattaches - Budgets Annexes : Numeraire - Bons de caisse'),
(1007, 401314, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Numeraire - Bons de caisse : N-3'),
(1008, 4014, 'Fonds de Contre Valeur'),
(1009, 401413, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Numeraire - Bons de caisse : N-2'),
(1010, 4018211, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Numeraire - Bons de caisse - Exercice en cours'),
(1011, 7723, 'Produits intermediaires'),
(1012, 77271, 'Droits d''entree dans les sites touristiques'),
(1013, 7736, 'Frais de poursuites'),
(1014, 7737, 'Amendes et condamnations pecuniaires'),
(1015, 7761, 'Variation des en-cours de production de services'),
(1016, 7762, 'Variation des en-cours de production de biens'),
(1017, 7775, 'Confiscations'),
(1018, 7786, 'Boni sur reprise d''emballage'),
(1019, 7791, 'Degrevement'),
(1020, 7792, 'Remise et reduction'),
(1021, 2441, 'Routes'),
(1022, 24412, 'Immobilisations corporelles en cours - Routes - Operation d''ordre'),
(1023, 24431, 'Immobilisations corporelles en cours - Voies d''eau - Operation budgetaire'),
(1024, 6013, 'Personnel membre des Institutions'),
(1025, 6023, 'Personnel membre des Institutions'),
(1026, 6042, 'Personnel non permanent'),
(1027, 6113, 'Consomptibles informatiques'),
(1028, 6122, 'Consommables medicaux'),
(1029, 6225, 'Frais de colloques, seminaires, conferences'),
(1030, 6227, 'Activites sportives et culturelles'),
(1031, 4161, 'Comptes d''affectations speciales'),
(1032, 41611, 'Redevables - Comptes d''affectations speciales - Exercice en cours'),
(1033, 41612, 'Redevables - Comptes d''affectations speciales - Exercices anterieurs'),
(1034, 41621, 'Redevables - Comptes de commerce - Exercice en cours'),
(1035, 41671, 'Redevables - Comptes de participation - Exercice en cours'),
(1036, 41672, 'Redevables - Comptes de participation - Exercices anterieurs'),
(1037, 41913, 'Clients - Avances et acomptes recus - Tresor'),
(1038, 421221, 'Personnel : Salaires et accessoires - Budgets Annexes - Virement - Avis de credit - Exercice en cours'),
(1039, 4738, 'Autres'),
(1040, 4763, 'Augmentation des dettes a long et moyen terme'),
(1041, 4786, 'Depenses a classer et a regulariser'),
(1042, 478613, 'Transfert'),
(1043, 478614, 'Envoi de fonds'),
(1044, 478626, 'Depenses a classer et a regulariser - Comptables non centralisateurs - Topographie'),
(1045, 47865, 'Pensions francaises'),
(1046, 4787131, 'Transfert mandataire - Recettes en instance d''envoi'),
(1047, 2223, 'Construction ou rehabilitation - Batiments'),
(1048, 23132, 'Operation d''ordre'),
(1049, 23161, 'Operation budgetaire'),
(1050, 2317, 'Frais de pre exploitation'),
(1051, 23172, 'Loyer, eau, electricite, telephone, redevance'),
(1052, 2413, 'Terrains de gisement'),
(1053, 2415, 'Terrains de voiries'),
(1054, 24151, 'Immobilisations corporelles en cours - Terrains de voiries - Operation budgetaire'),
(1055, 478714, 'Envoi de fonds'),
(1056, 4787143, 'Envoi de fonds en faveur des Regies Financieres (sous compte ouvert a la Banque Centrale)'),
(1057, 4787144, 'Degagement de fonds des Regies Financieres aupres des Perceptions Principales'),
(1058, 47873, 'Transfert'),
(1059, 4870, 'Produits constates d''avance'),
(1060, 5080, 'Autres valeurs mobilieres de placement et creances assimilees'),
(1061, 5111, 'BCM - Compte courant du Tresor'),
(1062, 511128, 'BCM - Comptes speciaux du Tresor - Autres comptes en devises'),
(1063, 5121, 'CCP - Compte courant'),
(1064, 5128, 'CCP - Autres comptes'),
(1065, 5161, 'Organismes financiers - Compte courant'),
(1066, 5169, 'Organismes financiers - Solde crediteur'),
(1067, 24251, 'Immobilisations corporelles en cours - Amenagement - Travaux d''urbanisme - Operation budgetaire'),
(1068, 24282, 'Immobilisations corporelles en cours - Autres amenagements - Operation d''ordre'),
(1069, 421224, 'Personnel : Salaires et accessoires - Budgets Annexes - Virement - Avis de credit - N-3'),
(1070, 42123, 'Personnel : Salaires et accessoires - Budgets Annexes - Mandat de tresorerie'),
(1071, 421311, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Numeraire - Bons de caisse - Exercice en cours'),
(1072, 421313, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Numeraire - Bons de caisse - N-2'),
(1073, 42143, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Virement - Mandat de tresorerie'),
(1074, 421821, 'Personnel : Salaires et accessoires - Autres - Virement - Avis de credit - Exercice en cours'),
(1075, 421823, 'Personnel : Salaires et accessoires - Autres - Virement - Avis de credit - N-2'),
(1076, 42511, 'Budget Principal'),
(1077, 4271, 'Budget General'),
(1078, 427111, 'Personnel - Oppositions - Budget General - Numeraire - Ordre de paiement - Exercice en cours'),
(1079, 427121, 'Personnel - Oppositions - Budget General - Virement - Avis de credit - Exercice en cours'),
(1080, 427211, 'Personnel - Oppositions - Budgets Annexes - Numeraire - Ordre de paiement - Exercice en cours'),
(1081, 427214, 'Personnel - Oppositions - Budgets Annexes - Numeraire - Ordre de paiement - N-3'),
(1082, 161219, 'Avances de la Banque Centrale: Depenses'),
(1083, 1710, 'Dettes rattachees a des participations'),
(1084, 24542, 'Immobilisations corporelles en cours - Reseau de communication : Operation d''ordre'),
(1085, 2175, 'Materiel naval'),
(1086, 2178, 'Autres moyens de locomotion'),
(1087, 473324, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Agence Comptable des Postes Diplomatiques et Consulaires'),
(1088, 473325, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Domaines'),
(1089, 21442, 'Immobilisations corporelles - Pistes d''aerodrome - Operation d''ordre'),
(1090, 472118, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - - Paiements a imputer - Dette interieure - Autres'),
(1091, 472224, 'Imputation provisoire de depenses - Budgets Annexes - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(1092, 47228, 'Imputation provisoire de depenses - Budgets Annexes - Comptables non centralisateurs - Autres'),
(1093, 47231, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables centralisateurs'),
(1094, 21562, 'Immobilisations corporelles - Reseau d''irrigation - Operation d''ordre'),
(1095, 2157, 'Installations, agencements et amenagements ? Reseaux'),
(1096, 21611, 'Immobilisations corporelles - Materiels techniques - Operation budgetaire'),
(1097, 21642, 'Immobilisations corporelles - Materiels et mobiliers de bureau - Operation d''ordre'),
(1098, 2166, 'Materiels et mobiliers scolaires'),
(1099, 2168, 'Autres materiels et outillages'),
(1100, 21682, 'Immobilisations corporelles - Autres materiels et outillages - Operation d''ordre'),
(1101, 2173, 'Materiel fluvial'),
(1102, 473112, 'Depenses avant ordonnancement - Budget General - Comptables Centralisateurs - Armee'),
(1103, 473122, 'Depenses avant ordonnancement - Budget General - Comptables non centralisateurs - Centre Fiscal'),
(1104, 42742, 'Personnel - Oppositions - Fonds de contre valeur - Virement - Avis de credit'),
(1105, 427813, 'Personnel - Oppositions - Autres - Numeraire - Ordre de paiement - N-2'),
(1106, 427814, 'Personnel - Oppositions - Autres - Numeraire - Ordre de paiement - N-3'),
(1107, 427821, 'Personnel - Oppositions - Autres - Virement - Avis de credit - Exercice en cours'),
(1108, 4336, 'CPR - Bon de caisse'),
(1109, 451122, 'Comptabilites distinctes rattachees - Budgets annexes - Garage administratif - Investissement'),
(1110, 45223, 'Correspondants - Etablissements Publics Nationaux - Academie Malagasy'),
(1111, 4531, 'Comptes de depots sans interets'),
(1112, 46218, 'Autres'),
(1113, 46313, 'Remise sur les obligations cautionnees - Tresor'),
(1114, 4633, 'Amende et condamnations apres jugement'),
(1115, 4634, 'Amende et transaction avant jugement'),
(1116, 46341, 'Amende et transactions avant jugement - Douanes'),
(1117, 46345, 'Amende et transactions avant jugement - Departement des mines'),
(1118, 46351, 'Part des porteurs de contraintes - Douanes'),
(1119, 4651, 'Comptables du Tresor'),
(1120, 4652, 'Comptables des regies financieres'),
(1121, 46763, 'Autres debiteurs - Banques'),
(1122, 46768, 'Autres debiteurs - Autres'),
(1123, 4686, 'Divers - Charges a payer'),
(1124, 4698, 'Autres'),
(1125, 4711, 'Versement par les regisseurs'),
(1126, 47131, 'Recettes percues avant emission de titre - Budget General'),
(1127, 1853, 'Compte de transfert entre ACCPDC et ACPDC : Envoi de fonds'),
(1128, 1861, 'Biens et prestations de services echanges entre Etablissements (charges)'),
(1129, 2011, 'Formation'),
(1130, 2015, 'Etudes et recherches'),
(1131, 20151, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Etudes et recherches - Operation budgetaire'),
(1132, 20173, 'Fournitures et services'),
(1133, 2080, 'Autres immobilisations incorporelles'),
(1134, 21121, 'Immobilisations corporelles - Terrains batis - Operation budgetaire'),
(1135, 472111, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - Paiements a imputer - Dette interieure'),
(1136, 4721111, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - Paiements a imputer - Dette interieure - Interets servis a la souscription des titres d''emprunts'),
(1137, 4721112, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - Paiements a imputer - Dette interieure - Commissions d''intervention des Banques'),
(1138, 21151, 'Immobilisations corporelles - Terrains de voiries - Operation budgetaire'),
(1139, 2122, 'Amenagement des aerodromes'),
(1140, 21232, 'Immobilisations corporelles - Amenagement des Ports - Operation d''ordre'),
(1141, 2124, 'Travaux d''irrigation'),
(1142, 21321, 'Immobilisations corporelles - Batiments scolaires - Operation budgetaire'),
(1143, 21331, 'Immobilisations corporelles - Batiments de centres de soins de sante - Operation budgetaire'),
(1144, 2138, 'Autres constructions ou rehabilitations ? Batiments'),
(1145, 21411, 'Immobilisations corporelles - Routes - Operation budgetaire'),
(1146, 21412, 'Immobilisations corporelles - Routes - Operation d''ordre'),
(1147, 214, 'Construction ou Rehabilitation : Voies'),
(1148, 284, 'Amortissements des immobilisations recues en affectation'),
(1149, 361, 'Produits en cours et travaux en cours'),
(1150, 396, 'Perte sur en-cours de production de biens'),
(1151, 121, 'Resultat budgetaire de l''annee'),
(1152, 147, 'Cession d''immobilisations financieres'),
(1153, 162, 'Emprunts en devises'),
(1154, 673, 'Deficits budgets annexes'),
(1155, 727, 'Taxes particulieres sur les activites'),
(1156, 732, 'Droit de navigation'),
(1157, 738, 'Recettes accessoires et accidentelles'),
(1158, 461, 'Creances sur cession d''immobilisation'),
(1159, 28, 'Amortissement des immobilisations'),
(1160, 7488, 'Autres'),
(1161, 7572, 'Aides sur FCV'),
(1162, 411122, 'Redevables - Recettes fiscales - Budget General - Impots sur les biens et services - Exercices anterieurs'),
(1163, 4118, 'Autres'),
(1164, 412121, 'Clients et redevables - Recettes non fiscales - Budget General - Produits des activites des services - Exercice en cours'),
(1165, 412131, 'Clients et redevables - Recettes non fiscales - Budget General - Produits des activites annexes et accessoires - Exercice en cours'),
(1166, 412132, 'Clients et redevables - Recettes non fiscales - Budget General - Produits des activites annexes et accessoires - Exercices anterieurs'),
(1167, 41218, 'Clients et redevables - Recettes non fiscales - Budget General - Autres'),
(1168, 4124, 'Fonds de Contre Valeur'),
(1169, 413111, 'Droits a percevoir sur obligations cautionnees - Centre Fiscal'),
(1170, 7310, 'Droit de douane - DD'),
(1171, 2811, 'Terrains'),
(1172, 2814, 'Construction ou rehabilitation - Voies'),
(1173, 2817, 'Materiel de transport'),
(1174, 2842, 'Amenagement'),
(1175, 2952, 'Obligations et bons a plus d''un an'),
(1176, 3112, 'Imprimes, cachets et documents administratifs'),
(1177, 3116, 'Instruments specialises'),
(1178, 3312, 'Gaz'),
(1179, 3922, 'Consommables medicaux'),
(1180, 3928, 'Fournitures menageres'),
(1181, 3983, 'Emballages'),
(1182, 7360, 'Droits d''accise sur le commerce exterieur'),
(1183, 7391, 'Degrevement'),
(1184, 7431, 'Amendes fiscales'),
(1185, 6340, 'Maintien de l''ordre'),
(1186, 6380, 'Depenses d''intervention diverses et imprevues'),
(1187, 6411, 'I.R.S.A.'),
(1188, 6480, 'Impots, taxes et droits divers'),
(1189, 6522, 'CPR'),
(1190, 6528, 'Autres'),
(1191, 6618, 'Autres charges d''interet'),
(1192, 6742, 'Frais de contentieux'),
(1193, 26129, 'Entreprises privees non financieres : Depenses'),
(1194, 2614, 'Etablissements publics'),
(1195, 2661, 'Entreprises publiques non financieres'),
(1196, 2663, 'Entreprises financieres'),
(1197, 2665, 'Organismes internationaux'),
(1198, 2686, 'Interets courus sur creances rattachees a des participations'),
(1199, 2692, 'Entreprises privees non financieres'),
(1200, 273119, 'Prets a long et moyen terme : part a plus d''un an - Depenses'),
(1201, 2734, 'Autres titres representatifs de droits de creances'),
(1202, 27340, 'Autres titres representatifs de droits de creances : Recettes'),
(1203, 2740, 'Droits de souscription aux organismes internationaux'),
(1204, 27729, 'Avances retrocessions aux operateurs: Depenses'),
(1205, 2805, 'Concessions et droits similaires, brevets, licences, marques'),
(1206, 6760, 'Fonds speciaux'),
(1207, 6811, 'Dotations - Charges de fonctionnement'),
(1208, 7030, 'Impot sur le revenu des capitaux mobiliers - IRCM'),
(1209, 7050, 'Taxe forfaitaire sur les transferts - TFT'),
(1210, 7092, 'Remise et reduction'),
(1211, 7115, 'Taxe proportionnelle speciale ? TPS'),
(1212, 7192, 'Remise et reduction'),
(1213, 7220, 'Taxe sur les transactions - TST'),
(1214, 7252, 'Prelevement sur les boissons alcooliques et alcoolisees'),
(1215, 24622, 'Immobilisations corporelles en cours - Materiels agricoles : Operation d''ordre'),
(1216, 24631, 'Immobilisations corporelles en cours - Materiels informatiques : Operation budgetaire'),
(1217, 24661, 'Immobilisations corporelles en cours - Materiels et mobiliers scolaires : Operation budgetaire'),
(1218, 24671, 'Immobilisations corporelles en cours - Outillages : Operation budgetaire'),
(1219, 24711, 'Immobilisations corporelles en cours - Renouvellement des vehicules du parc administratif : Operation budgetaire'),
(1220, 24722, 'Immobilisations corporelles en cours - Materiel automobile : Operation d''ordre'),
(1221, 24732, 'Immobilisations corporelles en cours - Materiel fluvial : Operation d''ordre'),
(1222, 6261, 'Frais postaux'),
(1223, 86112, 'Valeurs afferentes au Service de l''Enregistrement et du timbre'),
(1224, 86132, 'Vignettes'),
(1225, 4051, 'Budget General'),
(1226, 40512, 'Transferts et subventions - Budget General : Virement - Avis de credit'),
(1227, 405212, 'Transferts et subventions - Budgets Annexes - Numeraire - Bons de caisse - N-1'),
(1228, 405311, 'Transferts et subventions - Comptes Particuliers du Tresor : Numeraire - Bons de caisse - Exercice en cours'),
(1229, 405313, 'Transferts et subventions - Comptes Particuliers du Tresor : Numeraire - Bons de caisse - Exercice en cours - N-2'),
(1230, 405424, 'Transferts et subventions - Fonds de Contre Valeur - Virement - Avis de credit - N-3'),
(1231, 40581, 'Transferts et subventions - Autres : Numeraire - Bons de caisse'),
(1232, 408111, 'Fournisseurs : Depenses d''immobilisations - Budget General - Numeraire - Bons de caisse - Exercice en cours'),
(1233, 40822, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Virement - Avis de credit'),
(1234, 408322, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Virement - Avis de credit - N-1'),
(1235, 408414, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Numeraire - Bons de caisse - N-3'),
(1236, 40881, 'Fournisseurs : Depenses d''immobilisations - Autres - Numeraire - Bons de caisse'),
(1237, 408813, 'Fournisseurs : Depenses d''immobilisations - Autres - Numeraire - Bons de caisse - N-2'),
(1238, 408821, 'Fournisseurs : Depenses d''immobilisations - Autres - Virement - Avis de credit - Exercice en cours'),
(1239, 40921, 'Creanciers ordinaires ? Comptes debiteurs - Regies d''avances non regularisees - Budget General'),
(1240, 1823134, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Traites - Topographie'),
(1241, 1823324, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Cheques - Topographie'),
(1242, 182341, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres d''une Banque Primaire - Numeraire'),
(1243, 183511, 'Compte de liaison entre ACCT/DP et TG/TP - Transfert de tresorerie - Remises sur recouvrement'),
(1244, 1200, 'Resultat comptable de l''exercice ? Excedent'),
(1245, 1212, 'Resultat des Budgets Annexes'),
(1246, 1811231, 'Compte de liaison a l''initiative du PP - Depenses - Ordre de paiement : Avances de solde'),
(1247, 18131, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres TG/ TP de rattachement'),
(1248, 18133, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale'),
(1249, 18134, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres d''une Banque Primaire'),
(1250, 18136, 'Compte de liaison entre TG/TP et PP - Virement a effectuer par le TG/TP de rattachement'),
(1251, 181361, 'Compte de liaison entre TG/TP et PP - Virement a effectuer par le TG/TP de rattachement - Virement bancaire'),
(1252, 1821111, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Douanes - Budget General'),
(1253, 1821118, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Douanes - Autres'),
(1254, 18221, 'Compte de liaison a l''initiative du TG/TP - Recettes'),
(1255, 1838, 'Autres operations de transfert entre ACCTDP et TG/TP'),
(1256, 1842122, 'Compte de liaison entre TG/TP - Transferts de depenses - Comptes Particuliers du Tresor - Caisse de Prevoyance de Retraite (CPR)'),
(1257, 184221, 'Compte de liaison entre TG/TP - Transferts de depenses - Correspondants du Tresor - Collectivites Territoriales Decentralisees'),
(1258, 18428, 'Compte de liaison entre TG/TP - Transferts de depenses - Autres transferts de depenses'),
(1259, 18432, 'Compte de liaison entre TG/TP - Envoi de fonds - Cheques'),
(1260, 18511, 'Compte de liaison a l''initiative des ACD - Recettes'),
(1261, 1312, 'Subvention recue des Collectivites Territoriales Decentralisees'),
(1262, 13128, 'Subventions d''equipement recues - Autres collectivites'),
(1263, 1611, 'Emprunts a long et moyen terme : part a plus d''un an'),
(1264, 161129, 'Obligations: Depenses'),
(1265, 4131112, 'Droits a percevoir sur obligations cautionnees - Centre Fiscal - Exercices anterieurs'),
(1266, 413112, 'Droits a percevoir sur obligations cautionnees - Douanes'),
(1267, 413118, 'Droits a percevoir sur obligations cautionnees - Autres'),
(1268, 41312, 'Droits a percevoir sur quittance en portefeuille'),
(1269, 4131211, 'Droits a percevoir sur quittance en portefeuille - Centre Fiscal - Exercice en cours'),
(1270, 4131212, 'Droits a percevoir sur quittance en portefeuille - Centre Fiscal - Exercices anterieurs'),
(1271, 7642, 'Revenus des prets a court terme'),
(1272, 7715, 'Redevances versees par les fermiers et concessionnaires'),
(1273, 772112, 'Droit de parking'),
(1274, 77212, 'Prise de reproduction de plan'),
(1275, 772123, 'Droit de reconciliation'),
(1276, 401123, 'Fournisseurs et comptes rattaches - Budget General : Virement - Avis de credit : N-2'),
(1277, 401212, 'Fournisseurs et comptes rattaches - Budgets Annexes : Numeraire - Bons de caisse - N-1'),
(1278, 40122, 'Fournisseurs et comptes rattaches - Budgets Annexes : Virement - Avis de credit'),
(1279, 4018113, 'Fournisseurs et comptes rattaches - Frais de justice criminelle : Numeraire - Bons de caisse - N-2'),
(1280, 4018121, 'Fournisseurs et comptes rattaches - Frais de justice criminelle - Virement - Avis de credit - Exercice en cours'),
(1281, 4018124, 'Fournisseurs et comptes rattaches - Frais de justice criminelle - Virement - Avis de credit - N-3'),
(1282, 4018212, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Numeraire - Bons de caisse - N-1'),
(1283, 4018213, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Numeraire - Bons de caisse - N-2'),
(1284, 77272, 'Droits de sejour des etrangers dans les zones administratives'),
(1285, 7778, 'Autre produits divers de gestion'),
(1286, 7781, 'Annulation des mandats'),
(1287, 7811, 'Reprise sur fonctionnement'),
(1288, 24371, 'Immobilisations corporelles en cours - Installations, agencements et amenagements - Batiments - Operation budgetaire'),
(1289, 24411, 'Immobilisations corporelles en cours - Routes - Operation budgetaire'),
(1290, 24471, 'Immobilisations corporelles en cours - Installations, agencements et amenagements - Voies : Operation budgetaire'),
(1291, 24472, 'Immobilisations corporelles en cours - Installations, agencements et amenagements - Voies : Operation d''ordre'),
(1292, 5198, 'Interets courus sur mobilisation de creances commerciales'),
(1293, 5411, 'Budget General'),
(1294, 5412, 'Budgets Annexes'),
(1295, 5811, 'Virement de fonds'),
(1296, 5818, 'Autres virements internes'),
(1297, 6021, 'Personnel permanent'),
(1298, 6061, 'Cotisations a la CNAPS'),
(1299, 6068, 'Autres charges sociales patronales'),
(1300, 6117, 'Habillement'),
(1301, 6162, 'Variation des stocks de biens a usage specifique'),
(1302, 6182, 'Achats de marchandises destinees a etre revendues'),
(1303, 6184, 'Achat de materiaux de construction'),
(1304, 6218, 'Autres entretiens et Maintenances'),
(1305, 6224, 'Impression, reliures, insertions, publicite et promotion'),
(1306, 4131281, 'Droits a percevoir sur quittance en portefeuille - Autres - Exercice en cours'),
(1307, 4132, 'Effets a recevoir - Recettes non fiscales'),
(1308, 4151, 'Recettes fiscales'),
(1309, 41661, 'Redevables - Comptes de reprets - Exercice en cours'),
(1310, 41912, 'Clients - Avances et acomptes recus - Douanes'),
(1311, 41923, 'Clients et redevables - Trop percu - Tresor'),
(1312, 4211, 'Budget General'),
(1313, 421113, 'Personnel : Salaires et accessoires - Budget General - Numeraire - Bons de caisse - N-2'),
(1314, 421121, 'Personnel : Salaires et accessoires - Budget General - Virement - Avis de credit - Exercice en cours'),
(1315, 421213, 'Personnel : Salaires et accessoires - Budgets Annexes - Numeraire - Bons de caisse - N-2'),
(1316, 473425, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables non centralisateurs - Domaine'),
(1317, 473428, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables non centralisateurs - Autres'),
(1318, 4761, 'Diminution des creances a long et moyen terme'),
(1319, 4772, 'Augmentation des creances a court terme'),
(1320, 47861, 'Depenses a classer et a regulariser - Comptables Centralisateurs'),
(1321, 478611, 'Depenses en attente de regularisation a l''ACCTDP'),
(1322, 4786132, 'Transfert assignataire - Depenses recues en instance de couverture'),
(1323, 478638, 'Autres'),
(1324, 478643, 'Approvisionnement ou degagement de caisse en fin d''annee'),
(1325, 2233, 'Construction ou rehabilitation - Batiments'),
(1326, 2234, 'Construction ou rehabilitation - Voies'),
(1327, 2236, 'Installations techniques - Materiel et outillage'),
(1328, 23121, 'Operation budgetaire'),
(1329, 23131, 'Operation budgetaire'),
(1330, 2351, 'Concessions et droits similaires'),
(1331, 23521, 'Immobilisations incorporelles en cours - Brevets, licences, marques - Operation budgetaire'),
(1332, 23802, 'Autres immobilisations incorporelles en cours - Operation d''ordre'),
(1333, 24111, 'Immobilisations corporelles en cours - Terrains nus - Operation budgetaire'),
(1334, 24161, 'Immobilisations corporelles en cours - Cimetieres - Operation budgetaire'),
(1335, 4787141, 'Envoi de fonds ACCT/DP en faveur des Tresoreries Principales via BOA'),
(1336, 478718, 'Autres recettes a classer et a regulariser'),
(1337, 478726, 'Recettes a classer et a regulariser - Comptables non centralisateurs - Topographie'),
(1338, 478731, 'Transfert mandataire - Recettes en instance d''envoi'),
(1339, 4860, 'Charges constatees d''avances'),
(1340, 511113, 'BCM - Compte courant du Tresor en USD'),
(1341, 5119, 'BCM - Solde crediteur'),
(1342, 51721, 'Cheques bancaires remis a l''encaissement'),
(1343, 5177, 'Virement attendu'),
(1344, 24172, 'Immobilisations corporelles en cours - Bois et forets - Operation d''ordre'),
(1345, 421223, 'Personnel : Salaires et accessoires - Budgets Annexes - Virement - Avis de credit - N-2'),
(1346, 4213, 'Comptes Particuliers du Tresor'),
(1347, 42131, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Numeraire - Bons de caisse'),
(1348, 42133, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Mandat de tresorerie'),
(1349, 421423, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Virement - Avis de credit - N-2'),
(1350, 421813, 'Personnel : Salaires et accessoires - Autres - Numeraire - Bons de caisse - N-2'),
(1351, 42521, 'Budget Principal'),
(1352, 4272, 'Budgets Annexes'),
(1353, 4273, 'Comptes Particuliers du Tresor'),
(1354, 42731, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Numeraire - Ordre de paiement'),
(1355, 21711, 'Immobilisations corporelles - Renouvellement des vehicules du parc administratif - Operation budgetaire'),
(1356, 16128, 'Emprunts en Ariary a long et moyen terme : part a moins d''un an - Autres emprunts'),
(1357, 16220, 'Emprunts a long et moyen terme : part a moins d''un an - Recettes'),
(1358, 16229, 'Emprunts a long et moyen terme : part a moins d''un an - Depenses'),
(1359, 1811, 'Compte de liaison a l''initiative du PP'),
(1360, 18111, 'Compte de liaison a l''initiative du PP - Recettes'),
(1361, 24551, 'Immobilisations corporelles en cours - Reseau d''electricite : Operation budgetaire'),
(1362, 2456, 'Reseau d''irrigation'),
(1363, 21782, 'Immobilisations corporelles - Autres moyens de locomotion - Operation d''ordre'),
(1364, 21821, 'Autres immobilisations corporelles - Emballages recuperables - Operation budgetaire'),
(1365, 21832, 'Autres immobilisations corporelles - Installations complexes specialisees - Operation d''ordre'),
(1366, 2188, 'Autres immobilisations corporelles'),
(1367, 4733, 'Comptes Particuliers du Tresor'),
(1368, 21422, 'Immobilisations corporelles - Voies ferrees - Operation d''ordre'),
(1369, 21431, 'Immobilisations corporelles - Voies d''eau - Operation budgetaire'),
(1370, 21432, 'Immobilisations corporelles - Voies d''eau - Operation d''ordre'),
(1371, 21441, 'Immobilisations corporelles - Pistes d''aerodrome - Operation budgetaire'),
(1372, 2148, 'Autres constructions ou rehabilitations ? Voies'),
(1373, 21482, 'Immobilisations corporelles - Autres constructions ou rehabilitations - Voies - Operation d''ordre'),
(1374, 47212, 'Imputation provisoire de depenses - Budget General - Comptables non centralisateurs'),
(1375, 4723, 'Comptes Particuliers du Tresor'),
(1376, 472326, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables non centralisateurs - Topographie'),
(1377, 472423, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables non centralisateurs - Perception Principale'),
(1378, 21552, 'Immobilisations corporelles - Reseau d''electricite - Operation d''ordre'),
(1379, 21561, 'Immobilisations corporelles - Reseau d''irrigation - Operation budgetaire'),
(1380, 21571, 'Immobilisations corporelles - Installations, agencements et amenagements - Reseaux - Operation budgetaire'),
(1381, 2162, 'Materiels agricoles'),
(1382, 21661, 'Immobilisations corporelles - Materiels et mobiliers scolaires - Operation budgetaire'),
(1383, 6510, 'Transferts aux collectivites publiques'),
(1384, 21722, 'Immobilisations corporelles - Materiel automobile - Operation d''ordre'),
(1385, 21731, 'Immobilisations corporelles - Materiel fluvial - Operation budgetaire'),
(1386, 472426, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables non centralisateurs - Topographie'),
(1387, 4728, 'Autres'),
(1388, 473221, 'Depenses avant ordonnancement - Budgets Annexes - Comptables non centralisateurs - Douanes'),
(1389, 4274, 'Fonds de Contre Valeur'),
(1390, 427424, 'Personnel - Oppositions - Fonds de contre valeur - Virement - Avis de credit - N-3'),
(1391, 427822, 'Personnel - Oppositions - Autres - Virement - Avis de credit - N-1'),
(1392, 4380, 'Autres organismes'),
(1393, 4431, 'Reversement'),
(1394, 451111, 'Comptabilites distinctes rattachees - Budgets annexes - Imprimerie Nationale - Fonctionnement'),
(1395, 45112, 'Comptabilites distinctes rattachees - Budgets annexes - Garage administratif'),
(1396, 451131, 'Comptabilites distinctes rattachees - Budgets annexes - Parcs et ateliers des Travaux Publics - Fonctionnement'),
(1397, 45114, 'Comptabilites distinctes rattachees - Budgets annexes - Postes et Telecommunications'),
(1398, 451141, 'Comptabilites distinctes rattachees - Budgets annexes - Postes et Telecommunications - Fonctionnement'),
(1399, 451181, 'Comptabilites distinctes rattachees - Budgets annexes - Autres - Fonctionnement'),
(1400, 45212, 'Correspondants - Collectivites Territoriales Decentralisees - Regions'),
(1401, 45221, 'Correspondants - Etablissements Publics Nationaux - Chambre de commerce'),
(1402, 4538, 'Autres'),
(1403, 46311, 'Remise sur les obligations cautionnees - Douanes'),
(1404, 46312, 'Remise sur les obligations cautionnees - Centre Fiscal'),
(1405, 4635, 'Part des porteurs de contraintes'),
(1406, 463621, 'Operations d''encaissement diverses - Douanes'),
(1407, 463627, 'Operations d''encaissement diverses - Departement de la Meteorologie'),
(1408, 1900, 'Solde positif'),
(1409, 2013, 'Assistance technique'),
(1410, 2017, 'Frais de pre-exploitation'),
(1411, 20174, 'Transport et mission'),
(1412, 20182, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes : Autres - Operation d''ordre'),
(1413, 20512, 'Immobilisations incorporelles - Concessions et droits similaires - Operation d''ordre'),
(1414, 20521, 'Immobilisations incorporelles - Brevets, licences, marques - Operation budgetaire'),
(1415, 471312, 'Recettes percues avant emission de titre - Budget General - Comptables non centralisateurs'),
(1416, 47132, 'Recettes percues avant emission de titre - Budgets Annexes'),
(1417, 4713222, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables non centralisateurs - Centre Fiscal'),
(1418, 4713224, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(1419, 4713228, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables non centralisateurs - Autres'),
(1420, 4713323, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables non centralisateurs - Perception Principale'),
(1421, 471341, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables centralisateurs'),
(1422, 471342, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables non centralisateurs'),
(1423, 471348, 'Autres'),
(1424, 4721121, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - Paiements a imputer - Dette exterieure - Contrepartie des tirages de la dette - versement aux comptes des projets ou paiements directs par les bailleurs'),
(1425, 21171, 'Immobilisations corporelles - Bois et forets - Operation budgetaire'),
(1426, 2123, 'Amenagement des Ports'),
(1427, 21342, 'Immobilisations corporelles - Autres batiments techniques - Operation d''ordre'),
(1428, 21371, 'Immobilisations corporelles - Installations, agencements et amenagements - Batiments - Operation budgetaire'),
(1429, 2142, 'Voies ferrees'),
(1430, 453, 'Depots au Tresor'),
(1431, 415, 'Clients et redevables - Creances admises en non valeur'),
(1432, 217, 'Materiel de transport'),
(1433, 201, 'Frais de developpement, de recherche et d''etudes'),
(1434, 774, 'Production immobilisee'),
(1435, 638, 'Depenses d''intervention diverses et imprevues'),
(1436, 643, 'Impots, taxes et droits d''enregistrement'),
(1437, 711, 'Droits sur les actes et mutations - DAM'),
(1438, 718, 'Taxe annuelle sur autres patrimoines'),
(1439, 736, 'Droits d''accise sur le commerce exterieur'),
(1440, 771, 'Redevances'),
(1441, 654, 'Contributions obligatoires'),
(1442, 65141, 'Subvention de fonctionnement'),
(1443, 655111, 'Transferts pour charges de services public - EPA - Salaires et accessoirees'),
(1444, 655511, 'Transfert pour charges d''intervention - EPIC - Salaires et accessoires'),
(1445, 655513, 'Transfert pour charges d''intervention - EPIC-Vacation'),
(1446, 65562, 'Transfert pour charges d''intervention - Autres organismes - Transferts aux organismes public - Subventions de fonctionnement'),
(1447, 7524, 'Etablissements Publics a caractere Administratif'),
(1448, 7581, 'Pensions CPR'),
(1449, 7582, 'Pensions CRCM'),
(1450, 41182, 'Redevables - Recettes fiscales - Autres - Exercices anterieurs'),
(1451, 41212, 'Clients et redevables - Recettes non fiscales - Budget General - Produits des activites des services'),
(1452, 41215, 'Clients et redevables - Recettes non fiscales - Budget General - Produits financiers'),
(1453, 412181, 'Clients et redevables - Recettes non fiscales - Budget General - Autres - Exercice en cours'),
(1454, 4131111, 'Droits a percevoir sur obligations cautionnees - Centre Fiscal - Exercice en cours'),
(1455, 2845, 'Construction ou rehabilitation - Reseaux'),
(1456, 2901, 'Frais de recherche et developpement immobilisables'),
(1457, 2919, 'Immobilisations recues au titre d''une mise a disposition'),
(1458, 2931, 'Perte de valeur sur immobilisations incorporelles en cours'),
(1459, 2953, 'Prets a long et moyen terme'),
(1460, 3313, 'Autres combustibles'),
(1461, 3914, 'Produits, petits materiels'),
(1462, 3915, 'Petit outillage et fournitures d''atelier'),
(1463, 3916, 'Instruments specialises'),
(1464, 3925, 'Produits alimentaires'),
(1465, 3961, 'Produits en cours'),
(1466, 7415, 'Droits de timbre douaniers'),
(1467, 7420, 'Interet sur credit de droit'),
(1468, 7433, 'Interet moratoire'),
(1469, 6274, 'Location de terrain'),
(1470, 6285, 'Services bancaires et assimiles'),
(1471, 6286, 'Cotisations et divers'),
(1472, 6287, 'Personnels exterieurs au service'),
(1473, 6310, 'Intervention sociale'),
(1474, 6418, 'Autres taxes et impots directs'),
(1475, 6632, 'Interets des depots crediteurs'),
(1476, 6730, 'Deficits budgets annexes'),
(1477, 2483, 'Installations complexes specialisees'),
(1478, 24832, 'Immobilisations corporelles en cours - Installations complexes specialisees : Operation d''ordre'),
(1479, 24881, 'Immobilisations corporelles en cours - Installations, agencements et amenagements divers : Operation budgetaire'),
(1480, 2611, 'Entreprises publiques non financieres'),
(1481, 2681, 'Interets courus sur titres de participations et autres formes de participations'),
(1482, 2688, 'Autres'),
(1483, 2698, 'Autres formes de participation'),
(1484, 273110, 'Prets a long et moyen terme : part a plus d''un an - Recettes'),
(1485, 273229, 'Retrocession : part a moins d''un an - Depenses'),
(1486, 27339, 'Prets sur fonds de contre-valeur: Depenses'),
(1487, 27719, 'Avances ordinaires: Depenses'),
(1488, 2783, 'Interets courus sur prets a long et moyen terme'),
(1489, 6816, 'Dotations - Charges financieres'),
(1490, 6851, 'Dotations - Charges de fonctionnement'),
(1491, 70243, 'Impots sur les revenus intermittents'),
(1492, 7091, 'Degrevement'),
(1493, 7211, 'TVA interieure'),
(1494, 7212, 'TVA intermittente'),
(1495, 7255, 'Redevance de surveillance'),
(1496, 7265, 'Taxe sur la publicite'),
(1497, 24571, 'Immobilisations corporelles en cours - Installations, agencements et amenagements - Reseaux : Operation budgetaire'),
(1498, 24581, 'Immobilisations corporelles en cours - Autres constructions ou rehabilitations ? Reseaux : Operation budgetaire'),
(1499, 24621, 'Immobilisations corporelles en cours - Materiels agricoles : Operation budgetaire'),
(1500, 2466, 'Materiels et mobiliers scolaires'),
(1501, 2474, 'Materiel ferroviaire'),
(1502, 24761, 'Immobilisations corporelles en cours - Materiel aerien : Operation budgetaire'),
(1503, 2478, 'Autres moyens de locomotion'),
(1504, 24822, 'Immobilisations corporelles en cours - Emballages recuperables : Operation d''ordre'),
(1505, 6235, 'Transport de biens'),
(1506, 6241, 'Indemnites de mission interieure'),
(1507, 8011, 'Avals, cautions et garanties'),
(1508, 86123, 'Bons du Tresor en provision'),
(1509, 86124, 'Valeurs chez le depositaire - Cheques carburants et lubrifiants'),
(1510, 86128, 'Autres valeurs'),
(1511, 86134, 'Comptes de prise en charge - Cheques carburants et lubrifiants'),
(1512, 4018224, 'Fournisseurs et comptes rattaches - Avis de delegation de credit : Virement - Avis de credit - N-3'),
(1513, 401882, 'Fournisseurs et comptes rattaches - Autres : Virement - Avis de credit'),
(1514, 4018821, 'Fournisseurs et comptes rattaches - Autres : Virement - Avis de credit : Exercice en cours'),
(1515, 405114, 'Transferts et subventions - Budget General : Numeraire - Bons de caisse - N-3'),
(1516, 405221, 'Transferts et subventions - Budgets Annexes - Virement - Avis de credit - Exercice en cours'),
(1517, 40531, 'Transferts et subventions - Comptes Particuliers du Tresor : Numeraire - Bons de caisse'),
(1518, 405314, 'Transferts et subventions - Comptes Particuliers du Tresor : Numeraire - Bons de caisse - Exercice en cours - N-3'),
(1519, 4054, 'Fonds de Contre Valeur'),
(1520, 405412, 'Transferts et subventions - Fonds de Contre Valeur - Numeraire - Bons de caisse - N-1'),
(1521, 405423, 'Transferts et subventions - Fonds de Contre Valeur - Virement - Avis de credit - N-2'),
(1522, 405814, 'Transferts et subventions - Autres : Numeraire - Bons de caisse - N-3'),
(1523, 408121, 'Fournisseurs : Depenses d''immobilisations - Budget General - Virement - Avis de credit - Exercice en cours'),
(1524, 408212, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Numeraire - Bons de caisse - Exercice en cours - N-1'),
(1525, 408223, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Virement - Avis de credit - Exercice en cours - N-2'),
(1526, 408321, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Virement - Avis de credit - Exercice en cours'),
(1527, 408412, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Numeraire - Bons de caisse - N-1'),
(1528, 408413, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Numeraire - Bons de caisse - N-2'),
(1529, 40842, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Virement - Avis de credit'),
(1530, 408424, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Virement - Avis de credit - N-3'),
(1531, 408812, 'Fournisseurs : Depenses d''immobilisations - Autres - Numeraire - Bons de caisse - N-1'),
(1532, 4092, 'Regies d''avances non regularisees'),
(1533, 40928, 'Autres'),
(1534, 4098, 'Rabais, Remises et Ristournes a obtenir'),
(1535, 4099, 'Fournisseurs debiteurs'),
(1536, 18234, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres d''une Banque Primaire'),
(1537, 182342, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres d''une Banque Primaire - Cheques'),
(1538, 1835, 'Transfert de tresorerie'),
(1539, 1017, 'Mises a disposition'),
(1540, 1018, 'Autres'),
(1541, 10612, 'Fonds de renouvellement des budgets annexes'),
(1542, 1064, 'Excedent de fonctionnement capitalise'),
(1543, 1100, 'Report a nouveau crediteur'),
(1544, 1190, 'Report a nouveau solde debiteur'),
(1545, 181125, 'Compte de liaison a l''initiative du PP - Depenses - Decaissements p/c collectivites publiques ou etablissements non geres par le comptable'),
(1546, 1812, 'Compte de liaison a l''initiative du TG/TP'),
(1547, 182111, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Douanes'),
(1548, 1821131, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Domaines - Budget General'),
(1549, 182114, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Topographie'),
(1550, 1836, 'Mise a disposition de fonds au profit des postes comptables via BOA'),
(1551, 1841111, 'Compte de liaison entre TG/TP - Transferts de recettes - Budget General - Recettes sur titre'),
(1552, 1841131, 'Caisse de Retraite Civile et Militaire (CRCM)'),
(1553, 1841132, 'Caisse de Prevoyance de Retraite (CPR)'),
(1554, 1841213, 'Compte de liaison entre TG/TP - Transferts de recettes - Correspondants du Tresor - Collectivites Territoriales Decentralisees - Commune'),
(1555, 184211, 'Compte de liaison entre TG/TP - Transferts de depenses - Budget General'),
(1556, 1842211, 'Compte de liaison entre TG/TP - Transferts de depenses - Correspondants du Tresor - Collectivites Territoriales - Faritany'),
(1557, 1842212, 'Compte de liaison entre TG/TP - Transferts de depenses - Correspondants du Tresor - Collectivites Territoriales - Region'),
(1558, 1842213, 'Compte de liaison entre TG/TP - Transferts de depenses - Correspondants du Tresor - Collectivites Territoriales - Commune'),
(1559, 184282, 'Compte de liaison entre TG/TP - Transferts de depenses - Carburants et lubrifiants'),
(1560, 185111, 'Compte de liaison a l''initiative des ACD - Recettes au profit du Budget General de l''Etat'),
(1561, 185122, 'Compte de liaison a l''initiative des ACD - Depenses - Bons de caisse et mandats de tresorerie'),
(1562, 13134, 'Subvention d''equipement recue - Autres organismes nationaux'),
(1563, 1315, 'Subventions d''equipements recues - Aides multilaterales'),
(1564, 1322, 'Utilisation de FCV en investissement - Aides multilaterales'),
(1565, 1472, 'Remboursements de prets accordes a long et moyen terme'),
(1566, 4131121, 'Droits a percevoir sur obligations cautionnees - Douanes - Exercice en cours'),
(1567, 4131181, 'Droits a percevoir sur obligations cautionnees - Autres - Exercice en cours'),
(1568, 77142, 'Droit de delivrance des passeports bovides'),
(1569, 772111, 'Droit de place sur le marche'),
(1570, 77213, 'Frais de bornage et de reperages'),
(1571, 401114, 'Fournisseurs et comptes rattaches - Budget General : Numeraire - Bons de caisse : N-3'),
(1572, 401223, 'Fournisseurs et comptes rattaches - Budgets Annexes : Virement - Avis de credit : N-2'),
(1573, 401322, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Virement - Avis de credit : N-1'),
(1574, 401423, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Virement - Avis de credit : N-2'),
(1575, 401811, 'Fournisseurs et comptes rattaches - Frais de justice criminelle : Numeraire - Bons de caisse'),
(1576, 40182, 'Fournisseurs et comptes rattaches - Avis de delegation de credit'),
(1577, 77278, 'Autres revenus des domaines des collectivites'),
(1578, 7738, 'Autres'),
(1579, 7741, 'Immobilisation incorporelle'),
(1580, 7774, 'Produits des majorations sur arrieres non fiscaux'),
(1581, 2442, 'Voies ferrees'),
(1582, 24442, 'Immobilisations corporelles en cours - Pistes d''aerodrome - Operation d''ordre'),
(1583, 2451, 'Reseau d''adduction d''eau'),
(1584, 54118, 'Autres'),
(1585, 5451, 'Avances de caisse - Comptable superieur'),
(1586, 54512, 'Avances de caisse - Comptable superieur - Comptable mandataire'),
(1587, 6116, 'Instruments specialises'),
(1588, 6125, 'Produits alimentaires'),
(1589, 6213, 'Entretien de materiels de transports'),
(1590, 6223, 'Documentation et abonnement'),
(1591, 41322, 'Effets a recevoir - Recettes non fiscales - Exercices anterieurs'),
(1592, 4158, 'Autres'),
(1593, 4164, 'Comptes d''avances'),
(1594, 4165, 'Comptes de prets'),
(1595, 41922, 'Clients et redevables - Trop percu - Douanes'),
(1596, 42113, 'Personnel : Salaires et accessoires - Budget General - Mandat de tresorerie'),
(1597, 47342, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables non centralisateurs'),
(1598, 473426, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables non centralisateurs - Topographie'),
(1599, 4771, 'Augmentation des creances a long et moyen terme'),
(1600, 4773, 'Diminution des dettes a long et moyen terme'),
(1601, 4786143, 'Approvisionnement ou degagement de caisse en fin d''annee'),
(1602, 478633, 'Prise en charge rejet de transfert - Depenses'),
(1603, 47866, 'Avance de tresorerie accordee'),
(1604, 2211, 'Terrains'),
(1605, 2229, 'Droit du remettant'),
(1606, 23141, 'Operation budgetaire'),
(1607, 23142, 'Operation d''ordre'),
(1608, 23162, 'Operation d''ordre'),
(1609, 2352, 'Brevets, licences, marques'),
(1610, 2380, 'Autres immobilisations incorporelles'),
(1611, 24112, 'Immobilisations corporelles en cours - Terrains nus - Operation d''ordre'),
(1612, 4787132, 'Transfert assignataire - Recettes recues en instance de couverture'),
(1613, 4787134, 'Transfert de recettes en provenance des Regies Financieres'),
(1614, 478722, 'Recettes a classer et a regulariser - Comptables non centralisateurs - Centre Fiscal'),
(1615, 5040, 'Prets a court terme'),
(1616, 511111, 'BCM - Compte courant du Tresor (en Ariary)'),
(1617, 51112, 'BCM - Comptes speciaux du Tresor'),
(1618, 5118, 'BCM ? Autres'),
(1619, 5167, 'Organismes financiers ? Emission de cheque ou ordre de virement'),
(1620, 5172, 'Cheques remis a l''encaissement'),
(1621, 24212, 'Immobilisations corporelles en cours - Amenagement de terrain - Operation d''ordre'),
(1622, 2422, 'Amenagement des aerodromes'),
(1623, 2423, 'Amenagement des Ports'),
(1624, 24232, 'Immobilisations corporelles en cours - Amenagement des Ports - Operation d''ordre'),
(1625, 2431, 'Batiments administratifs'),
(1626, 24311, 'Immobilisations corporelles en cours - Batiments administratifs - Operation budgetaire'),
(1627, 24322, 'Immobilisations corporelles en cours - Batiments scolaires - Operation d''ordre'),
(1628, 42141, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Bons de caisse'),
(1629, 421424, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Virement - Avis de credit - N-3'),
(1630, 421812, 'Personnel : Salaires et accessoires - Autres - Numeraire - Bons de caisse - N-1'),
(1631, 42512, 'Budgets Annexes'),
(1632, 427212, 'Personnel - Oppositions - Budgets Annexes - Numeraire - Ordre de paiement - N-1'),
(1633, 161280, 'Autres: Recettes'),
(1634, 16219, 'Emprunts a long et moyen terme : part a plus d''un an - Depenses'),
(1635, 1788, 'Interets courus sur dettes rattachees a des participations'),
(1636, 24541, 'Immobilisations corporelles en cours - Reseau de communication : Operation budgetaire'),
(1637, 2455, 'Reseau d''electricite'),
(1638, 24561, 'Immobilisations corporelles en cours - Reseau d''irrigation : Operation budgetaire'),
(1639, 21812, 'Autres immobilisations corporelles - Cheptel - Operation d''ordre'),
(1640, 473223, 'Depenses avant ordonnancement - Budgets Annexes - Comptables non centralisateurs - Perception Principale'),
(1641, 473323, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Perception Principale'),
(1642, 21512, 'Immobilisations corporelles - Reseau d''adduction d''eau - Operation d''ordre'),
(1643, 21521, 'Immobilisations corporelles - Reseau d''assainissement - Operation budgetaire'),
(1644, 2153, 'Reseau telephonique'),
(1645, 47218, 'Imputation provisoire de depenses - Budget General - Comptables non centralisateurs - Autres'),
(1646, 472225, 'Imputation provisoire de depenses - Budgets Annexes - Comptables non centralisateurs - Domaines'),
(1647, 47232, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables non centralisateurs'),
(1648, 472325, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables non centralisateurs - Domaine'),
(1649, 472422, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables non centralisateurs - Centre Fiscal'),
(1650, 21581, 'Immobilisations corporelles - Autres constructions ou rehabilitations ? Reseaux - Operation budgetaire'),
(1651, 21612, 'Immobilisations corporelles - Materiels techniques - Operation d''ordre'),
(1652, 21632, 'Immobilisations corporelles - Materiels informatiques - Operation d''ordre'),
(1653, 21651, 'Immobilisations corporelles - Materiels et mobiliers de logement - Operation budgetaire'),
(1654, 21681, 'Immobilisations corporelles - Autres materiels et outillages - Operation budgetaire'),
(1655, 606, 'Achats non stockes de matieres et fournitures'),
(1656, 281, 'Amortissements des immobilisations corporelles'),
(1657, 472428, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables non centralisateurs - Autres'),
(1658, 473113, 'Depenses avant ordonnancement - Budget General - Comptables Centralisateurs - Gendarmerie Nationale'),
(1659, 21542, 'Immobilisations corporelles - Reseau de communication - Operation d''ordre'),
(1660, 427312, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Numeraire - Ordre de paiement - N-1'),
(1661, 42732, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Virement - Avis de credit'),
(1662, 427324, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Virement - Avis de credit - N-3'),
(1663, 427421, 'Personnel - Oppositions - Fonds de contre valeur - Virement - Avis de credit - Exercice en cours'),
(1664, 427423, 'Personnel - Oppositions - Fonds de contre valeur - Virement - Avis de credit - N-2'),
(1665, 4278, 'Autres'),
(1666, 4337, 'CPR - Retenue et contribution'),
(1667, 451142, 'Comptabilites distinctes rattachees - Budgets annexes - Postes et Telecommunications - Investissement'),
(1668, 4531313, 'Comptes de depots sans interets - Collectivites non dotees d''un comptable du Tresor - Communes'),
(1669, 4534, 'Comptes de depots pour cautions sur marche'),
(1670, 46211, 'Consignations administratives'),
(1671, 46331, 'Amendes et autres elements de condamnation'),
(1672, 46338, 'Autres amendes'),
(1673, 463431, 'Amende et transactions avant jugement - Tresor - Controle des changes'),
(1674, 46361, 'Operations d''encaissement diverses - Particuliers'),
(1675, 46362, 'Operations d''encaissement diverses - Departements ministeriels et autres institutions'),
(1676, 46368, 'Autres'),
(1677, 4653, 'Comptables des collectivites publiques'),
(1678, 46778, 'Autres crediteurs - Autres'),
(1679, 1862, 'Biens et prestations de services echanges entre Etablissements (produits)'),
(1680, 2016, 'Suivi ? Controle ? Evaluation'),
(1681, 20171, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes : Frais de pre-exploitation - Operation budgetaire'),
(1682, 2052, 'Brevets, licences, marques'),
(1683, 21112, 'Immobilisations corporelles - Terrains nus - Operation d''ordre'),
(1684, 21142, 'Immobilisations corporelles - Terrains de chantiers - Operation d''ordre'),
(1685, 4713111, 'Recettes percues avant emission de titre - Budget General - Comptables centralisateurs - Imputation provisoire - Carburant'),
(1686, 471322, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables non centralisateurs'),
(1687, 4713226, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables non centralisateurs - Topographie'),
(1688, 4713288, 'Autres'),
(1689, 4713321, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables non centralisateurs - Douanes'),
(1690, 4713325, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables non centralisateurs - Domaines'),
(1691, 4713328, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables non centralisateurs - Autres'),
(1692, 4713423, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables non centralisateurs - Perception Principale'),
(1693, 4721113, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - Commissions de placement des titres d''emprunts'),
(1694, 4721118, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - - Paiements a imputer - Dette interieure - Autres'),
(1695, 2116, 'Cimetieres'),
(1696, 21281, 'Immobilisations corporelles - Autres amenagements - Operation budgetaire'),
(1697, 2132, 'Batiments scolaires'),
(1698, 21332, 'Immobilisations corporelles - Batiments de centres de soins de sante - Operation d''ordre'),
(1699, 21341, 'Immobilisations corporelles - Autres batiments techniques - Operation budgetaire'),
(1700, 2137, 'Installations, agencements et amenagements ? Batiments'),
(1701, 21372, 'Immobilisations corporelles - Installations, agencements et amenagements - Batiments - Operation d''ordre'),
(1702, 381, 'Autre achats'),
(1703, 244, 'Construction ou Rehabilitation : Voies'),
(1704, 246, 'Materiels et outillages'),
(1705, 185, 'Compte de liaison entre ACCPDC et ACPDC'),
(1706, 776, 'Productions stockees'),
(1707, 778, 'Produits occasionnels'),
(1708, 861, 'Valeurs inactives'),
(1709, 662, 'Interets bancaires et operations de financements a court terme'),
(1710, 675, 'Interets moratoires, amendes et penalites'),
(1711, 712, 'Taxe annuelle sur les vehicules de tourismes des societes ? TSVTS'),
(1712, 724, 'Redevances sur produits'),
(1713, 726, 'Taxes particulieres sur les services'),
(1714, 734, 'TVA sur commerce exterieur'),
(1715, 772, 'Produits des activites des services'),
(1716, 516, 'Organismes financiers'),
(1717, 533, 'Caisse Agences Comptables des Postes Diplomatiques et Consulaires'),
(1718, 471, 'Imputation provisoire de recettes'),
(1719, 655512, 'Transfert pour charges d''intervention - EPIC-Heures complementaires'),
(1720, 65512, 'Transferts pour charges de services public - EPA - Transferts aux organismes public - Subventions de fonctionnement'),
(1721, 65552, 'Transfert pour charges d''intervention - EPIC - Transferts aux organismes public - Subventions de fonctionnement'),
(1722, 65528, 'Transferts pour charges de services public - Autres organismes - Transferts aux organismes public - Autres transferts'),
(1723, 41112, 'Redevables - Recettes fiscales - Budget General - Impots sur les biens et services'),
(1724, 2812, 'Amenagement'),
(1725, 2843, 'Construction ou rehabilitation - Batiments'),
(1726, 2916, 'Materiel et outillage'),
(1727, 2957, 'Avances accordees'),
(1728, 3711, 'Produits intermediaires'),
(1729, 3927, 'Fournitures sportives'),
(1730, 7340, 'TVA sur commerce exterieur'),
(1731, 7380, 'Recettes accessoires et accidentelles'),
(1732, 7412, 'Droit de timbre CASINO'),
(1733, 6282, 'Frais d''etudes, de recherches, de stage et de formation'),
(1734, 6412, 'Taxe sur les vignettes automobiles'),
(1735, 6420, 'Taxes et impots indirects'),
(1736, 6531, 'Bourses a Madagascar'),
(1737, 6551, 'Transferts pour charges de services public - EPA'),
(1738, 6562, 'Secours'),
(1739, 6681, 'Interets des autres dettes'),
(1740, 6682, 'Autres charges financieres'),
(1741, 2612, 'Entreprises privees non financieres'),
(1742, 2613, 'Entreprises financieres'),
(1743, 2695, 'Organismes internationaux'),
(1744, 27229, 'Bons: Depenses'),
(1745, 2731, 'Prets'),
(1746, 273120, 'Prets a long et moyen terme : part a moins d''un an - Recettes'),
(1747, 27330, 'Prets sur fonds de contre-valeur: Recettes'),
(1748, 2781, 'Interets courus sur obligations et bons'),
(1749, 6781, 'Moins values sur cessions d''immobilisations'),
(1750, 7060, 'Taxes d''incorporation'),
(1751, 7193, 'Annulation'),
(1752, 72311, 'Droit d''accise interieur'),
(1753, 7240, 'Redevances sur produits'),
(1754, 273219, 'Retrocession : part a plus d''un an - Depenses'),
(1755, 7291, 'Degrevement'),
(1756, 24572, 'Immobilisations corporelles en cours - Installations, agencements et amenagements - Reseaux : Operation d''ordre'),
(1757, 2464, 'Materiels et mobiliers de bureau'),
(1758, 24642, 'Immobilisations corporelles en cours - Materiels et mobiliers de bureau : Operation d''ordre'),
(1759, 24651, 'Immobilisations corporelles en cours - Materiels et mobiliers de logement : Operation budgetaire'),
(1760, 24721, 'Immobilisations corporelles en cours - Materiel automobile : Operation budgetaire'),
(1761, 24731, 'Immobilisations corporelles en cours - Materiel fluvial : Operation budgetaire'),
(1762, 24742, 'Immobilisations corporelles en cours - Materiel ferroviaire : Operation d''ordre'),
(1763, 24821, 'Immobilisations corporelles en cours - Emballages recuperables : Operation budgetaire'),
(1764, 6264, 'Internet'),
(1765, 6268, 'Autres'),
(1766, 6272, 'Location d''immeuble de logement'),
(1767, 8012, 'Engagement sur marches pluriannuels des projets'),
(1768, 401824, 'N-3'),
(1769, 40188, 'Autres'),
(1770, 401881, 'Fournisseurs et comptes rattaches - Autres : Numeraire - Bons de caisse'),
(1771, 405111, 'Transferts et subventions - Budget General : Numeraire - Bons de caisse - Exercice en cours'),
(1772, 40522, 'Transferts et subventions - Budgets Annexes - Virement - Avis de credit'),
(1773, 405224, 'Transferts et subventions - Budgets Annexes - Virement - Avis de credit - N-3'),
(1774, 4053, 'Comptes Particuliers du Tresor'),
(1775, 405414, 'Transferts et subventions - Fonds de Contre Valeur - Numeraire - Bons de caisse - N-3'),
(1776, 40542, 'Transferts et subventions - Fonds de Contre Valeur - Virement - Avis de credit'),
(1777, 408122, 'Fournisseurs : Depenses d''immobilisations - Budget General - Virement - Avis de credit - N-1'),
(1778, 408123, 'Fournisseurs : Depenses d''immobilisations - Budget General - Virement - Avis de credit - N-2'),
(1779, 4082, 'Budgets Annexes'),
(1780, 408224, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Virement - Avis de credit - Exercice en cours - N-3'),
(1781, 40831, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Numeraire - Bons de caisse'),
(1782, 40832, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Virement - Avis de credit'),
(1783, 40841, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Numeraire - Bons de caisse'),
(1784, 408421, 'Fournisseurs : Depenses d''immobilisations - Fonds de contre valeur - Virement - Avis de credit - Exercice en cours'),
(1785, 408814, 'Fournisseurs : Depenses d''immobilisations - Autres - Numeraire - Bons de caisse - N-3'),
(1786, 409211, 'Creanciers ordinaires ? Comptes debiteurs - Regies d''avances non regularisees - Budget General - Armee'),
(1787, 40923, 'Creanciers ordinaires ? Comptes debiteurs - Regies d''avances non regularisees - Comptes particuliers du Tresor'),
(1788, 1823132, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Traites - Centre Fiscal'),
(1789, 1823133, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Traites - Domaines'),
(1790, 1823312, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Numeraire - Centre Fiscal'),
(1791, 1823314, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Numeraires - Topographie'),
(1792, 1823321, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale - Cheques - Douanes'),
(1793, 10613, 'Fonds de roulement des budgets annexes'),
(1794, 1811112, 'Compte de liaison a l''initiative du PP - Recettes au profit du Budget General de l''Etat : Recettes percues sans titre'),
(1795, 181112, 'Compte de liaison a l''initiative du PP - Recettes au profit des collectivites ou etablissements publics non geres'),
(1796, 181118, 'Compte de liaison a l''initiative du PP - Autres recettes'),
(1797, 1811232, 'Compte de liaison a l''initiative du PP - Depenses - Ordre de paiement - Avis de delegation de credit'),
(1798, 1813, 'Envoi de fonds et reglement de tresorerie entre comptables'),
(1799, 181312, 'Compte de liaison entre TG/TP et PP - Cheques'),
(1800, 181341, 'Compte de liaison entre TG/TP et PP - Envoi de fonds et reglement de tresorerie aupres d''une Banque Primaire - Numeraire'),
(1801, 181362, 'Compte de liaison entre TG/TP et PP - Virement a effectuer par le TG/TP de rattachement - Virement postal'),
(1802, 1821, 'Compte de liaison a l''initiative du Receveur des Administrations Financieres'),
(1803, 1821121, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Centre Fiscal - Budget General'),
(1804, 1821122, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Centre Fiscal - Impots locaux'),
(1805, 1841, 'Compte de liaison entre TG/TP : Transferts de recettes'),
(1806, 184112, 'Compte de liaison entre TG/TP - Transferts de recettes - Comptes Particuliers du Tresor'),
(1807, 1841122, 'Compte de liaison entre TG/TP - Transferts de recettes - Comptes Particuliers du Tresor - Caisse de Prevoyance de Retraite (CPR)'),
(1808, 184113, 'Compte de liaison entre TG/TP - Transferts de recettes - Budgets annexes'),
(1809, 184121, 'Compte de liaison entre TG/TP - Transferts de recettes - Correspondants du Tresor - Collectivites Territoriales Decentralisees'),
(1810, 1842, 'Compte de liaison entre TG/TP : Transferts de depenses'),
(1811, 1842113, 'Compte de liaison entre TG/TP - Transferts de depenses - Budget General - Frais de justice criminelle'),
(1812, 185121, 'Compte de liaison a l''initiative des ACD - Depenses - Pensions'),
(1813, 1851212, 'Compte de liaison a l''initiative des ACD - Depenses - Pensions malagasy'),
(1814, 1478, 'Autres immobilisations financieres'),
(1815, 1560, 'Provisions pour renouvellement des immobilisations (concession)'),
(1816, 4131182, 'Droits a percevoir sur obligations cautionnees - Autres - Exercices anterieurs'),
(1817, 4131222, 'Droits a percevoir sur quittance en portefeuille - Douanes - Exercices anterieurs'),
(1818, 7641, 'Revenus des obligations et bons a court terme'),
(1819, 77141, 'Taxes sur les ceremonies coutumieres (famadihana, lanonana, ?)'),
(1820, 77148, 'Autre redevance sur autorisation administrative'),
(1821, 7716, 'Droits de poinconnage des bijoux'),
(1822, 77211, 'Droits gradues'),
(1823, 772122, 'Droit douche publique'),
(1824, 401124, 'Fournisseurs et comptes rattaches - Budget General : Virement - Avis de credit : N-3'),
(1825, 4012, 'Budgets Annexes'),
(1826, 401222, 'Fournisseurs et comptes rattaches - Budgets Annexes : Virement - Avis de credit : N-1'),
(1827, 401312, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Numeraire - Bons de caisse : N-1'),
(1828, 4018122, 'Fournisseurs et comptes rattaches - Frais de justice criminelle - Virement - Avis de credit - N-1'),
(1829, 77218, 'Autres prestations de service'),
(1830, 7727, 'Revenus des domaines de l''Etat'),
(1831, 7731, 'Commissions et courtages'),
(1832, 7733, 'Produits des majorations sur arrieres non fiscaux'),
(1833, 7772, 'Quote-part de resultat sur operations faites en commun'),
(1834, 7773, 'Quotes-parts de subvention d''equipement virees au compte de resultat'),
(1835, 7783, 'Excedents budgets annexes'),
(1836, 24372, 'Immobilisations corporelles en cours - Installations, agencements et amenagements - Batiments - Operation d''ordre'),
(1837, 24382, 'Immobilisations corporelles en cours - Autres constructions ou rehabilitations - Batiments - Operation d''ordre'),
(1838, 24432, 'Immobilisations corporelles en cours - Voies d''eau - Operation d''ordre'),
(1839, 24512, 'Immobilisations corporelles en cours - Reseau d''adduction d''eau : Operation d''ordre'),
(1840, 5310, 'Caisse TG/TP'),
(1841, 5340, 'Caisse Regies des Administrations Financieres'),
(1842, 54511, 'Avances de caisse - Comptable superieur - Comptable assignataire'),
(1843, 6012, 'Personnel non permanent'),
(1844, 6064, 'Cotisations aux OSIE'),
(1845, 6111, 'Fournitures et articles de bureau'),
(1846, 6114, 'Produits, petits materiels et menues depenses d''entretien'),
(1847, 6123, 'Produits pharmaceutiques'),
(1848, 6126, 'Intrants agricoles'),
(1849, 6127, 'Fournitures sportives'),
(1850, 6217, 'Maintenance des reseaux, logiciels et systemes informatiques'),
(1851, 6226, 'Foires et expositions'),
(1852, 41381, 'Effets a recevoir - Autres - Exercice en cours'),
(1853, 41382, 'Effets a recevoir - Autres - Exercices anterieurs'),
(1854, 4141, 'Clients - Creances douteuses'),
(1855, 4142, 'Redevables - Creances douteuses'),
(1856, 41651, 'Redevables - Comptes de prets - Exercice en cours'),
(1857, 41652, 'Redevables - Comptes de prets - Exercices anterieurs'),
(1858, 41662, 'Redevables - Comptes de reprets - Exercices anterieurs'),
(1859, 42111, 'Personnel : Salaires et accessoires - Budget General - Numeraire - Bons de caisse'),
(1860, 421111, 'Personnel : Salaires et accessoires - Budget General - Numeraire - Bons de caisse - Exercice en cours'),
(1861, 161180, 'Autres emprunts: Recettes'),
(1862, 473422, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables non centralisateurs - Centre Fiscal'),
(1863, 4741, 'Credits a retablir apres recouvrement des trop payes'),
(1864, 4786131, 'Transfert mandataire - Depenses en instance d''envoi'),
(1865, 4786138, 'Autres'),
(1866, 478621, 'Depenses a classer et a regulariser - Comptables non centralisateurs - Douanes'),
(1867, 478628, 'Depenses a classer et a regulariser - Comptables non centralisateurs - Autres'),
(1868, 478631, 'Transfert mandataire - Depenses en instance d''envoi'),
(1869, 47868, 'Autres depenses a classer et a regulariser'),
(1870, 478713, 'Transfert'),
(1871, 21881, 'Autres immobilisations corporelles - Installations, agencements et amenagements divers - Operation budgetaire'),
(1872, 2218, 'Autres immobilisations corporelles'),
(1873, 2228, 'Autres immobilisations corporelles'),
(1874, 2238, 'Autres immobilisations corporelles'),
(1875, 23152, 'Operation d''ordre'),
(1876, 23181, 'Immobilisations incorporelles en cours - Frais de developpement, de recherche et d''etudes - Autres - Operation budgetaire'),
(1877, 23182, 'Immobilisations incorporelles en cours - Frais de developpement, de recherche et d''etudes - Autres - Operation d''ordre'),
(1878, 23511, 'Immobilisations incorporelles en cours - Concessions et droits similaires - Operation budgetaire'),
(1879, 23801, 'Autres immobilisations incorporelles en cours - Operation budgetaire'),
(1880, 2417, 'Bois et forets'),
(1881, 47872, 'Recettes a classer et a regulariser - Comptables non centralisateurs'),
(1882, 478732, 'Transfert assignataire - Recettes recues en instance de couverture'),
(1883, 478738, 'Autres'),
(1884, 4792, 'Compte d''ordre ? Apurement des soldes anormaux'),
(1885, 4810, 'Provisions ? passifs courants'),
(1886, 4910, 'Perte de valeur sur les comptes des redevables'),
(1887, 5010, 'Obligations et bons a court terme'),
(1888, 51111, 'BCM - Compte courant du Tresor'),
(1889, 511112, 'BCM - Compte courant du Tresor en Euro'),
(1890, 5147, 'Interets courus a recevoir'),
(1891, 5168, 'Organismes financiers - Autres comptes'),
(1892, 51728, 'Autres cheques'),
(1893, 24171, 'Immobilisations corporelles en cours - Bois et forets - Operation budgetaire'),
(1894, 2418, 'Autres'),
(1895, 24341, 'Immobilisations corporelles en cours - Autres batiments techniques - Operation budgetaire'),
(1896, 421314, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Numeraire - Bons de caisse - N-3'),
(1897, 421322, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Virement - Avis de credit - N-1'),
(1898, 42142, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Virement - Avis de credit'),
(1899, 421824, 'Personnel : Salaires et accessoires - Autres - Virement - Avis de credit - N-3'),
(1900, 42522, 'Budgets Annexes'),
(1901, 427113, 'Personnel - Oppositions - Budget General - Numeraire - Ordre de paiement - N-2'),
(1902, 2181, 'Cheptel'),
(1903, 2182, 'Emballages recuperables'),
(1904, 473225, 'Depenses avant ordonnancement - Budgets Annexes - Comptables non centralisateurs - Domaine'),
(1905, 2143, 'Voies d''eau'),
(1906, 2147, 'Installations, agencements et amenagements ? Voies'),
(1907, 2152, 'Reseau d''assainissement'),
(1908, 21531, 'Immobilisations corporelles - Reseau telephonique - Operation budgetaire'),
(1909, 4721122, 'Imputation provisoire de depenses - Budget General - Comptables centralisateurs - Paiements a imputer - Dette exterieure - Interets, commissions et frais bancaire'),
(1910, 472221, 'Imputation provisoire de depenses - Budgets Annexes - Comptables non centralisateurs - Douanes'),
(1911, 472223, 'Imputation provisoire de depenses - Budgets Annexes - Comptables non centralisateurs - Perception Principale'),
(1912, 472226, 'Imputation provisoire de depenses - Budgets Annexes - Comptables non centralisateurs - Topographie'),
(1913, 472322, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables non centralisateurs - Centre Fiscal'),
(1914, 47241, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables centralisateurs'),
(1915, 472424, 'Imputation provisoire de depenses - Fonds de Contre Valeur - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(1916, 2161, 'Materiels techniques'),
(1917, 21621, 'Immobilisations corporelles - Materiels agricoles - Operation budgetaire'),
(1918, 21631, 'Immobilisations corporelles - Materiels informatiques - Operation budgetaire'),
(1919, 2164, 'Materiels et mobiliers de bureau'),
(1920, 21641, 'Immobilisations corporelles - Materiels et mobiliers de bureau - Operation budgetaire'),
(1921, 2165, 'Materiels et mobiliers de logement'),
(1922, 21712, 'Immobilisations corporelles - Renouvellement des vehicules du parc administratif - Operation d''ordre'),
(1923, 21721, 'Immobilisations corporelles - Materiel automobile - Operation budgetaire'),
(1924, 47311, 'Depenses avant ordonnancement - Budget General - Comptables Centralisateurs'),
(1925, 473123, 'Depenses avant ordonnancement - Budget General - Comptables non centralisateurs - Perception Principale'),
(1926, 473125, 'Depenses avant ordonnancement - Budget General - Comptables non centralisateurs - Domaine'),
(1927, 473128, 'Depenses avant ordonnancement - Budget General - Comptables non centralisateurs - Autres'),
(1928, 47321, 'Depenses avant ordonnancement - Budgets Annexes - Comptables Centralisateurs'),
(1929, 21541, 'Immobilisations corporelles - Reseau de communication - Operation budgetaire'),
(1930, 427314, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Numeraire - Ordre de paiement - N-3'),
(1931, 427322, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Virement - Avis de credit - N-1'),
(1932, 427411, 'Personnel - Oppositions - Fonds de contre valeur - Numeraire - Ordre de paiement - Exercice en cours'),
(1933, 427414, 'Personnel - Oppositions - Fonds de contre valeur - Numeraire - Ordre de paiement - N-3'),
(1934, 427422, 'Personnel - Oppositions - Fonds de contre valeur - Virement - Avis de credit - N-1'),
(1935, 42781, 'Personnel - Oppositions - Autres - Numeraire - Ordre de paiement'),
(1936, 4282, 'Personnel - Produits a recevoir'),
(1937, 4326, 'CRCM - Bon de caisse a payer'),
(1938, 4412, 'Aides remboursables a recevoir'),
(1939, 4422, 'FCV - Subventions multilaterales a utiliser'),
(1940, 45182, 'Comptabilites distinctes rattachees - Autres - Operations avec la CNaPS'),
(1941, 453111, 'Comptes de depots sans interets - Budget General - Regies d''avances - Telephone prepayee'),
(1942, 4623, 'Produits de desherences'),
(1943, 46346, 'Amende et transactions avant jugement - Departement de la peche et des Ressources Halieutiques'),
(1944, 46348, 'Amende et transactions avant jugement - Autres'),
(1945, 463626, 'Departement de la Peche et des Ressources Halieutiques'),
(1946, 46764, 'Autres debiteurs - Particuliers'),
(1947, 1851231, 'Compte de liaison a l''initiative des ACD - Depenses - Ordre de paiement - Avances de solde'),
(1948, 2012, 'Animation et encadrement'),
(1949, 20121, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Animation et encadrement - Operation budgetaire'),
(1950, 20175, 'Entretien et reparation'),
(1951, 20181, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes : Autres - Operation budgetaire'),
(1952, 21132, 'Immobilisations corporelles - Terrains de gisement - Operation d''ordre'),
(1953, 21141, 'Immobilisations corporelles - Terrains de chantiers - Operation budgetaire'),
(1954, 4713124, 'Recettes percues avant emission de titre - Budget General - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(1955, 4713422, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables non centralisateurs - Centre Fiscal'),
(1956, 21172, 'Immobilisations corporelles - Bois et forets - Operation d''ordre'),
(1957, 21182, 'Immobilisations corporelles - Autres - Operation d''ordre'),
(1958, 21221, 'Immobilisations corporelles - Amenagement des aerodromes - Operation budgetaire'),
(1959, 21241, 'Immobilisations corporelles - Travaux d''irrigation - Operation budgetaire'),
(1960, 2134, 'Autres batiments techniques'),
(1961, 184, 'Compte de liaison entre TG/TP'),
(1962, 280, 'Amortissement des immobilisations incorporelles'),
(1963, 452, 'Correspondants'),
(1964, 412, 'Clients et redevables - Recettes non fiscales'),
(1965, 235, 'Concessions et droits similaires, brevets, licences, marques'),
(1966, 251, 'Avances et acomptes verses sur commandes d''immobilisations incorporelles'),
(1967, 492, 'Perte de valeur sur les comptes de clients'),
(1968, 777, 'Produits divers'),
(1969, 802, 'Engagements recus'),
(1970, 642, 'Taxes et impots indirects'),
(1971, 672, 'Reversement sur trop percu'),
(1972, 674, 'Frais de justice et de contentieux'),
(1973, 725, 'Taxes particulieres sur certains biens'),
(1974, 735, 'TVA sur produits petroliers'),
(1975, 749, 'Degrevement, remise, reduction ou annulation'),
(1976, 520, 'Instruments de tresorerie'),
(1977, 532, 'Caisse PP'),
(1978, 545, 'Avances de caisse'),
(1979, 68, 'DOTATIONS AUX AMORTISSEMENTS, AUX PROVISIONS POUR CHARGE ET PERTE DE VALEUR'),
(1980, 65143, 'Subvention pour les Secretaires d''etat civil (SEC)'),
(1981, 655112, 'Transferts pour charges de services public - EPA-Heures complementaires'),
(1982, 65522, 'Transferts pour charges de services public - Autres organismes - Transferts aux organismes public - Subventions de fonctionnement'),
(1983, 65523, 'Transferts pour charges de services public - Autres organismes - Transferts aux organismes public - Bourses et presalaires'),
(1984, 65563, 'Transfert pour charges d''intervention - Autres organismes - Transferts aux organismes public - Bourses et presalaires'),
(1985, 65564, 'Transfert pour charges d''intervention - Autres organismes - Transferts aux organismes public - Subventions d''investissement'),
(1986, 65568, 'Transfert pour charges d''intervention - Autres organismes - Transferts aux organismes public - Autres transferts'),
(1987, 65511, 'Transfert pour charges d''intervention - EPA - Transferts aux organismes public - Salaires et accessoires'),
(1988, 77160, 'Droit de poinconnages des bijoux'),
(1989, 7493, 'Annulation'),
(1990, 7528, 'Autres Collectivites Publiques'),
(1991, 41113, 'Redevables - Recettes fiscales - Budget General - Impots sur le commerce exterieur'),
(1992, 411181, 'Redevables - Recettes fiscales - Budget General - Autres recettes fiscales - Exercice en cours'),
(1993, 41141, 'Redevables - Recettes fiscales - Fonds de contre valeur - Exercice en cours'),
(1994, 41214, 'Clients et redevables - Recettes non fiscales - Budget General - Contributions recues des tiers'),
(1995, 41216, 'Clients et redevables - Recettes non fiscales - Budget General - Dons et legs'),
(1996, 41221, 'Clients et redevables - Recettes non fiscales - Budgets Annexes - Exercice en cours'),
(1997, 4128, 'Autres'),
(1998, 7332, 'Taxe statistique a l''importation'),
(1999, 2815, 'Construction ou rehabilitation - Reseaux'),
(2000, 2958, 'Autres immobilisations financieres'),
(2001, 3215, 'Produits alimentaires'),
(2002, 3216, 'Intrants agricoles'),
(2003, 3972, 'Produits finis'),
(2004, 7392, 'Remise et reduction'),
(2005, 6281, 'Remunerations d''intermediaire et honoraires'),
(2006, 6430, 'Impots, taxes et droits d''enregistrement'),
(2007, 6541, 'Contribution internationale'),
(2008, 6552, 'Transferts pour charges de services public - Autres organismes'),
(2009, 6688, 'Autres charges financieres'),
(2010, 24831, 'Immobilisations corporelles en cours - Installations complexes specialisees : Operation budgetaire'),
(2011, 2615, 'Organismes internationaux'),
(2012, 2618, 'Autres formes de participation'),
(2013, 2693, 'Entreprises financieres'),
(2014, 27321, 'Retrocession : part a plus d''un an'),
(2015, 27322, 'Retrocession : part a moins d''un an'),
(2016, 2733, 'Prets sur fonds de contre-valeur'),
(2017, 2801, 'Frais de recherche et developpement immobilisables'),
(2018, 7023, 'Impot synthetique - IS'),
(2019, 7025, 'Impot direct sur les hydrocarbures - IDH'),
(2020, 7111, 'Droits sur les actes et mutations a titre onereux - DAMTO'),
(2021, 7114, 'Droits sur les actes et mutations a titre gratuit - DAMTG'),
(2022, 7180, 'Taxe annuelle sur autres patrimoines'),
(2023, 24582, 'Immobilisations corporelles en cours - Autres constructions ou rehabilitations ? Reseaux : Operation d''ordre'),
(2024, 2463, 'Materiels informatiques, electriques, electroniques et telephoniques'),
(2025, 24741, 'Immobilisations corporelles en cours - Materiel ferroviaire : Operation budgetaire'),
(2026, 2475, 'Materiel naval'),
(2027, 2476, 'Materiel aerien'),
(2028, 6243, 'Viatique'),
(2029, 6250, 'Eau et electricite'),
(2030, 6265, 'Telex'),
(2031, 6266, 'Frais de location de boite postale'),
(2032, 7851, 'Reprise sur fonctionnement'),
(2033, 7856, 'Reprise financiere'),
(2034, 8612, 'Valeurs chez le regisseur'),
(2035, 86138, 'Autres valeurs'),
(2036, 4018823, 'Fournisseurs et comptes rattaches - Autres : Virement - Avis de credit : N-2'),
(2037, 405112, 'Transferts et subventions - Budget General : Numeraire - Bons de caisse - N-1'),
(2038, 405121, 'Transferts et subventions - Budget General : Virement - Avis de credit - Exercice en cours'),
(2039, 405124, 'Transferts et subventions - Budget General : Virement - Avis de credit - N-3'),
(2040, 405312, 'Transferts et subventions - Comptes Particuliers du Tresor : Numeraire - Bons de caisse - Exercice en cours - N-1'),
(2041, 405321, 'Transferts et subventions - Comptes Particuliers du Tresor - Virement - Avis de credit - Exercice en cours'),
(2042, 405323, 'Transferts et subventions - Comptes Particuliers du Tresor - Virement - Avis de credit - N-2'),
(2043, 40541, 'Transferts et subventions - Fonds de Contre Valeur - Numeraire - Bons de caisse'),
(2044, 405411, 'Transferts et subventions - Fonds de Contre Valeur - Numeraire - Bons de caisse - Exercice en cours'),
(2045, 4081, 'Budget General'),
(2046, 408113, 'Fournisseurs : Depenses d''immobilisations - Budget General - Numeraire - Bons de caisse - N-2'),
(2047, 408211, 'Fournisseurs : Depenses d''immobilisations - Budgets Annexes - Numeraire - Bons de caisse - Exercice en cours'),
(2048, 408313, 'Fournisseurs : Depenses d''immobilisations - Comptes Particuliers du Tresor - Numeraire - Bons de caisse - N-2'),
(2049, 408822, 'Fournisseurs : Depenses d''immobilisations - Autres - Virement - Avis de credit - N-1'),
(2050, 4111, 'Budget General'),
(2051, 1823123, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Cheques - Domaines'),
(2052, 1823124, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie - Cheques - Topographie'),
(2053, 1823131, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie -Traites - Douanes'),
(2054, 1823311, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres de la Banque Centrale -Numeraire - Douanes'),
(2055, 182343, 'Compte de liaison entre TP et receveurs des administrations financieres - Envoi de fonds et reglement de tresorerie aupres d''une Banque Primaire - Virement'),
(2056, 1016, 'Dons et legs en capital'),
(2057, 1209, 'Resultat comptable de l''exercice ? Deficit'),
(2058, 1211, 'Resultat du Budget General de l''Etat'),
(2059, 1214, 'Resultat des operations sur FCV'),
(2060, 1811212, 'Compte de liaison a l''initiative du PP - Depenses - Caisse de Prevoyance de Retraite (CPR)'),
(2061, 18121, 'Compte de liaison a l''initiative du TG/TP - Recettes'),
(2062, 2235, 'Construction ou rehabilitation - Reseaux'),
(2063, 18211, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes'),
(2064, 182113, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Domaines'),
(2065, 1821138, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Domaines - Autres'),
(2066, 1821142, 'Compte de liaison a l''initiative du receveur des administrations financieres - Recettes : Topographie - Impots locaux'),
(2067, 1821221, 'Budget General'),
(2068, 1837, 'Transfert operations de fin d''annee'),
(2069, 18411, 'Compte de liaison entre TG/TP - Transferts de recettes - Budget General de l''Etat'),
(2070, 1841138, 'Autres comptes particuliers du Tresor'),
(2071, 184123, 'Compte de liaison entre TG/TP - Transferts de recettes - Correspondants du Tresor - Depot des particuliers'),
(2072, 184188, 'Compte de liaison entre TG/TP - Autres transferts de recettes - Autres'),
(2073, 18421, 'Compte de liaison entre TG/TP - Transferts de depenses - Budget General de l''Etat'),
(2074, 18421121, 'Compte de liaison entre TG/TP - Transferts de depenses - Budget General - Ordre de paiement - Avances de solde'),
(2075, 184222, 'Compte de liaison entre TG/TP - Transferts de depenses - Correspondants du Tresor - Etablissements Publics'),
(2076, 184223, 'Compte de liaison entre TG/TP - Transferts de depenses - Correspondants du Tresor - Depots des particuliers'),
(2077, 18433, 'Compte de liaison entre TG/TP - Envoi de fonds - Traites'),
(2078, 13121, 'Subventions d''equipement recues -Faritany'),
(2079, 13122, 'Subventions d''equipement recues - Regions'),
(2080, 1313, 'Subvention recue des Organismes nationaux ou internationaux'),
(2081, 13131, 'Subvention d''equipement recue - Etablissements Publics a caractere'),
(2082, 13135, 'Subvention d''equipement recue - Organismes internationaux'),
(2083, 1318, 'Autres subventions d''equipements recues'),
(2084, 1415, 'Concessions et droits similaires, brevets, licence, marques'),
(2085, 1473, 'Remboursements de prets accordes a court terme'),
(2086, 16118, 'Emprunts en Ariary a long et moyen terme : part a plus d''un an - Autres'),
(2087, 7660, 'Gains de changes'),
(2088, 7713, 'Redevance de surveillance ? RS'),
(2089, 77131, 'Redevance miniere'),
(2090, 772118, 'Autres'),
(2091, 772128, 'Autres'),
(2092, 4011, 'Budget General'),
(2093, 401111, 'Fournisseurs et comptes rattaches - Budget General : Numeraire - Bons de caisse : Exercice en cours'),
(2094, 401121, 'Fournisseurs et comptes rattaches - Budget General : Virement - Avis de credit : Exercice en cours'),
(2095, 401122, 'Fournisseurs et comptes rattaches - Budget General : Virement - Avis de credit : N-1'),
(2096, 401224, 'Fournisseurs et comptes rattaches - Budgets Annexes : Virement - Avis de credit : N-3'),
(2097, 401324, 'Fournisseurs et comptes rattaches - Comptes Particuliers du Tresor : Virement - Avis de credit : N-3'),
(2098, 40141, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Numeraire - Bons de caisse'),
(2099, 401421, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Virement - Avis de credit : Exercice en cours'),
(2100, 401422, 'Fournisseurs et comptes rattaches - Fonds de Contre Valeur : Virement - Avis de credit : N-1'),
(2101, 4018112, 'Fournisseurs et comptes rattaches - Frais de justice criminelle : Numeraire - Bons de caisse - N-1'),
(2102, 4018114, 'Fournisseurs et comptes rattaches - Frais de justice criminelle : Numeraire - Bons de caisse - N-3'),
(2103, 401813, 'N-2'),
(2104, 401814, 'N-3'),
(2105, 7722, 'Produits finis'),
(2106, 7725, 'Travaux'),
(2107, 7735, 'Droits de fourrieres'),
(2108, 7763, 'Variation des stocks de produits'),
(2109, 7784, 'Mise a disposition de personnel'),
(2110, 7812, 'Reprise sur intervention'),
(2111, 2444, 'Pistes d''aerodrome'),
(2112, 2447, 'Installations, agencements et amenagements ? Voies'),
(2113, 24482, 'Immobilisations corporelles en cours - Installations, agencements et amenagements - VoiesAutres constructions ou rehabilitations - Voies : Operation d''ordre'),
(2114, 24511, 'Immobilisations corporelles en cours - Reseau d''adduction d''eau : Operation budgetaire'),
(2115, 2452, 'Reseau d''assainissement'),
(2116, 24521, 'Immobilisations corporelles en cours - Reseau d''assainissement : Operation budgetaire'),
(2117, 2453, 'Reseau telephonique'),
(2118, 54112, 'Gendarmerie Nationale'),
(2119, 5452, 'Comptable subordonne'),
(2120, 6011, 'Personnel permanent'),
(2121, 6062, 'Cotisations caisse de retraites civiles et militaires'),
(2122, 6115, 'Petits outillages et fournitures d''atelier'),
(2123, 6132, 'Gaz'),
(2124, 6138, 'Autres combustibles'),
(2125, 6181, 'Achats de matieres premieres'),
(2126, 6185, 'Achat d''appareils et materiels electro-menagers'),
(2127, 6231, 'Frais de deplacement interieur'),
(2128, 41918, 'Clients - Avances et acomptes recus - Autres'),
(2129, 42112, 'Personnel : Salaires et accessoires - Budget General - Virement - Avis de credit'),
(2130, 42121, 'Personnel : Salaires et accessoires - Budgets Annexes - Numeraire - Bons de caisse'),
(2131, 42122, 'Personnel : Salaires et accessoires - Budgets Annexes - Virement - Avis de credit'),
(2132, 1612, 'Emprunts a long et moyen terme : part a moins d''un an'),
(2133, 47341, 'Depenses avant ordonnancement - Fonds de contre valeur - Comptables Centralisateurs'),
(2134, 4762, 'Diminution des creances a court terme'),
(2135, 4786142, 'Envoi de fonds en faveur des Perceptions Principales via BOA'),
(2136, 478618, 'Autres depenses a classer et a regulariser'),
(2137, 478624, 'Depenses a classer et a regulariser - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(2138, 47863, 'Transfert'),
(2139, 2214, 'Construction ou rehabilitation - Voies'),
(2140, 2215, 'Construction ou rehabilitation - Reseaux'),
(2141, 2224, 'Construction ou rehabilitation - Voies'),
(2142, 2227, 'Materiel de transport'),
(2143, 2232, 'Amenagement'),
(2144, 23173, 'Fournitures et services'),
(2145, 2411, 'Terrains nus'),
(2146, 24132, 'Immobilisations corporelles en cours - Terrains de gisement - Operation d''ordre'),
(2147, 4787133, 'Prise en charge rejet de transfert recettes - Recettes'),
(2148, 478725, 'Recettes a classer et a regulariser - Comptables non centralisateurs - Domaine'),
(2149, 4960, 'Perte de valeur sur les comptes de debiteurs divers'),
(2150, 5030, 'Actions'),
(2151, 511118, 'BCM - Compte courant du Tresor - Autres comptes en devises'),
(2152, 511121, 'BCM - Comptes speciaux du Tresor (en Ariary)'),
(2153, 511123, 'BCM - Comptes speciaux du Tresor en USD'),
(2154, 5117, 'BCM - Emission de cheque BCM ou ordre de virement'),
(2155, 51182, 'BCM - Autres comptes en Euro'),
(2156, 51183, 'BCM - Autres comptes en USD'),
(2157, 51212, 'CCP ? Compte courant (Regisseur)'),
(2158, 5173, 'Versement en attente d''affectation'),
(2159, 24211, 'Immobilisations corporelles en cours - Amenagement de terrain - Operation budgetaire'),
(2160, 24242, 'Immobilisations corporelles en cours - Amenagement - Travaux d''irrigation - Operation d''ordre'),
(2161, 2428, 'Autres amenagements'),
(2162, 24312, 'Immobilisations corporelles en cours - Batiments administratifs - Operation d''ordre'),
(2163, 2433, 'Batiments de centres de soins de sante'),
(2164, 42132, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Virement - Avis de credit'),
(2165, 421321, 'Personnel : Salaires et accessoires - Comptes Particuliers du Tresor - Virement - Avis de credit - Exercice en cours'),
(2166, 421411, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Bons de caisse - Exercice en cours'),
(2167, 421421, 'Personnel : Salaires et accessoires - Fonds de contre valeur - Numeraire - Virement - Avis de credit - Exercice en cours'),
(2168, 421822, 'Personnel : Salaires et accessoires - Autres - Virement - Avis de credit - N-1'),
(2169, 42711, 'Personnel - Oppositions - Budget General - Numeraire - Ordre de paiement'),
(2170, 42712, 'Personnel - Oppositions - Budget General - Virement - Avis de credit'),
(2171, 427224, 'Personnel - Oppositions - Budgets Annexes - Virement - Avis de credit - N-3'),
(2172, 161289, 'Autres: Depenses'),
(2173, 1780, 'Autres dettes rattachees a des participations'),
(2174, 24531, 'Immobilisations corporelles en cours - Reseau telephonique : Operation budgetaire'),
(2175, 24552, 'Immobilisations corporelles en cours - Reseau d''electricite : Operation d''ordre'),
(2176, 2174, 'Materiel ferroviaire'),
(2177, 21751, 'Immobilisations corporelles - Materiel naval - Operation budgetaire'),
(2178, 2176, 'Materiel aerien'),
(2179, 21811, 'Autres immobilisations corporelles - Cheptel - Operation budgetaire'),
(2180, 473222, 'Depenses avant ordonnancement - Budgets Annexes - Comptables non centralisateurs - Centre Fiscal'),
(2181, 473226, 'Depenses avant ordonnancement - Budgets Annexes - Comptables non centralisateurs - Topographie'),
(2182, 473326, 'Depenses avant ordonnancement - Comptes Particuliers du Tresor - Topographie'),
(2183, 21472, 'Immobilisations corporelles - Installations, agencements et amenagements - Voies - Operation d''ordre'),
(2184, 2151, 'Reseau d''adduction d''eau'),
(2185, 21511, 'Immobilisations corporelles - Reseau d''adduction d''eau - Operation budgetaire'),
(2186, 472113, 'Paiements a imputer ? Frais de tresorerie'),
(2187, 472121, 'Imputation provisoire de depenses - Budget General - Comptables non centralisateurs - Douanes'),
(2188, 472123, 'Imputation provisoire de depenses - Budget General - Comptables non centralisateurs - Perception Principale'),
(2189, 472321, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables non centralisateurs - Douanes'),
(2190, 472328, 'Imputation provisoire de depenses - Comptes Particuliers du Tresor - Comptables non centralisateurs - Autres'),
(2191, 4724, 'Fonds de Contre Valeur'),
(2192, 2156, 'Reseau d''irrigation'),
(2193, 21582, 'Immobilisations corporelles - Autres constructions ou rehabilitations ? Reseaux - Operation d''ordre'),
(2194, 21622, 'Immobilisations corporelles - Materiels agricoles - Operation d''ordre'),
(2195, 2163, 'Materiels informatiques, electriques, electroniques et telephoniques'),
(2196, 21662, 'Immobilisations corporelles - Materiels et mobiliers scolaires - Operation d''ordre'),
(2197, 2167, 'Outillages'),
(2198, 21672, 'Immobilisations corporelles - Outillages - Operation budgetaire'),
(2199, 2171, 'Renouvellement des vehicules terrestres du parc administratif'),
(2200, 6550, 'Transferts aux organismes publics'),
(2201, 473111, 'Depenses avant ordonnancement - Budget General - Comptables Centralisateurs - Frais de Justice Criminelle'),
(2202, 2154, 'Reseau de communication'),
(2203, 427323, 'Personnel - Oppositions - Comptes Particuliers du Tresor - Virement - Avis de credit - N-2'),
(2204, 427823, 'Personnel - Oppositions - Autres - Virement - Avis de credit - N-2'),
(2205, 4317, 'CNAPS - Produits a recevoir'),
(2206, 4438, 'Autres recettes a repartir sur impots et taxes recouvrables sur des tiers'),
(2207, 451112, 'Comptabilites distinctes rattachees - Budgets annexes - Imprimerie Nationale - Investissement'),
(2208, 45113, 'Comptabilites distinctes rattachees - Budgets annexes - Parcs et ateliers des Travaux Publics'),
(2209, 4522, 'Etablissements Publics Nationaux'),
(2210, 45228, 'Autres'),
(2211, 45281, 'Correspondants - Autres correspondants - Bureau municipal d''assistance sociale'),
(2212, 45311, 'Comptes de depots sans interets - Budget General - Regies d''avances'),
(2213, 453118, 'Comptes de depots sans interets - Budget General - Regies d''avances - Autres'),
(2214, 45313, 'Comptes de depots sans interets - Correspondants'),
(2215, 453132, 'Comptes de depots sans interets - Etablissements Publics Nationaux'),
(2216, 453138, 'Comptes de depots sans interets - Autres correspondants'),
(2217, 4533, 'Comptes de depots en garantie de paiement d''impot'),
(2218, 4610, 'Creances sur cession d''immobilisations'),
(2219, 46212, 'Consignations financieres'),
(2220, 46213, 'Consignations judiciaires'),
(2221, 46353, 'Part des porteurs de contraintes - Tresor'),
(2222, 46358, 'Part des porteurs de contraintes - Autres'),
(2223, 4636211, 'Operations d''encaissement diverses - Douanes'),
(2224, 463622, 'Operations d''encaissement diverses - Centre Fiscal'),
(2225, 463623, 'Operations d''encaissement diverses - Tresor'),
(2226, 463628, 'Operations d''encaissement diverses - Autres departements'),
(2227, 4676, 'Autres debiteurs'),
(2228, 4687, 'Divers - Produits a recevoir'),
(2229, 18522, 'Compte de liaison a l''initiative de l''ACCPDC - Depenses'),
(2230, 20111, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Formation - Operation budgetaire'),
(2231, 20112, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Formation - Operation d''ordre'),
(2232, 2014, 'Logiciels informatiques et assimiles'),
(2233, 20141, 'Immobilisations incorporelles - Frais de developpement, de recherche et d''etudes - Logiciels informatiques et assimiles - Operation budgetaire'),
(2234, 2018, 'Autres'),
(2235, 20522, 'Immobilisations incorporelles - Brevets, licences, marques - Operation d''ordre'),
(2236, 21122, 'Immobilisations corporelles - Terrains batis - Operation d''ordre'),
(2237, 2115, 'Terrains de voiries'),
(2238, 471318, 'Autres'),
(2239, 4713221, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables non centralisateurs - Douanes'),
(2240, 4713223, 'Recettes percues avant emission de titre - Budgets Annexes - Comptables non centralisateurs - Perception Principale'),
(2241, 471328, 'Autres'),
(2242, 47133, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor'),
(2243, 471331, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables centralisateurs'),
(2244, 4713324, 'Recettes percues avant emission de titre - Comptes Particuliers du Tresor - Comptables non centralisateurs - Agence Comptable des Postes Diplomatiques et Consulaires'),
(2245, 4713428, 'Recettes percues avant emission de titre - Fonds de contre valeur - Comptables non centralisateurs - Autres'),
(2246, 2117, 'Bois et forets'),
(2247, 2121, 'Amenagement de terrain'),
(2248, 21242, 'Immobilisations corporelles - Travaux d''irrigation - Operation d''ordre'),
(2249, 2125, 'Travaux d''urbanisme'),
(2250, 21251, 'Immobilisations corporelles - Travaux d''urbanisme - Operation budgetaire'),
(2251, 21252, 'Immobilisations corporelles - Travaux d''urbanisme - Operation d''ordre'),
(2252, 278, 'Interets courus sur autres immobilisations financieres'),
(2253, 231, 'Frais de developpement, de recherche et d''etudes'),
(2254, 190, 'Difference sur realisation d''immobilisations non financieres'),
(2255, 476, 'Difference de conversion ? actif'),
(2256, 477, 'Difference de conversion ? passif'),
(2257, 801, 'Engagements donnes'),
(2258, 663, 'Interets des comptes courants et des depots crediteurs'),
(2259, 676, 'Fonds speciaux'),
(2260, 677, 'Election'),
(2261, 719, 'Degrevement, remise, reduction ou annulation'),
(2262, 733, 'Taxe statistique sur les importations'),
(2263, 737, 'Taxe unique sur les produits petroliers'),
(2264, 541, 'Regies d''avance'),
(2265, 469, 'Annulations'),
(2266, 60311, 'indemnite de fonction'),
(2267, 655611, 'Transfert pour charges d''intervention - Autres organismes - Salaires et accessoires'),
(2268, 655212, 'Transferts pour charges de services public - Autres organismes-Heures complementaires'),
(2269, 655113, 'Transferts pour charges de services public - EPA-Vacation'),
(2270, 65513, 'Transferts pour charges de services public - EPA - Transferts aux organismes public - Bourses et presalaires'),
(2271, 65514, 'Transferts pour charges de services public - EPA - Transferts aux organismes public - Subventions d''investissement'),
(2272, 65554, 'Transfert pour charges d''intervention - EPIC - Transferts aux organismes public - Subventions d''investissement'),
(2273, 77147, 'Droit de delivrance de Certificat de Conformite'),
(2278, 6551, '');

-- --------------------------------------------------------
-- Table: piece
-- --------------------------------------------------------
DROP TABLE IF EXISTS "piece";

CREATE TABLE "piece" (
  "id_piece" SERIAL PRIMARY KEY,
  "pj" VARCHAR(50) NOT NULL,
  "id_pcop" INTEGER DEFAULT NULL
);

COMMENT ON TABLE "piece" IS 'Structure de la table piece';

INSERT INTO "piece" ("id_piece", "pj", "id_pcop") VALUES
(38, '  Devis  ou facture proforma du prestataire retenu', 1129),
(39, '  Situation fiscale dont la validite ne doit pas e', 1129),
(40, ' Devis ou convention sous forme de marche', 1129),
(41, '  Contrat de vente', 265),
(42, ' Decision d''achat', 265),
(43, '  Certificat de situation juridique', 265),
(44, ' Plan cadastral (si cadastre)', 265),
(45, '  Titre de propriete (si titre)', 265),
(46, ' Certificat de non hypotheque', 265),
(47, 'Contrat de vente ', 836),
(48, 'Decision d''achat ', 836),
(49, 'Certificat de situation juridique ', 836),
(50, 'Plan cadastral (si cadastre) ', 836),
(51, 'Titre de propriete (si titre) ', 836),
(52, 'Certificat de non hypotheque ', 836),
(53, 'Contrat de vente', 266),
(54, 'Decision d''achat ', 266),
(55, 'Certificat de situation juridique ', 266),
(56, 'Plan cadastral (si cadastre) ', 266),
(57, 'Titre de propriete (si titre', 266),
(58, 'Certificat de non hypotheque ', 266),
(59, 'Contrat de vente ', 268),
(60, 'Decision d''achat ', 268),
(61, 'Certificat de situation juridique ', 268),
(62, 'Plan cadastral (si cadastre) ', 268),
(63, 'Titre de propriete (si titre) ', 268),
(64, 'Certificat de non hypotheque ', 268),
(65, ' Etat de comparaison des offres ou devis', 2247),
(66, '  Devis de l''offre retenue', 2247),
(67, 'Situation fiscale dont la validite ne doit pas exe', 2247),
(68, 'Devis de l''offre retenue', 2247),
(69, 'Marche', 2247),
(70, '  Autorisation du Service du Garage Administratif ', 1589),
(71, '  PV de constat d''accident (reparation consecutive', 1589),
(72, ' Rapport d''expertise du Service des Garages Admini', 1589),
(73, ' Facture proforma ou devis', 1589),
(74, ' Comparaison de prix (prestataire non-concessionna', 1589),
(75, '  Facture proforma', 733),
(76, ' Autorisation de reception sauf reception sous le ', 153),
(77, ' Bon Special de Transport (Agences de Voyage, Soci', 57),
(78, '  Souche du billet (en cas de demande de rembourse', 57),
(79, '  Facture proforma', 57),
(80, ' Ordre de mission vise au depart par le Service du', 57),
(81, ' Comparaison de prix obligatoire ( consultation, m', 1027),
(82, ' Autorisation Commission Nationale des impressions', 1027),
(83, 'Marche signe et vise/CF                        ', 1757),
(84, 'Facture proforma                                  ', 1757),
(85, 'Carte professionnelle         (si non a jour lors ', 1757),
(86, ' Avis de credit   ', 2120),
(87, 'Declaration nominative de l''indemnite compensatric', 2120),
(88, 'Decision portant octroi d''une indemnite compensatr', 1159),
(89, 'Procuration des Heritiers                         ', 1159),
(90, 'Procuration des Heritiers                         ', 1159),
(91, 'Acte de notoriete                                 ', 2120),
(92, 'Procuration des Heritiers                         ', 2120),
(93, 'Acte de deces                                     ', 2120),
(94, 'Certification de cessation de paiement      ', 2120),
(95, 'Decision accordant un secours au deces au profit d', 2120),
(96, 'Decision portant octroi d''une indemnite compensatr', 2120),
(97, 'Declaration nominative mensuel signe par ORDO   ', 1843),
(98, 'Etat de decompte                ', 1843),
(99, 'Justification des mouvements                      ', 1843),
(100, 'ETAT RECAPITULATIF DES RETENUES CRCM  5%          ', 1024),
(101, 'ETAT DE DECOMPTE           ', 145),
(102, 'DECLARATION NOMINATIVE MENSUEL SIGNE PAR ORDO     ', 145),
(103, 'AVIS D''ORDRE DE RECETTE                   ', 2121),
(104, 'ETAT DE DECOMPTE                              ', 2121),
(105, 'ETAT RECAPITULATIF  DES RETENUS                  ', 433),
(106, 'ETAT DE DECOMPTE                                  ', 433),
(107, 'Convention/Marche  signe et vise/CF               ', 1845),
(108, 'Facture proforma                                  ', 1845),
(110, 'Convention/Marche signe et vise/CF                ', 1027),
(111, 'Facture proforma                                  ', 1027),
(113, 'Convention/Marche signe et vise/CF                ', 1846),
(114, 'Facture proforma                                  ', 1846),
(115, 'Carte fiscale', 1846),
(116, 'Marche signe et vise/CF                        ', 1028),
(117, 'Facture proforma                                  ', 1028),
(118, 'Carte professionnelle     si non a jour lors vis', 1028),
(119, 'Marche signe et vise/CF                        ', 1847),
(120, 'Facture proforma                                  ', 1847),
(121, 'Carte professionnelle                si non a jour', 1847),
(122, 'Marche signe et vise/CF                        ', 1588),
(123, 'Facture proforma                                  ', 1588),
(124, 'Carte professionnelle                             ', 1588),
(125, 'Marche signe et vise/CF    ', 1589),
(126, 'Facture proforma               ', 1589),
(127, 'Carte professionnelle                 si non a jou', 1589),
(128, 'Facture proforma signee par ORDO ', 1590),
(129, 'DEF signee par l''Ordo', 1590),
(130, 'Contrat d''abonnement      ', 1590),
(131, 'Facture proforma signee par ORDO ', 1305),
(132, 'DEF', 1305),
(133, 'Marche subsequent', 2127),
(134, 'Carte professionnel ', 2127),
(135, 'Fac proforma ', 2127),
(136, 'Ordre de mission vise par MAE et SGG', 57),
(137, 'PV de la commission technique chargee des EVASAN', 57),
(138, 'Ordre de mission vise par MAE et SGG', 58),
(139, 'PV de la commission technique chargee des EVASAN', 58),
(140, 'Contrat d''abonnement signe par ORDO et Interlocute', 1764),
(141, 'Facture proforma signee par ORDO et Gestionnaire d', 1764),
(142, 'DEF', 1764),
(143, 'Marche signe et vise/CF    ', 1764),
(144, 'Facture proforma               ', 1764),
(145, 'Carte professionnelle        si non a jour lors vi', 1733),
(146, 'Facture proforma               ', 1733),
(147, 'Marche signe et vise/CF    ', 1733),
(148, 'Decision signee et visee par CF         ', 620),
(149, 'Decision signee et visee/CF    ', 1206),
(151, 'Contrat d''abonnement signe par ORDO et Interlocute', 363),
(152, 'Facture proforma signee par ORDO et Gestionnaire d', 363),
(153, 'Marche signe et vise/CF', 434),
(154, 'Facture proforma', 434),
(155, 'Carte professionnelle         (si non a jour lors ', 434),
(156, 'Programme d''emploi', 465),
(158, 'Programme d''emploi ', 1051),
(159, 'Programme d''emploi ', 2144),
(160, 'Programme d''emploi ', 466),
(161, 'Programme d''emploi ', 184),
(162, 'Acte d''engagement simplifie vise', 727),
(163, 'Bon de commande', 1027),
(164, 'Bond de commande', 1845),
(165, 'Bon de commande', 1846),
(166, 'piece 1', 1050),
(167, 'pieces 2', 1050),
(168, 'neant', 1050),
(169, 'xxxxxx1', 22),
(170, 'Marche vise', 136),
(171, 'Marche vise', 1583),
(172, 'Devis', 1583),
(175, 'Bon de commande', 727),
(176, 'Proformat imprimerie nationale', 727),
(177, 'Carte fiscale', 1845),
(178, 'Carte fiscale', 1027),
(179, 'Devis', 136),
(180, 'Note de presentation', 55),
(181, 'nomination acteur budgetaire', 55),
(182, 'programme d''emploi', 55),
(183, 'Accord de projet', 55),
(184, 'Convetion de Financement AFD entre la Republique', 55),
(185, 'Budget', 55),
(186, '<script>alert(''XSS'')</script>', 1159),
(187, 'DEF', 2124),
(188, 'DEF', 1506),
(189, 'Proforma', 1506);

-- --------------------------------------------------------
-- Table: piece_achat
-- --------------------------------------------------------
DROP TABLE IF EXISTS "piece_achat";

CREATE TABLE "piece_achat" (
  "id_achat" SERIAL PRIMARY KEY,
  "lib_achat" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "piece_achat" IS 'Structure de la table piece_achat';

INSERT INTO "piece_achat" ("id_achat", "lib_achat") VALUES
(2, 'Proforma'),
(3, 'listes fournisseurs consultes');

-- --------------------------------------------------------
-- Table: piece_avenant
-- --------------------------------------------------------
DROP TABLE IF EXISTS "piece_avenant";

CREATE TABLE "piece_avenant" (
  "id_avenant" SERIAL PRIMARY KEY,
  "lib_avenant" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "piece_avenant" IS 'Structure de la table piece_avenant';

INSERT INTO "piece_avenant" ("id_avenant", "lib_avenant") VALUES
(1, 'Projet d avenant '),
(2, 'Marche');

-- --------------------------------------------------------
-- Table: piece_contrat
-- --------------------------------------------------------
DROP TABLE IF EXISTS "piece_contrat";

CREATE TABLE "piece_contrat" (
  "id_contrat" SERIAL PRIMARY KEY,
  "lib_contrat" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "piece_contrat" IS 'Structure de la table piece_contrat';

INSERT INTO "piece_contrat" ("id_contrat", "lib_contrat") VALUES
(1, 'Projet de contrat'),
(2, 'Note de presentation'),
(3, 'Proforma');

-- --------------------------------------------------------
-- Table: piece_marche
-- --------------------------------------------------------
DROP TABLE IF EXISTS "piece_marche";

CREATE TABLE "piece_marche" (
  "id_marche" SERIAL PRIMARY KEY,
  "lib_marche" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "piece_marche" IS 'Structure de la table piece_marche';

INSERT INTO "piece_marche" ("id_marche", "lib_marche") VALUES
(1, 'Affichage CF'),
(2, 'PV d ouverture'),
(3, 'Rapport d evaluation'),
(4, 'PV de validation'),
(5, 'Decision d attribution'),
(6, 'Avis d attribution'),
(7, 'Marche/Convention en 6 exemplaires'),
(8, 'PV CNM (selon le cas)'),
(9, 'Autorisation CNM (gre a gre)'),
(10, 'DAO'),
(11, 'Carte professionnelle');

-- --------------------------------------------------------
-- Table: secretaire_aller1
-- --------------------------------------------------------
DROP TABLE IF EXISTS "secretaire_aller1";

CREATE TABLE "secretaire_aller1" (
  "id_secretaire" SERIAL PRIMARY KEY,
  "id_eng" INTEGER NOT NULL,
  "numDef" VARCHAR(20) NOT NULL,
  "refCF" VARCHAR(20) NOT NULL,
  "soumission" INTEGER NOT NULL,
  "loginReception1" VARCHAR(11) NOT NULL,
  "dateReception1" TIMESTAMP DEFAULT NULL,
  "etatSecVerif" VARCHAR(20) NOT NULL,
  "loginCloture" VARCHAR(10) DEFAULT NULL,
  "dateCloture" TIMESTAMP DEFAULT NULL,
  "etatVerif" INTEGER NOT NULL,
  "type" VARCHAR(10) NOT NULL,
  "loginReceptionSec" VARCHAR(10) NOT NULL,
  "dateReceptionSec" TIMESTAMP NOT NULL,
  "loginClotureSec" VARCHAR(10) NOT NULL,
  "dateClotureSec" TIMESTAMP NOT NULL,
  "etatSecSigfp" VARCHAR(20) NOT NULL,
  "etatSigfp2" INTEGER NOT NULL,
  "nomservice" VARCHAR(40) NOT NULL,
  "dateReceptionService" TIMESTAMP NOT NULL
);

COMMENT ON TABLE "secretaire_aller1" IS 'Structure de la table secretaire_aller1';

INSERT INTO "secretaire_aller1" ("id_secretaire", "id_eng", "numDef", "refCF", "soumission", "loginReception1", "dateReception1", "etatSecVerif", "loginCloture", "dateCloture", "etatVerif", "type", "loginReceptionSec", "dateReceptionSec", "loginClotureSec", "dateClotureSec", "etatSecSigfp", "etatSigfp2", "nomservice", "dateReceptionService") VALUES
(241, 0, 'ENG2023000000297222', 'refCF2023297222', 1, '343276', '2026-08-06 11:34:49', 'Cloturer', '343276', '2026-08-06 11:45:52', 1, 'eng', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 0, '', '0000-00-00 00:00:00'),
(242, 0, 'ENG2023000000297267', 'refCF2023297267', 1, '343276', '2026-08-06 11:34:49', 'Cloturer', '343276', '2026-08-06 12:07:01', 1, 'eng', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 0, '', '0000-00-00 00:00:00');

-- --------------------------------------------------------
-- Table: secretaire_aller2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "secretaire_aller2";

CREATE TABLE "secretaire_aller2" (
  "id_sec" SERIAL PRIMARY KEY,
  "numDef" VARCHAR(20) NOT NULL,
  "refCF" VARCHAR(20) NOT NULL,
  "loginReception2" VARCHAR(11) NOT NULL,
  "dateReception2" TIMESTAMP NOT NULL,
  "soumission2" INTEGER NOT NULL,
  "loginCloture" VARCHAR(11) NOT NULL,
  "dateCloture" TIMESTAMP NOT NULL,
  "etatSecVerif2" VARCHAR(20) NOT NULL,
  "etatVerif2" INTEGER NOT NULL
);

COMMENT ON TABLE "secretaire_aller2" IS 'Structure de la table secretaire_aller2';

ALTER TABLE "secretaire_aller1" ALTER COLUMN "dateReceptionSec" DROP NOT NULL;
ALTER TABLE "secretaire_aller1" ALTER COLUMN "dateClotureSec" DROP NOT NULL;
ALTER TABLE "secretaire_aller1" ALTER COLUMN "dateReceptionService" DROP NOT NULL;

-- --------------------------------------------------------
-- Table: tbl_accuse
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_accuse";

CREATE TABLE "tbl_accuse" (
  "id_eng" SERIAL PRIMARY KEY,
  "id_verif_retour" INTEGER NOT NULL,
  "numDef" VARCHAR(25) DEFAULT NULL,
  "ministere" VARCHAR(50) DEFAULT NULL,
  "mission" VARCHAR(4) DEFAULT NULL,
  "programme" VARCHAR(4) DEFAULT NULL,
  "soa" VARCHAR(20) DEFAULT NULL,
  "ordsec" VARCHAR(20) DEFAULT NULL,
  "cf_code" VARCHAR(10) DEFAULT NULL,
  "convention" VARCHAR(4) DEFAULT NULL,
  "financement" VARCHAR(12) DEFAULT NULL,
  "refMarche" VARCHAR(20) DEFAULT NULL,
  "tiersCode" VARCHAR(10) DEFAULT NULL,
  "tiersNom" VARCHAR(30) DEFAULT NULL,
  "compte" INTEGER DEFAULT NULL,
  "objet" VARCHAR(100) DEFAULT NULL,
  "categorie" INTEGER DEFAULT NULL,
  "dateEngagement" TIMESTAMP DEFAULT NULL,
  "montant" DOUBLE PRECISION DEFAULT NULL,
  "creditModifie" DOUBLE PRECISION DEFAULT NULL,
  "loiFinance" DOUBLE PRECISION DEFAULT NULL,
  "type_engagement" VARCHAR(12) DEFAULT NULL,
  "procedure" VARCHAR(20) DEFAULT NULL,
  "etatEng" VARCHAR(10) NOT NULL,
  "exercice" VARCHAR(10) NOT NULL,
  "dateAccuse" DATE NOT NULL,
  "impression" INTEGER NOT NULL
);

COMMENT ON TABLE "tbl_accuse" IS 'Structure de la table tbl_accuse';

-- --------------------------------------------------------
-- Table: tbl_delegue_retour
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_delegue_retour";

CREATE TABLE "tbl_delegue_retour" (
  "id_delegue_ret" SERIAL PRIMARY KEY,
  "NumTef" VARCHAR(50) NOT NULL,
  "Mat_reception_retour_delegue" VARCHAR(50) NOT NULL,
  "Mat_envoye_retour_delegue" VARCHAR(50) NOT NULL,
  "CodeCFRet" VARCHAR(20) NOT NULL,
  "Montant" DOUBLE PRECISION NOT NULL,
  "dateReception_delegue_ret" DATE NOT NULL,
  "dateCloture_delegue_ret" DATE NOT NULL,
  "etatDelegfRet" INTEGER NOT NULL,
  "etatDelegcloture" VARCHAR(20) NOT NULL,
  "numDef" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "tbl_delegue_retour" IS 'Structure de la table tbl_delegue_retour';

-- --------------------------------------------------------
-- Table: tbl_delegue_retour_rejet
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_delegue_retour_rejet";

CREATE TABLE "tbl_delegue_retour_rejet" (
  "id_delegue_ret" SERIAL PRIMARY KEY,
  "NumDef" VARCHAR(50) NOT NULL,
  "Mat_reception_retour_delegue_rejet" VARCHAR(50) NOT NULL,
  "Mat_envoye_retour_delegue_rejet" VARCHAR(50) NOT NULL,
  "CodeCFRet_rejet" VARCHAR(20) NOT NULL,
  "Montant" DOUBLE PRECISION NOT NULL,
  "dateReception_delegue_ret_rejet" TIMESTAMP NOT NULL,
  "dateCloture_delegue_ret_rejet" TIMESTAMP NOT NULL,
  "etatDelegfRet_rejet" INTEGER NOT NULL,
  "etatDelegcloture_rejet" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "tbl_delegue_retour_rejet" IS 'Structure de la table tbl_delegue_retour_rejet';

-- --------------------------------------------------------
-- Table: tbl_mail
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_mail";

CREATE TABLE "tbl_mail" (
  "id_mail" SERIAL PRIMARY KEY,
  "numDef" VARCHAR(20) NOT NULL,
  "adresse_mail" VARCHAR(50) NOT NULL,
  "etat_email" INTEGER NOT NULL
);

COMMENT ON TABLE "tbl_mail" IS 'Structure de la table tbl_mail';

INSERT INTO "tbl_mail" ("id_mail", "numDef", "adresse_mail", "etat_email") VALUES
(142, 'ENG2023000000297222', 'andriamihajaolivia06@gmail.com', 0),
(143, 'ENG2023000000297267', 'andriamihajaolivia06@gmail.com', 0);

-- --------------------------------------------------------
-- Table: tbl_rejet
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_rejet";

CREATE TABLE "tbl_rejet" (
  "id_eng" SERIAL PRIMARY KEY,
  "bdef" VARCHAR(20) NOT NULL,
  "numDef" VARCHAR(25) DEFAULT NULL,
  "ministere" VARCHAR(50) DEFAULT NULL,
  "mission" VARCHAR(4) DEFAULT NULL,
  "programme" VARCHAR(4) DEFAULT NULL,
  "soa" VARCHAR(20) DEFAULT NULL,
  "ordsec" VARCHAR(12) DEFAULT NULL,
  "cf_code" VARCHAR(10) DEFAULT NULL,
  "convention" VARCHAR(4) DEFAULT NULL,
  "financement" VARCHAR(12) DEFAULT NULL,
  "refMarche" VARCHAR(20) DEFAULT NULL,
  "tiersCode" VARCHAR(10) DEFAULT NULL,
  "tiersNom" VARCHAR(30) DEFAULT NULL,
  "tiersAdresse" VARCHAR(150) NOT NULL,
  "compte" INTEGER DEFAULT NULL,
  "objet" VARCHAR(100) DEFAULT NULL,
  "categorie" INTEGER DEFAULT NULL,
  "dateEngagement" TIMESTAMP DEFAULT NULL,
  "montant" DOUBLE PRECISION DEFAULT NULL,
  "creditModifie" DOUBLE PRECISION DEFAULT NULL,
  "loiFinance" DOUBLE PRECISION DEFAULT NULL,
  "type_engagement" VARCHAR(12) DEFAULT NULL,
  "procedure" VARCHAR(20) DEFAULT NULL,
  "etat_rejet" INTEGER NOT NULL,
  "exercice" VARCHAR(10) NOT NULL,
  "etatEng" VARCHAR(20) NOT NULL,
  "dateRejetVisa" DATE NOT NULL,
  "dateBdef" DATE NOT NULL,
  "dateAccuse" DATE NOT NULL,
  "tpAssignataire" VARCHAR(30) NOT NULL
);

COMMENT ON TABLE "tbl_rejet" IS 'Structure de la table tbl_rejet';

-- --------------------------------------------------------
-- Table: tbl_secretaire_retour
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_secretaire_retour";

CREATE TABLE "tbl_secretaire_retour" (
  "id_secretaire_ret" SERIAL PRIMARY KEY,
  "NumTef" VARCHAR(50) NOT NULL,
  "Mat_reception_retour_secretaire" VARCHAR(50) NOT NULL,
  "Mat_envoye_retour_secretaire" VARCHAR(50) NOT NULL,
  "CodeCFRet" VARCHAR(20) NOT NULL,
  "Montant" DOUBLE PRECISION NOT NULL,
  "dateReception_secretaire_ret" TIMESTAMP NOT NULL,
  "dateCloture_secretaire_ret" TIMESTAMP NOT NULL,
  "etat_secretaire_Ret" INTEGER NOT NULL,
  "etat_secretaire_cloture" VARCHAR(20) NOT NULL,
  "date_envoi_service_ret" TIMESTAMP DEFAULT NULL,
  "Mat_envoye_service_ret" VARCHAR(20) NOT NULL,
  "service" VARCHAR(50) NOT NULL,
  "numDef" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "tbl_secretaire_retour" IS 'Structure de la table tbl_secretaire_retour';

-- --------------------------------------------------------
-- Table: tbl_secretaire_retour_rejet
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_secretaire_retour_rejet";

CREATE TABLE "tbl_secretaire_retour_rejet" (
  "id_secretaire_ret" SERIAL PRIMARY KEY,
  "NumDef" VARCHAR(50) NOT NULL,
  "Mat_reception_retour_secretaire_rejet" VARCHAR(50) NOT NULL,
  "Mat_envoye_service_ret_rejet" VARCHAR(20) NOT NULL,
  "Mat_envoye_retour_secretaire_rejet" VARCHAR(50) NOT NULL,
  "CodeCFRet_rejet" VARCHAR(20) NOT NULL,
  "Montant" DOUBLE PRECISION NOT NULL,
  "dateReception_secretaire_ret_rejet" TIMESTAMP NOT NULL,
  "dateCloture_secretaire_ret_rejet" TIMESTAMP NOT NULL,
  "date_envoi_service_ret_rejet" DATE NOT NULL,
  "etat_secretaire_ret_rejet" INTEGER NOT NULL,
  "etat_secretaire_cloture_rejet" VARCHAR(20) NOT NULL,
  "service_rejet" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "tbl_secretaire_retour_rejet" IS 'Structure de la table tbl_secretaire_retour_rejet';

-- --------------------------------------------------------
-- Table: tbl_tef
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_tef";

CREATE TABLE "tbl_tef" (
  "id_eng" SERIAL PRIMARY KEY,
  "Tef" VARCHAR(100) NOT NULL,
  "btef" VARCHAR(50) NOT NULL,
  "bdef" VARCHAR(20) NOT NULL,
  "numDef" VARCHAR(20) DEFAULT NULL,
  "ministere" VARCHAR(50) DEFAULT NULL,
  "mission" VARCHAR(4) DEFAULT NULL,
  "programme" VARCHAR(4) DEFAULT NULL,
  "soa" VARCHAR(20) DEFAULT NULL,
  "ordsec" VARCHAR(20) DEFAULT NULL,
  "cf" VARCHAR(10) DEFAULT NULL,
  "convention" VARCHAR(4) DEFAULT NULL,
  "financement" VARCHAR(12) DEFAULT NULL,
  "refMarche" VARCHAR(20) DEFAULT NULL,
  "tiersCode" VARCHAR(10) DEFAULT NULL,
  "tiersNom" VARCHAR(30) DEFAULT NULL,
  "compte" INTEGER DEFAULT NULL,
  "objet" VARCHAR(100) DEFAULT NULL,
  "categorie" INTEGER DEFAULT NULL,
  "dateEngagement" TIMESTAMP DEFAULT NULL,
  "montant" DOUBLE PRECISION DEFAULT NULL,
  "creditModifie" DOUBLE PRECISION DEFAULT NULL,
  "loiFinance" DOUBLE PRECISION DEFAULT NULL,
  "type_engagement" VARCHAR(12) DEFAULT NULL,
  "typeVisa" VARCHAR(10) NOT NULL,
  "procedure" VARCHAR(20) DEFAULT NULL,
  "etat_tef" INTEGER NOT NULL,
  "exercice" VARCHAR(20) NOT NULL,
  "visaDate" DATE NOT NULL,
  "dateAccuse" DATE NOT NULL,
  "etatEng" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "tbl_tef" IS 'Structure de la table tbl_tef';

-- --------------------------------------------------------
-- Table: tbl_verifcloture
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_verifcloture";

CREATE TABLE "tbl_verifcloture" (
  "id_verifcloture" SERIAL PRIMARY KEY,
  "engverifcloture" VARCHAR(20) NOT NULL,
  "id_piece" INTEGER NOT NULL,
  "piecejustificative" VARCHAR(300) NOT NULL,
  "id_pcop" INTEGER NOT NULL
);

COMMENT ON TABLE "tbl_verifcloture" IS 'Structure de la table tbl_verifcloture';

INSERT INTO "tbl_verifcloture" ("id_verifcloture", "engverifcloture", "id_piece", "piecejustificative", "id_pcop") VALUES
(291, 'ENG2023000000297222', 101, 'ETAT DE DECOMPTE           ', 145),
(292, 'ENG2023000000297222', 102, 'DECLARATION NOMINATIVE MENSUEL SIGNE PAR ORDO     ', 145);

-- --------------------------------------------------------
-- Table: tbl_verifcloture2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_verifcloture2";

CREATE TABLE "tbl_verifcloture2" (
  "id_verifcloture" SERIAL PRIMARY KEY,
  "engverifcloture" VARCHAR(20) NOT NULL,
  "id_piece" INTEGER NOT NULL,
  "piecejustificative" VARCHAR(300) NOT NULL,
  "id_pcop" INTEGER NOT NULL
);

COMMENT ON TABLE "tbl_verifcloture2" IS 'Structure de la table tbl_verifcloture2';

-- --------------------------------------------------------
-- Table: tbl_verifcloturedel_aller1
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_verifcloturedel_aller1";

CREATE TABLE "tbl_verifcloturedel_aller1" (
  "id_verifcloturedel_aller1" SERIAL PRIMARY KEY,
  "engverifcloture" VARCHAR(20) NOT NULL,
  "id_piece" INTEGER NOT NULL,
  "piecejustificative" VARCHAR(300) NOT NULL,
  "id_pcop" INTEGER NOT NULL
);

COMMENT ON TABLE "tbl_verifcloturedel_aller1" IS 'Structure de la table tbl_verifcloturedel_aller1';

INSERT INTO "tbl_verifcloturedel_aller1" ("id_verifcloturedel_aller1", "engverifcloture", "id_piece", "piecejustificative", "id_pcop") VALUES
(263, 'ENG2023000000297222', 101, 'ETAT DE DECOMPTE           ', 145),
(264, 'ENG2023000000297222', 102, 'DECLARATION NOMINATIVE MENSUEL SIGNE PAR ORDO     ', 145);

-- --------------------------------------------------------
-- Table: tbl_verifcloturedel_aller2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_verifcloturedel_aller2";

CREATE TABLE "tbl_verifcloturedel_aller2" (
  "id_verifcloturedel_aller2" SERIAL PRIMARY KEY,
  "engverifcloture" VARCHAR(20) NOT NULL,
  "id_piece" INTEGER NOT NULL,
  "piecejustificative" VARCHAR(300) NOT NULL,
  "id_pcop" INTEGER NOT NULL
);

COMMENT ON TABLE "tbl_verifcloturedel_aller2" IS 'Structure de la table tbl_verifcloturedel_aller2';

-- --------------------------------------------------------
-- Table: tbl_verificateur_retour
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_verificateur_retour";

CREATE TABLE "tbl_verificateur_retour" (
  "id_verif_ret" SERIAL PRIMARY KEY,
  "NumTef" VARCHAR(50) NOT NULL,
  "Matricule_reception_retour" VARCHAR(50) NOT NULL,
  "Matricule_envoye_retour" VARCHAR(50) NOT NULL,
  "CodeCFVerifRet" VARCHAR(20) NOT NULL,
  "Montant" DOUBLE PRECISION NOT NULL,
  "dateReception_verif_ret" DATE NOT NULL,
  "dateCloture_verif_ret" DATE NOT NULL,
  "etatVerifRet" INTEGER NOT NULL,
  "etat_cloture" VARCHAR(20) NOT NULL,
  "numDef" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "tbl_verificateur_retour" IS 'Structure de la table tbl_verificateur_retour';

-- --------------------------------------------------------
-- Table: tbl_verificateur_retour_rejet
-- --------------------------------------------------------
DROP TABLE IF EXISTS "tbl_verificateur_retour_rejet";

CREATE TABLE "tbl_verificateur_retour_rejet" (
  "id_verif_ret" SERIAL PRIMARY KEY,
  "NumDef" VARCHAR(25) NOT NULL,
  "Matricule_reception_retour_rejet" VARCHAR(50) NOT NULL,
  "Matricule_envoye_retour_rejet" VARCHAR(50) NOT NULL,
  "CodeCFVerifRet_rejet" VARCHAR(20) NOT NULL,
  "Montant" DOUBLE PRECISION NOT NULL,
  "dateReception_verif_ret_rejet" TIMESTAMP NOT NULL,
  "dateCloture_verif_ret_rejet" TIMESTAMP NOT NULL,
  "etatVerifRet_rejet" INTEGER NOT NULL,
  "etat_cloture_rejet" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "tbl_verificateur_retour_rejet" IS 'Structure de la table tbl_verificateur_retour_rejet';

-- --------------------------------------------------------
-- Table: temp_achat
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_achat";

CREATE TABLE "temp_achat" (
  "id_tempachat" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(50) DEFAULT NULL,
  "id_achat" INTEGER DEFAULT NULL,
  "lib_achat" VARCHAR(30) DEFAULT NULL
);

COMMENT ON TABLE "temp_achat" IS 'Structure de la table temp_achat';

-- --------------------------------------------------------
-- Table: temp_avenant
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_avenant";

CREATE TABLE "temp_avenant" (
  "id_tempavenant" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(50) DEFAULT NULL,
  "id_avenant" INTEGER DEFAULT NULL,
  "lib_avenant" VARCHAR(30) DEFAULT NULL
);

COMMENT ON TABLE "temp_avenant" IS 'Structure de la table temp_avenant';

-- --------------------------------------------------------
-- Table: temp_contrat
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_contrat";

CREATE TABLE "temp_contrat" (
  "id_tempcontrat" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(50) DEFAULT NULL,
  "id_contrat" INTEGER DEFAULT NULL,
  "lib_contrat" VARCHAR(30) DEFAULT NULL
);

COMMENT ON TABLE "temp_contrat" IS 'Structure de la table temp_contrat';

-- --------------------------------------------------------
-- Table: temp_contrat2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_contrat2";

CREATE TABLE "temp_contrat2" (
  "id_tempcontrat" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(50) DEFAULT NULL,
  "id_contrat" INTEGER DEFAULT NULL,
  "lib_contrat" VARCHAR(30) DEFAULT NULL
);

COMMENT ON TABLE "temp_contrat2" IS 'Structure de la table temp_contrat2';

-- --------------------------------------------------------
-- Table: temp_marche
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_marche";

CREATE TABLE "temp_marche" (
  "id_tempmarche" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(50) NOT NULL,
  "id_marche" INTEGER NOT NULL,
  "lib_marche" VARCHAR(30) DEFAULT NULL
);

COMMENT ON TABLE "temp_marche" IS 'Structure de la table temp_marche';

-- --------------------------------------------------------
-- Table: temp_marche2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_marche2";

CREATE TABLE "temp_marche2" (
  "id_tempmarche" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(50) NOT NULL,
  "id_marche" INTEGER NOT NULL,
  "lib_marche" VARCHAR(30) DEFAULT NULL
);

COMMENT ON TABLE "temp_marche2" IS 'Structure de la table temp_marche2';

-- --------------------------------------------------------
-- Table: temp_motif
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_motif";

CREATE TABLE "temp_motif" (
  "id_tempmotif" SERIAL PRIMARY KEY,
  "id_motif" INTEGER NOT NULL,
  "numDef" VARCHAR(30) NOT NULL
);

COMMENT ON TABLE "temp_motif" IS 'Structure de la table temp_motif';

INSERT INTO "temp_motif" ("id_tempmotif", "id_motif", "numDef") VALUES
(168, 9, 'ENG2023000000297222');

-- --------------------------------------------------------
-- Table: temp_motif2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_motif2";

CREATE TABLE "temp_motif2" (
  "id_tempmotif" SERIAL PRIMARY KEY,
  "id_motif" INTEGER NOT NULL,
  "numDef" VARCHAR(30) NOT NULL
);

COMMENT ON TABLE "temp_motif2" IS 'Structure de la table temp_motif2';

-- --------------------------------------------------------
-- Table: temp_motifachat
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_motifachat";

CREATE TABLE "temp_motifachat" (
  "id_tempmotif" SERIAL PRIMARY KEY,
  "id_motif" INTEGER NOT NULL,
  "refCf" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "temp_motifachat" IS 'Structure de la table temp_motifachat';

-- --------------------------------------------------------
-- Table: temp_motifcontrat
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_motifcontrat";

CREATE TABLE "temp_motifcontrat" (
  "id_tempmotif" SERIAL PRIMARY KEY,
  "id_motif" INTEGER NOT NULL,
  "refCf" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "temp_motifcontrat" IS 'Structure de la table temp_motifcontrat';

-- --------------------------------------------------------
-- Table: temp_motifdel_aller1
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_motifdel_aller1";

CREATE TABLE "temp_motifdel_aller1" (
  "id_motifdel_aller1" SERIAL PRIMARY KEY,
  "id_motif" INTEGER NOT NULL,
  "numDef" VARCHAR(30) NOT NULL
);

COMMENT ON TABLE "temp_motifdel_aller1" IS 'Structure de la table temp_motifdel_aller1';

INSERT INTO "temp_motifdel_aller1" ("id_motifdel_aller1", "id_motif", "numDef") VALUES
(169, 9, 'ENG2023000000297222');

-- --------------------------------------------------------
-- Table: temp_motifdel_aller2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_motifdel_aller2";

CREATE TABLE "temp_motifdel_aller2" (
  "id_motifdel_aller2" SERIAL PRIMARY KEY,
  "id_motif" INTEGER NOT NULL,
  "numDef" VARCHAR(30) NOT NULL
);

COMMENT ON TABLE "temp_motifdel_aller2" IS 'Structure de la table temp_motifdel_aller2';

-- --------------------------------------------------------
-- Table: temp_motifmarche
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_motifmarche";

CREATE TABLE "temp_motifmarche" (
  "id_tempmotif" SERIAL PRIMARY KEY,
  "id_motif" INTEGER NOT NULL,
  "refCf" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "temp_motifmarche" IS 'Structure de la table temp_motifmarche';

-- --------------------------------------------------------
-- Table: temp_motifmarche2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "temp_motifmarche2";

CREATE TABLE "temp_motifmarche2" (
  "id_tempmotif" SERIAL PRIMARY KEY,
  "id_motif" INTEGER NOT NULL,
  "refCf" VARCHAR(20) NOT NULL
);

COMMENT ON TABLE "temp_motifmarche2" IS 'Structure de la table temp_motifmarche2';

-- --------------------------------------------------------
-- Table: teste
-- --------------------------------------------------------
DROP TABLE IF EXISTS "teste";

CREATE TABLE "teste" (
  "id" SERIAL PRIMARY KEY,
  "nom" VARCHAR(30) NOT NULL,
  "prenom" VARCHAR(30) NOT NULL,
  "preferences" TEXT DEFAULT NULL
);

COMMENT ON TABLE "teste" IS 'Structure de la table teste';

INSERT INTO "teste" ("id", "nom", "prenom", "preferences") VALUES
(1, 'sambtara', 'Daholo', NULL),
(2, 'Rakotomavo', 'Pascal', NULL),
(3, 'Razanadravao1', 'jaquelines1', NULL),
(4, 'Ramandridona', 'leon', NULL),
(5, 'John Doe', 'erno', '');

-- --------------------------------------------------------
-- Table: user_multiple
-- --------------------------------------------------------
DROP TABLE IF EXISTS "user_multiple";

CREATE TABLE "user_multiple" (
  "id_utilisateur" SERIAL PRIMARY KEY,
  "nom_utilisateur" VARCHAR(100) NOT NULL,
  "prenom_utilisateur" VARCHAR(100) NOT NULL,
  "im_utilisateur" VARCHAR(25) NOT NULL,
  "role" VARCHAR(100) NOT NULL,
  "compte" VARCHAR(30) NOT NULL,
  "login" VARCHAR(100) NOT NULL,
  "mot_passe" VARCHAR(100) NOT NULL,
  "cf_code" VARCHAR(50) NOT NULL,
  "date_creation" DATE NOT NULL,
  "exercice" VARCHAR(4) NOT NULL,
  "etat" VARCHAR(10) NOT NULL
);

COMMENT ON TABLE "user_multiple" IS 'Structure de la table user_multiple';

INSERT INTO "user_multiple" ("id_utilisateur", "nom_utilisateur", "prenom_utilisateur", "im_utilisateur", "role", "compte", "login", "mot_passe", "cf_code", "date_creation", "exercice", "etat") VALUES
(7, ' rasolonandrasana ', 'ernot', '5487', 'secretaire', 'SIMPLE', '8957', '1234', '52', '2022-11-10', '2023', 'actif'),
(10, 'RASOLOARISON         ', 'Radonirina Zoarivelo', '343276', 'secretaire', 'SIMPLE', '343276', '1409', '47', '2022-12-03', '2023', 'actif'),
(12, 'RASOLOARISON    ', 'Radonirina Zoarivelo', '343276', 'verificateur', 'SIMPLE', '343276', '1409', '47', '2022-12-06', '2023', 'actif'),
(17, 'RASOLOARISON   ', 'Radonirina Zoarivelo', '343276', 'delegue', 'SIMPLE', '343276', '1409', '47', '2022-12-07', '2023', 'actif'),
(18, 'RAKOTONDRANAIVO   ', 'Rivo Nombana', '409830', 'secretaire', 'SIMPLE', '409830', 'dgcf11', '51,5', '2023-10-19', '2023', 'actif'),
(22, 'RAKOTOMANGA ', 'Onintsoa', '261244', 'secretaire', 'SIMPLE', '261244', '1', '26', '2024-02-19', '2023', 'actif'),
(23, 'RAKOTOMANGA ', 'Onintsoa', '261244', 'verificateur', 'SIMPLE', '261244', '1', '26', '2024-02-19', '2023', 'actif'),
(24, 'RAKOTOMANGA', 'Onintsoa', '261244', 'delegue', 'SIMPLE', '261244', '1', '26', '2024-02-19', '2023', 'actif'),
(26, 'HANITRARIMALALA   ', 'Sylvie Estelle', '343275', 'secretaire', 'SIMPLE', '343275', 'dadako2307', '47', '2024-03-14', '2023', 'actif'),
(27, 'HANITRARIMALALA ', 'Sylvie Estelle', '343275', 'verificateur', 'SIMPLE', '343275', 'dadako2307', '47', '2024-03-14', '2023', 'actif'),
(28, 'ZAFILAZA ', 'Firanga Ariel', '372478', 'secretaire', 'SIMPLE', '372478', '1', '47', '2024-03-14', '2023', 'actif'),
(29, 'DOUGZARA', 'Zafitoky', '438000', 'secretaire', 'SIMPLE', '438000', '1', '47', '2024-03-14', '2023', 'actif'),
(30, 'ZAFILAZA ', 'Firanga Ariel', '372478', 'verificateur', 'SIMPLE', '372478', '1', '47', '2024-03-14', '2023', 'actif'),
(32, 'DOUGZARA', 'Zafitoky', '438000', 'verificateur', 'SIMPLE', '438000', '1', '47', '2024-03-14', '2023', 'actif'),
(33, 'RAKOTONDRANAIVO  ', 'Rivo Nombana', '409830', 'verificateur', 'SIMPLE', '409830', 'dgcf11', '5,51', '2024-03-14', '2023', 'actif'),
(34, 'RANAIVO ', 'Faly Julliard', '271172', 'secretaire', 'SIMPLE', '271172', '1', '5,51', '2024-03-14', '2023', 'actif'),
(35, 'RANAIVO ', 'Faly Julliard', '271172', 'verificateur', 'SIMPLE', '271172', '1', '5,51', '2024-03-14', '2023', 'actif'),
(36, 'RAKOTOBE', 'Hary', '283289', 'secretaire', 'SIMPLE', '283289', '1', '5,51', '2024-03-14', '2023', 'actif'),
(37, 'RAKOTOBE', 'Hary', '283289', 'verificateur', 'SIMPLE', '283289', '1', '5,51', '2024-03-14', '2023', 'actif'),
(38, 'RANAIVOMANANA  ', 'Zo Maharavo', '305610', 'secretaire', 'SIMPLE', '305610', '1', '55', '2024-03-14', '2023', 'actif'),
(39, 'ANDRIAMIHAMINTIANA ', 'Sata Andriantavy', '293082', 'secretaire', 'SIMPLE', '293082', '1', '55', '2024-03-14', '2023', 'actif'),
(40, 'RABESON  ', 'Sitraka Rinamihanta', '323336', 'secretaire', 'SIMPLE', '323336', '1515', '55', '2024-03-14', '2023', 'actif'),
(41, 'RABEARISON  ', 'Brigitte Michelle', '283470', 'secretaire', 'SIMPLE', '283470', '1977', '55', '2024-03-14', '2023', 'actif'),
(42, 'RANAIVOMANANA ', 'Zo Maharavo', '305610', 'verificateur', 'SIMPLE', '305610', '1', '55', '2024-03-14', '2023', 'actif'),
(43, 'ANDRIAMIHAMINTIANA', 'Sata A', '293082', 'verificateur', 'SIMPLE', '293082', '1', '55', '2024-03-14', '2023', 'actif'),
(44, 'RABESON  ', 'Sitraka Rinamihanta', '323336', 'verificateur', 'SIMPLE', '323336', '1515', '55', '2024-03-14', '2023', 'actif'),
(45, 'RABEARISON ', 'Brigitte Michelle', '283470', 'verificateur', 'SIMPLE', '283470', '1', '55', '2024-03-14', '2023', 'actif'),
(46, 'JACQUELIOT ', 'Tsangana', '290883', 'secretaire', 'SIMPLE', '290883', '1', '45,82', '2024-03-14', '2023', 'actif'),
(47, 'REAL  ', 'Mahenina Nambinintsoa Harimasy', '351250', 'secretaire', 'SIMPLE', '351250', '1', '45,82', '2024-03-14', '2023', 'actif'),
(48, 'RANDRIANIRINA ', 'Guy Rolland', '352139', 'secretaire', 'SIMPLE', '352139', '1', '45,82', '2024-03-14', '2023', 'actif'),
(49, 'RAKOTONOMENJANAHARY ', 'Eric', '437996', 'secretaire', 'SIMPLE', '437996', '7951', '45,82', '2024-03-14', '2023', 'actif'),
(50, 'RAZAFIMAHEFA ', 'Ravelonanahary Rindra Maholy', '437997', 'secretaire', 'SIMPLE', '437997', '1', '45', '2024-03-14', '2023', 'actif'),
(51, 'RAKOTOMANDROSO ', 'Lovatiana Hermann', '438005', 'secretaire', 'SIMPLE', '438005', '1', '45,82', '2024-03-14', '2023', 'actif'),
(52, 'JACQUELIOT ', 'Tsangana', '290883', 'verificateur', 'SIMPLE', '290883', '1810', '45,82', '2024-03-14', '2023', 'actif'),
(53, 'REAL ', 'Mahenina Nambinintsoa Harimasy', '351250', 'verificateur', 'SIMPLE', '351250', '1', '45,82', '2024-03-14', '2023', 'actif'),
(54, 'RANDRIANIRINA  ', 'Guy Rolland', '352139', 'verificateur', 'SIMPLE', '352139', '11', '45,82', '2024-03-14', '2023', 'actif'),
(55, 'RAKOTONOMENJANAHARY', 'Eric', '437996', 'verificateur', 'SIMPLE', '437996', '1', '45,82', '2024-03-14', '2023', 'actif'),
(56, 'RAZAFIMAHEFA  ', 'Ravelonanahary Rindra Maholy', '437997', 'verificateur', 'SIMPLE', '437997', '1975', '45', '2024-03-14', '2023', 'actif'),
(57, 'RAKOTOMANDROSO   ', 'Lovatiana Hermann', '438005', 'verificateur', 'SIMPLE', '438005', '1078F', '45,82', '2024-03-14', '2023', 'actif'),
(58, 'RABEFAGNINA', 'Blaise', '306206', 'delegue', 'SIMPLE', '306206', '1', '5,51', '2024-03-14', '2023', 'actif'),
(65, 'RASAVELO ', 'DG ', '287235', 'delegue', 'SIMPLE', '287235', '1', '47,9,48', '2024-03-14', '2023', 'actif'),
(66, 'RAZAFIMANANTSOA', 'Jelisoa Vahatriniaina', '313748', 'verificateur', 'SIMPLE', '313748', '1', '5,51', '2024-03-14', '2023', 'actif'),
(67, 'RASAVELO ', 'DG', '287235', 'verificateur', 'SIMPLE', '287235', '1', '47,9,48', '2024-03-14', '2023', 'actif'),
(69, 'RASAVELO ', 'DG', '287235', 'secretaire', 'SIMPLE', '287235', '1', '47,9,48', '2024-03-14', '2023', 'actif'),
(70, 'RABEFAGNINA', 'Blaise', '306206', 'secretaire', 'SIMPLE', '306206', '1', '5,51', '2024-03-14', '2023', 'actif'),
(72, 'RABEFAGNINA', 'Blaise', '306206', 'verificateur', 'SIMPLE', '306206', '1', '5,51', '2024-03-14', '2023', 'actif'),
(78, 'RAVELOHARIMASY  ', 'Fara H', '333529', 'secretaire', 'SIMPLE', '333529', '1', '9,48', '2024-03-14', '2023', 'actif'),
(79, 'RAVELOHARIMASY ', 'Fara H', '333529', 'verificateur', 'SIMPLE', '333529', '1', '9,48', '2024-03-14', '2023', 'actif'),
(80, 'RAZAFINDRAFARA ', 'Monique', '283288', 'secretaire', 'SIMPLE', '283288', '1', '9,48', '2024-03-14', '2023', 'actif'),
(81, 'RAMAHATRATRA', 'Marinjara', '327328', 'delegue', 'SIMPLE', '327328', '1', '45,82', '2024-03-14', '2023', 'actif'),
(82, 'RAZAFINDRAFARA ', 'Monique', '283288', 'verificateur', 'SIMPLE', '283288', '1', '9,48', '2024-03-14', '2023', 'actif'),
(83, 'RAMAHATRATRA', 'Marinjara', '327328', 'secretaire', 'SIMPLE', '327328', '1', '45,82', '2024-03-14', '2023', 'actif'),
(84, 'RAMAHATRATRA', 'Marinjara', '327328', 'verificateur', 'SIMPLE', '327328', '1', '45,82', '2024-03-14', '2023', 'actif'),
(85, 'RAKOTOMANGA ', 'Landy H', '261179', 'secretaire', 'SIMPLE', '261179', '1', '9,48', '2024-03-14', '2023', 'actif'),
(86, 'RAKOTOMANGA ', 'Landy H', '261179', 'verificateur', 'SIMPLE', '261179', '1', '9,48', '2024-03-14', '2023', 'actif'),
(90, 'ANDRIANIRINA  ', 'Tahiry', '271174', 'verificateur', 'SIMPLE', '271174', '1', '9,48', '2024-03-14', '2023', 'actif'),
(92, 'RAMAROLAHY ', 'Arisoa', '283287', 'secretaire', 'SIMPLE', '283287', '1', '9,48', '2024-03-14', '2023', 'actif'),
(93, 'RAMAROLAHY ', 'Arisoa', '283287', 'verificateur', 'SIMPLE', '283287', '1', '9,48', '2024-03-14', '2023', 'actif'),
(99, 'RAZAFIMAHEFA ', 'Ravelonanahary Rindra Maholy', '437997', 'secretaire', 'SIMPLE', '437997', '1', '82', '2024-03-14', '2023', 'actif'),
(105, 'RAZAFIMAHEFA ', 'Ravelonanahary Rindra Maholy', '437997', 'verificateur', 'SIMPLE', '437997', '1', '82', '2024-03-14', '2023', 'actif'),
(107, 'RASAMOELINA', 'Maminiaina Andrianaly', '285645', 'delegue', 'SIMPLE', '285645', '1', '55', '2024-03-14', '2023', 'actif'),
(108, 'RASAMOELINA', 'Maminiaina Andrianaly', '285645', 'secretaire', 'SIMPLE', '285645', '1', '55', '2024-03-14', '2023', 'actif'),
(109, 'RASAMOELINA', 'Maminiaina Andrianaly', '285645', 'verificateur', 'SIMPLE', '285645', '1', '55', '2024-03-14', '2023', 'actif'),
(110, 'RAZAFIMANANTSOA', 'Jelisoa Vahatriniaina', '313748', 'secretaire', 'SIMPLE', '313748', '1', '5,51', '2024-03-14', '2023', 'actif'),
(112, 'RAKOTOMAHEFA', 'Rivolalaina Patrick', '353640', 'delegue', 'SIMPLE', '353640', '1', '9', '2024-03-14', '2023', 'actif'),
(113, 'RAKOTOMAHEFA ', 'Rivolalaina Patrick', '353640', 'secretaire', 'SIMPLE', '353640', '1', '9', '2024-03-14', '2023', 'actif'),
(114, 'RAKOTOMAHEFA', 'Rivolalaina Patrick', '353640', 'verificateur', 'SIMPLE', '353640', '1', '9', '2024-03-14', '2023', 'actif'),
(115, 'RAZAFINIMANANA', 'Lalaina', '322881', 'secretaire', 'SIMPLE', '322881', '1', '9', '2024-03-14', '2023', 'actif'),
(116, 'RABARIVELO ', 'Faratiana', '322972', 'secretaire', 'SIMPLE', '322972', '1', '9', '2024-03-14', '2023', 'actif'),
(117, 'RAKOTOASIMBOLA', 'Malalatiana', '294934', 'secretaire', 'SIMPLE', '294934', '1', '9', '2024-03-14', '2023', 'actif'),
(118, 'RAZAFINIMANANA', 'Lalaina', '322881', 'verificateur', 'SIMPLE', '322881', '1', '9', '2024-03-14', '2023', 'actif'),
(119, 'RABARIVELO', 'Faratiana', '322972', 'verificateur', 'SIMPLE', '322972', '1', '9', '2024-03-14', '2023', 'actif'),
(120, 'RAKOTOASIMBOLA', 'Malalatiana', '294934', 'verificateur', 'SIMPLE', '294934', '1', '9', '2024-03-14', '2023', 'actif'),
(121, 'ANDRIANIRINA ', 'Tahiry', '271174', 'secretaire', 'SIMPLE', '271174', '1', '9,48', '2024-04-02', '2023', 'actif');

-- --------------------------------------------------------
-- Table: utilisateur
-- --------------------------------------------------------
DROP TABLE IF EXISTS "utilisateur";

CREATE TABLE "utilisateur" (
  "id_utilisateur" SERIAL PRIMARY KEY,
  "nom_utilisateur" VARCHAR(100) NOT NULL,
  "prenom_utilisateur" VARCHAR(100) NOT NULL,
  "im_utilisateur" VARCHAR(25) NOT NULL,
  "role" VARCHAR(100) NOT NULL,
  "login" VARCHAR(100) NOT NULL,
  "mot_passe" VARCHAR(100) NOT NULL,
  "cf_code" VARCHAR(50) NOT NULL,
  "date_creation" DATE NOT NULL
);

COMMENT ON TABLE "utilisateur" IS 'Structure de la table utilisateur';

-- --------------------------------------------------------
-- Table: verifcloture_marche
-- --------------------------------------------------------
DROP TABLE IF EXISTS "verifcloture_marche";

CREATE TABLE "verifcloture_marche" (
  "id_verifcloture" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(20) DEFAULT NULL,
  "id_piece" INTEGER NOT NULL,
  "piecejustificative" VARCHAR(50) DEFAULT NULL,
  "id_pcop" INTEGER NOT NULL
);

COMMENT ON TABLE "verifcloture_marche" IS 'Structure de la table verifcloture_marche';

-- --------------------------------------------------------
-- Table: verifcloture_marche2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "verifcloture_marche2";

CREATE TABLE "verifcloture_marche2" (
  "id_verifcloture2" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(20) DEFAULT NULL,
  "id_piece" INTEGER NOT NULL,
  "piecejustificative" VARCHAR(50) DEFAULT NULL,
  "id_pcop" INTEGER NOT NULL
);

COMMENT ON TABLE "verifcloture_marche2" IS 'Structure de la table verifcloture_marche2';

-- --------------------------------------------------------
-- Table: verif_aller1
-- --------------------------------------------------------
DROP TABLE IF EXISTS "verif_aller1";

CREATE TABLE "verif_aller1" (
  "id_verif" SERIAL PRIMARY KEY,
  "id_secretaire" INTEGER NOT NULL,
  "numDef" VARCHAR(20) NOT NULL,
  "loginReception" VARCHAR(10) NOT NULL,
  "dateReception" TIMESTAMP NOT NULL,
  "forme" VARCHAR(15) NOT NULL,
  "fond" VARCHAR(15) NOT NULL,
  "proposition" VARCHAR(20) DEFAULT NULL,
  "observations" VARCHAR(200) DEFAULT NULL,
  "loginCloture" VARCHAR(10) DEFAULT NULL,
  "dateCloture" TIMESTAMP DEFAULT NULL,
  "etatVerifDel" VARCHAR(20) NOT NULL,
  "etatDel" INTEGER NOT NULL,
  "loginReception2" VARCHAR(10) NOT NULL,
  "dateReception2" DATE DEFAULT NULL,
  "loginCloture2" VARCHAR(10) NOT NULL,
  "dateCloture2" DATE DEFAULT NULL,
  "decision" VARCHAR(20) DEFAULT NULL,
  "etatVerifSec2" VARCHAR(20) NOT NULL,
  "etatSec2" INTEGER NOT NULL,
  "etatVerifSig" VARCHAR(20) NOT NULL,
  "etatSigfp" INTEGER NOT NULL,
  "etat" INTEGER NOT NULL
);

COMMENT ON TABLE "verif_aller1" IS 'Structure de la table verif_aller1';

INSERT INTO "verif_aller1" ("id_verif", "id_secretaire", "numDef", "loginReception", "dateReception", "forme", "fond", "proposition", "observations", "loginCloture", "dateCloture", "etatVerifDel", "etatDel", "loginReception2", "dateReception2", "loginCloture2", "dateCloture2", "decision", "etatVerifSec2", "etatSec2", "etatVerifSig", "etatSigfp", "etat") VALUES
(192, 0, 'ENG2023000000297222', '343276', '2026-08-06 11:58:50', 'completes', 'anormale', 'faitretour', 'rectification date', '343276', '2026-08-06 12:16:50', 'Cloturer', 1, '', NULL, '', NULL, NULL, '', 0, '', 0, 0),
(193, 0, 'ENG2023000000297267', '343276', '2026-08-06 12:07:40', '', '', NULL, NULL, NULL, NULL, 'Noncloturer', 0, '', NULL, '', NULL, NULL, '', 0, '', 0, 0);

-- --------------------------------------------------------
-- Table: verif_aller2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "verif_aller2";

CREATE TABLE "verif_aller2" (
  "id_verif" SERIAL PRIMARY KEY,
  "numDef" VARCHAR(20) NOT NULL,
  "loginReception" VARCHAR(10) NOT NULL,
  "dateReception" TIMESTAMP NOT NULL,
  "forme" VARCHAR(20) NOT NULL,
  "fond" VARCHAR(15) NOT NULL,
  "proposition" VARCHAR(20) NOT NULL,
  "observations" VARCHAR(200) DEFAULT NULL,
  "loginCloture" VARCHAR(20) NOT NULL,
  "dateCloture" TIMESTAMP DEFAULT NULL,
  "etatVerifDel" VARCHAR(20) NOT NULL,
  "etatDel" INTEGER NOT NULL,
  "loginReception2" VARCHAR(10) NOT NULL,
  "dateReception2" TIMESTAMP DEFAULT NULL,
  "loginCloture2" VARCHAR(10) NOT NULL,
  "dateCloture2" DATE DEFAULT NULL,
  "decision" VARCHAR(20) DEFAULT NULL,
  "etatVerifSec2" VARCHAR(20) NOT NULL,
  "etatSec2" INTEGER NOT NULL,
  "etatVerifSig" VARCHAR(20) NOT NULL,
  "etatSigfp" INTEGER NOT NULL
);

COMMENT ON TABLE "verif_aller2" IS 'Structure de la table verif_aller2';

-- --------------------------------------------------------
-- Table: verif_juridique
-- --------------------------------------------------------
DROP TABLE IF EXISTS "verif_juridique";

CREATE TABLE "verif_juridique" (
  "id_eng_verif" SERIAL PRIMARY KEY,
  "id_eng_jur" INTEGER NOT NULL,
  "refCf" VARCHAR(20) NOT NULL,
  "dateReception" TIMESTAMP NOT NULL,
  "loginReception" VARCHAR(20) NOT NULL,
  "etatVerifDel" VARCHAR(15) NOT NULL,
  "etatVerif" INTEGER NOT NULL,
  "loginCloture" VARCHAR(20) NOT NULL,
  "autres" VARCHAR(100) NOT NULL,
  "dateCloture" DATE NOT NULL,
  "observations_verif" VARCHAR(100) NOT NULL
);

COMMENT ON TABLE "verif_juridique" IS 'Structure de la table verif_juridique';

-- --------------------------------------------------------
-- Table: verif_juridique2
-- --------------------------------------------------------
DROP TABLE IF EXISTS "verif_juridique2";

CREATE TABLE "verif_juridique2" (
  "id_eng_verif2" SERIAL PRIMARY KEY,
  "refCf" VARCHAR(20) NOT NULL,
  "dateReception" DATE NOT NULL,
  "loginReception" VARCHAR(20) NOT NULL,
  "etatVerifDel" VARCHAR(15) NOT NULL,
  "etatVerif" INTEGER NOT NULL,
  "loginCloture" VARCHAR(20) NOT NULL,
  "autres" VARCHAR(100) NOT NULL,
  "dateCloture" DATE NOT NULL,
  "observations_verif" VARCHAR(100) NOT NULL
);

COMMENT ON TABLE "verif_juridique2" IS 'Structure de la table verif_juridique2';

-- --------------------------------------------------------
-- Vues
-- --------------------------------------------------------
CREATE OR REPLACE VIEW "view_listemotif" AS
SELECT
  t."id_tempmotif",
  t."numDef",
  t."id_motif",
  m."lib_motif"
FROM "temp_motif" t
LEFT JOIN "motif" m ON t."id_motif" = m."id_motif";

CREATE OR REPLACE VIEW "view_listepj" AS
SELECT
  p."id_piece",
  p."pj",
  p."id_pcop",
  pc."compte",
  pc."libelle_compte"
FROM "piece" p
LEFT JOIN "pcop" pc ON p."id_pcop" = pc."id_pcop";

CREATE OR REPLACE VIEW "view_rejet" AS
SELECT
  r."numDef",
  r."ministere",
  r."ordsec",
  r."categorie",
  r."compte",
  r."dateAccuse",
  r."dateRejetVisa" AS dateoperation,
  r."etatEng",
  r."cf_code",
  s."dateReception1"
FROM "tbl_rejet" r
JOIN "secretaire_aller1" s ON s."numDef" = r."numDef";

CREATE OR REPLACE VIEW "view_rejet2" AS
SELECT
  r."numDef",
  r."ministere",
  r."ordsec",
  r."categorie",
  r."compte",
  r."dateAccuse",
  r."dateRejetVisa" AS dateoperation,
  r."etatEng",
  r."cf_code",
  s."dateReception2"
FROM "tbl_rejet" r
JOIN "secretaire_aller2" s ON s."numDef" = r."numDef";

CREATE OR REPLACE VIEW "view_rejetsigfp" AS
SELECT
  r."numDef",
  r."ministere",
  r."ordsec",
  r."categorie",
  r."compte",
  r."dateAccuse",
  r."dateRejetVisa" AS dateoperation,
  r."etatEng",
  r."cf_code",
  s."dateReception1"
FROM "tbl_rejet" r
LEFT JOIN "secretaire_aller1" s ON s."numDef" = r."numDef";

CREATE OR REPLACE VIEW "view_tef" AS
SELECT
  t."numDef",
  t."ministere",
  t."ordsec",
  t."categorie",
  t."compte",
  t."dateAccuse",
  t."visaDate" AS dateoperation,
  t."etatEng",
  t."cf" AS cf_code,
  s."dateReception1"
FROM "tbl_tef" t
JOIN "secretaire_aller1" s ON s."numDef" = t."numDef";

CREATE OR REPLACE VIEW "view_tef2" AS
SELECT
  t."numDef",
  t."ministere",
  t."ordsec",
  t."categorie",
  t."compte",
  t."dateAccuse",
  t."visaDate" AS dateoperation,
  t."etatEng",
  t."cf" AS cf_code,
  s."dateReception2"
FROM "tbl_tef" t
JOIN "secretaire_aller2" s ON s."numDef" = t."numDef";

CREATE OR REPLACE VIEW "view_tefsigfp" AS
SELECT
  t."numDef",
  t."ministere",
  t."ordsec",
  t."categorie",
  t."compte",
  t."dateAccuse",
  t."visaDate" AS dateoperation,
  t."etatEng",
  t."cf" AS cf_code,
  s."dateReception1"
FROM "tbl_tef" t
LEFT JOIN "secretaire_aller1" s ON s."numDef" = t."numDef";

CREATE OR REPLACE VIEW "view_verif_aller2" AS
SELECT
  v."id_verif",
  v."decision",
  v."numDef",
  v."etat",
  e."id_eng",
  e."cf_code",
  e."exercice"
FROM "verif_aller1" v
LEFT JOIN "engagement" e ON v."numDef" = e."numDef"
WHERE v."decision" = 'faitretour';

CREATE OR REPLACE VIEW "v_eng_juridique2" AS
SELECT
  d."id_del",
  d."decision",
  d."refCf",
  d."etatDelForme",
  e."id_eng_jur",
  e."cf_code",
  e."ref_jur",
  e."objet_jur",
  e."type_jur",
  e."expediteur",
  e."compte",
  e."dateClotureSec",
  e."dateReceptionService",
  e."nomservice",
  e."exercice"
FROM "del_juridique" d
LEFT JOIN "eng_juridique" e ON d."refCf" = e."refCf";

CREATE OR REPLACE VIEW "v_faitretour" AS
SELECT
  d."id_del",
  d."numDef",
  d."decisionfinale",
  d."etatVerif2",
  d."etat",
  e."ministere",
  e."soa",
  e."categorie",
  e."compte",
  e."objet",
  e."montant",
  e."cf_code",
  e."exercice",
  s."etatSigfp2" AS etatsigfp2
FROM "del_aller1" d
JOIN "engagement" e ON d."numDef" = e."numDef"
JOIN "secretaire_aller1" s ON s."numDef" = d."numDef";

CREATE OR REPLACE VIEW "v_source_soumission2" AS
SELECT
  d."id_del",
  d."numDef",
  d."decisionfinale",
  d."etat",
  e."ministere",
  e."soa",
  e."categorie",
  e."compte",
  e."objet",
  e."montant",
  e."cf_code",
  e."exercice"
FROM "del_aller1" d
LEFT JOIN "engagement" e ON d."numDef" = e."numDef";

CREATE OR REPLACE VIEW "v_verif_aller2" AS
SELECT
  v."id_verif",
  v."decision",
  v."numDef",
  v."etat",
  e."id_eng",
  e."cf_code",
  e."exercice"
FROM "verif_aller1" v
LEFT JOIN "engagement" e ON v."numDef" = e."numDef";

-- --------------------------------------------------------
-- Réactiver les vérifications des contraintes
-- --------------------------------------------------------
SET session_replication_role = 'origin';

-- --------------------------------------------------------
-- Optionnel: Index pour améliorer les performances
-- --------------------------------------------------------
CREATE INDEX idx_engagement_numdef ON "engagement" ("numDef");
CREATE INDEX idx_del_aller1_numdef ON "del_aller1" ("numDef");
CREATE INDEX idx_secretaire_aller1_numdef ON "secretaire_aller1" ("numDef");
CREATE INDEX idx_user_multiple_login ON "user_multiple" ("login");

-- Optionnel: Index de recherche full-text sur pcop
-- CREATE INDEX idx_pcop_libelle_fts ON "pcop" USING GIN (to_tsvector('french', "libelle_compte"));