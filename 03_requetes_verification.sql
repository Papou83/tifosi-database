-- =============================================================
--  SCRIPT 3 — Requêtes de vérification de la base de données tifosi
--  10 requêtes de test avec résultats attendus et obtenus
-- =============================================================

USE tifosi;

-- =============================================================
-- REQUÊTE 1
-- But : Afficher la liste des noms des focaccias
--       par ordre alphabétique croissant.
-- =============================================================
-- Code SQL :
SELECT nom
FROM foccacia
ORDER BY nom ASC;

/*
Résultat attendu :
+------------------+
| nom              |
+------------------+
| Américaine       |
| Emmentalaccia    |
| Gorgonzollaccia  |
| Hawaienne        |
| Mozaccia         |
| Paysanne         |
| Raclaccia        |
| Tradizione       |
+------------------+
8 lignes

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. Les 8 focaccias sont triées
correctement par ordre alphabétique croissant.
*/


-- =============================================================
-- REQUÊTE 2
-- But : Afficher le nombre total d'ingrédients.
-- =============================================================
SELECT COUNT(*) AS nombre_ingredients
FROM ingredient;

/*
Résultat attendu :
+--------------------+
| nombre_ingredients |
+--------------------+
|                 25 |
+--------------------+

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. Les 25 ingrédients sont bien
enregistrés dans la table ingredient.
*/


-- =============================================================
-- REQUÊTE 3
-- But : Afficher le prix moyen des focaccias.
-- =============================================================
SELECT ROUND(AVG(prix), 2) AS prix_moyen
FROM foccacia;

/*
Résultat attendu :
+------------+
| prix_moyen |
+------------+
|      10.38 |
+------------+
(valeur exacte : 10.3750 €, arrondie à 2 décimales = 10.38)

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. Le prix moyen est calculé sur les 8
focaccias : (9.80+10.80+8.90+9.80+8.90+11.20+10.80+12.80) / 8
= 10.3750 ≈ 10.38 €.
*/


-- =============================================================
-- REQUÊTE 4
-- But : Afficher la liste des boissons avec leur marque,
--       triée par nom de boisson.
-- =============================================================
SELECT b.nom AS boisson, m.nom AS marque
FROM boisson b
JOIN marque m ON b.id_marque = m.id_marque
ORDER BY b.nom ASC;

/*
Résultat attendu :
+---------------------------+-----------+
| boisson                   | marque    |
+---------------------------+-----------+
| Capri-sun                 | Coca-cola |
| Coca-cola original        | Coca-cola |
| Coca-cola zéro            | Coca-cola |
| Eau de source             | Cristalline|
| Fanta citron              | Coca-cola |
| Fanta orange              | Coca-cola |
| Lipton Peach              | Pepsico   |
| Lipton zéro citron        | Pepsico   |
| Monster energy ultra blue | Monster   |
| Monster energy ultra gold | Monster   |
| Pepsi                     | Pepsico   |
| Pepsi Max Zéro            | Pepsico   |
+---------------------------+-----------+
12 lignes

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. La jointure entre boisson et marque
fonctionne correctement.
*/


-- =============================================================
-- REQUÊTE 5
-- But : Afficher la liste des ingrédients pour une Raclaccia.
-- =============================================================
SELECT i.nom AS ingredient
FROM ingredient i
JOIN comprend c ON i.id_ingredient = c.id_ingredient
JOIN foccacia f ON c.id_focaccia = f.id_focaccia
WHERE f.nom = 'Raclaccia'
ORDER BY i.nom ASC;

/*
Résultat attendu :
+-------------+
| ingredient  |
+-------------+
| Ail         |
| Base Tomate |
| Champignon  |
| Cresson     |
| Parmesan    |
| Poivre      |
| Raclette    |
+-------------+
7 lignes

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. Les 7 ingrédients de la Raclaccia
sont correctement récupérés via la double jointure.
*/


-- =============================================================
-- REQUÊTE 6
-- But : Afficher le nom et le nombre d'ingrédients
--       pour chaque focaccia.
-- =============================================================
SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nb_ingredients
FROM foccacia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY f.nom ASC;

/*
Résultat attendu :
+-----------------+----------------+
| focaccia        | nb_ingredients |
+-----------------+----------------+
| Américaine      |              8 |
| Emmentalaccia   |              7 |
| Gorgonzollaccia |              8 |
| Hawaienne       |              9 |
| Mozaccia        |             10 |
| Paysanne        |             12 |
| Raclaccia       |              7 |
| Tradizione      |              9 |
+-----------------+----------------+
8 lignes

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. Le GROUP BY sur id_focaccia garantit
un regroupement correct, même si deux focaccias portaient le même nom.
*/


-- =============================================================
-- REQUÊTE 7
-- But : Afficher le nom de la focaccia qui a le plus
--       d'ingrédients.
-- =============================================================
SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nb_ingredients
FROM foccacia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
HAVING COUNT(c.id_ingredient) = (
    SELECT MAX(nb)
    FROM (
        SELECT COUNT(id_ingredient) AS nb
        FROM comprend
        GROUP BY id_focaccia
    ) AS sous_requete
)
ORDER BY f.nom ASC;

/*
Résultat attendu :
+-----------+----------------+
| focaccia  | nb_ingredients |
+-----------+----------------+
| Paysanne  |             12 |
+-----------+----------------+
1 ligne

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. La sous-requête calcule le maximum
du nombre d'ingrédients, et la clause HAVING filtre la ou les
focaccias atteignant ce maximum.
*/


-- =============================================================
-- REQUÊTE 8
-- But : Afficher la liste des focaccias qui contiennent de l'ail.
-- =============================================================
SELECT f.nom AS focaccia
FROM foccacia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom ASC;

/*
Résultat attendu :
+-----------------+
| focaccia        |
+-----------------+
| Gorgonzollaccia |
| Mozaccia        |
| Paysanne        |
| Raclaccia       |
+-----------------+
4 lignes

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. L'Emmentalaccia et la Tradizione ne
contiennent pas d'ail, ce qui est cohérent avec les données source.
*/


-- =============================================================
-- REQUÊTE 9
-- But : Afficher la liste des ingrédients inutilisés
--       (non présents dans aucune focaccia).
-- =============================================================
SELECT i.nom AS ingredient_inutilise
FROM ingredient i
LEFT JOIN comprend c ON i.id_ingredient = c.id_ingredient
WHERE c.id_focaccia IS NULL
ORDER BY i.nom ASC;

/*
Résultat attendu :
+---------------------+
| ingredient_inutilise|
+---------------------+
| Salami              |
| Tomate cerise       |
+---------------------+
2 lignes

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. Le Salami et la Tomate cerise existent
dans la table ingredient mais n'apparaissent dans aucune focaccia.
La jointure externe (LEFT JOIN) avec filtre IS NULL est la méthode
appropriée pour détecter les enregistrements orphelins.
*/


-- =============================================================
-- REQUÊTE 10
-- But : Afficher la liste des focaccias qui n'ont pas
--       de champignons.
-- =============================================================
SELECT f.nom AS focaccia
FROM foccacia f
WHERE f.id_focaccia NOT IN (
    SELECT c.id_focaccia
    FROM comprend c
    JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    WHERE i.nom = 'Champignon'
)
ORDER BY f.nom ASC;

/*
Résultat attendu :
+------------+
| focaccia   |
+------------+
| Américaine |
| Hawaienne  |
+------------+
2 lignes

Résultat obtenu : identique au résultat attendu.
Commentaire : Aucun écart. Les focaccias Américaine et Hawaienne
ne contiennent effectivement pas de champignons, ce qui est
cohérent avec le fichier source focaccia.xlsx.
La sous-requête avec NOT IN est une alternative lisible à
l'approche LEFT JOIN + IS NULL.
*/
