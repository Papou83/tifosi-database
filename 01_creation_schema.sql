-- =============================================================
--  SCRIPT 1 — Création du schéma de la base de données tifosi
--  Restaurant Le Tifosi — Street-Food italien
-- =============================================================

-- Création de la base de données
CREATE DATABASE IF NOT EXISTS tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Création de l'utilisateur et attribution des droits
CREATE USER IF NOT EXISTS 'tifosi'@'localhost' IDENTIFIED BY 'Tif0si#Secure2024!';
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;

USE tifosi;

-- =============================================================
--  TABLE : marque
-- =============================================================
CREATE TABLE IF NOT EXISTS marque (
    id_marque   INT             NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)     NOT NULL,
    CONSTRAINT pk_marque    PRIMARY KEY (id_marque),
    CONSTRAINT uq_marque_nom UNIQUE (nom)
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : boisson
-- =============================================================
CREATE TABLE IF NOT EXISTS boisson (
    id_boisson  INT             NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)     NOT NULL,
    id_marque   INT             NOT NULL,
    CONSTRAINT pk_boisson       PRIMARY KEY (id_boisson),
    CONSTRAINT uq_boisson_nom   UNIQUE (nom),
    CONSTRAINT fk_boisson_marque
        FOREIGN KEY (id_marque) REFERENCES marque(id_marque)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : ingredient
-- =============================================================
CREATE TABLE IF NOT EXISTS ingredient (
    id_ingredient   INT         NOT NULL AUTO_INCREMENT,
    nom             VARCHAR(50) NOT NULL,
    CONSTRAINT pk_ingredient        PRIMARY KEY (id_ingredient),
    CONSTRAINT uq_ingredient_nom    UNIQUE (nom)
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : foccacia
-- =============================================================
CREATE TABLE IF NOT EXISTS foccacia (
    id_focaccia INT              NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)      NOT NULL,
    prix        DECIMAL(5,2)     NOT NULL CHECK (prix > 0),
    CONSTRAINT pk_foccacia      PRIMARY KEY (id_focaccia),
    CONSTRAINT uq_foccacia_nom  UNIQUE (nom)
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : comprend  (association foccacia ↔ ingredient)
-- =============================================================
CREATE TABLE IF NOT EXISTS comprend (
    id_focaccia     INT     NOT NULL,
    id_ingredient   INT     NOT NULL,
    quantite        INT     NOT NULL CHECK (quantite > 0),
    CONSTRAINT pk_comprend PRIMARY KEY (id_focaccia, id_ingredient),
    CONSTRAINT fk_comprend_focaccia
        FOREIGN KEY (id_focaccia)   REFERENCES foccacia(id_focaccia)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_comprend_ingredient
        FOREIGN KEY (id_ingredient) REFERENCES ingredient(id_ingredient)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : client
-- =============================================================
CREATE TABLE IF NOT EXISTS client (
    id_client   INT             NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)     NOT NULL,
    email       VARCHAR(150)    NOT NULL,
    code_postal INT             NOT NULL,
    CONSTRAINT pk_client        PRIMARY KEY (id_client),
    CONSTRAINT uq_client_email  UNIQUE (email)
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : menu
-- =============================================================
CREATE TABLE IF NOT EXISTS menu (
    id_menu     INT             NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)     NOT NULL,
    prix        DECIMAL(5,2)    NOT NULL CHECK (prix > 0),
    CONSTRAINT pk_menu      PRIMARY KEY (id_menu),
    CONSTRAINT uq_menu_nom  UNIQUE (nom)
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : contient  (association menu ↔ boisson)
-- =============================================================
CREATE TABLE IF NOT EXISTS contient (
    id_menu     INT NOT NULL,
    id_boisson  INT NOT NULL,
    CONSTRAINT pk_contient PRIMARY KEY (id_menu, id_boisson),
    CONSTRAINT fk_contient_menu
        FOREIGN KEY (id_menu)    REFERENCES menu(id_menu)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_contient_boisson
        FOREIGN KEY (id_boisson) REFERENCES boisson(id_boisson)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : achete  (association client ↔ menu)
-- =============================================================
CREATE TABLE IF NOT EXISTS achete (
    id_client   INT     NOT NULL,
    id_menu     INT     NOT NULL,
    date_achat  DATE    NOT NULL,
    CONSTRAINT pk_achete PRIMARY KEY (id_client, id_menu, date_achat),
    CONSTRAINT fk_achete_client
        FOREIGN KEY (id_client) REFERENCES client(id_client)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_achete_menu
        FOREIGN KEY (id_menu)   REFERENCES menu(id_menu)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =============================================================
--  TABLE : est_constitue  (association menu ↔ foccacia)
-- =============================================================
CREATE TABLE IF NOT EXISTS est_constitue (
    id_menu     INT NOT NULL,
    id_focaccia INT NOT NULL,
    CONSTRAINT pk_est_constitue PRIMARY KEY (id_menu, id_focaccia),
    CONSTRAINT fk_ec_menu
        FOREIGN KEY (id_menu)    REFERENCES menu(id_menu)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ec_focaccia
        FOREIGN KEY (id_focaccia) REFERENCES foccacia(id_focaccia)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
