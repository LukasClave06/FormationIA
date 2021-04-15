USE sakila;

### REQUETES AVANCEES

# 1.Afficher tout les emprunt ayant été réalisé en 2006. Le mois doit être écrit en toute
#   lettre et le résultat doit s’afficher dans une seul colonne.

select *, concat(day(rental_date),
    ' ', 
    CASE MONTH(rental_date)
         WHEN 1 THEN 'janvier'
         WHEN 2 THEN 'février'
         WHEN 3 THEN 'mars'
         WHEN 4 THEN 'avril'
         WHEN 5 THEN 'mai'
         WHEN 6 THEN 'juin'
         WHEN 7 THEN 'juillet'
         WHEN 8 THEN 'août'
         WHEN 9 THEN 'septembre'
         WHEN 10 THEN 'octobre'
         WHEN 11 THEN 'novembre'
         ELSE 'décembre'
	END, 
    ' ', 
    year(rental_date)) as cas_du_case,
    concat(day(rental_date),' ',MONTHNAME(rental_date),' ',year(rental_date)),
    DATE_FORMAT(rental_date, '%d %M %Y')
from rental
where year(rental_date) = 2006 ;

# 2.Afficher la colonne qui donne la durée de location des films en jour.

select *, datediff(return_date, rental_date) as duree_location
from rental;

# 3.Afficher les emprunts réalisés avant 1h du matin en 2005. Afficher la date dans un
#   format lisible.

select *,DATE_FORMAT(rental_date, '%d %M %Y')
from rental
where year(rental_date) = 2005
and TIME(rental_date) < '01:00:00';

# 4.Afficher les emprunts réalisé entre le mois d’avril et le moi de mai. La liste doit être
#   trié du plus ancien au plus récent.

select * 
from rental
where month(rental_date) in (4,5)
order by rental_date;

# 5.Lister les film dont le nom ne commence pas par le « Le ».

select title 
from film
where LEFT(title,2) != 'Le';

# 6.Lister les films ayant la mention « PG-13 » ou « NC-17 ». Ajouter une colonne qui
#   affichera « oui » si « NC-17 » et « non » Sinon.

select	*, if(rating='NC-17','oui','non') as 'avec_is'
from film
where rating in ('PG-13','NC-17');

# 7.Fournir la liste des catégorie qui commence par un ‘A’ ou un ‘C’. (Utiliser LEFT).

select * 
from category
where LEFT(name,1) in ('A','C');
       
# 8.Lister les trois premiers caractères des noms des catégorie.

select LEFT(name,3)
from category;

# 9.Lister les premiers acteurs en remplaçant dans leur prenom les E par des A.

select *, replace(first_name,'E','A') as modified_first_name
from actor
LIMIT 100;



### JOINTURES

#1. Lister les 10 premiers films ainsi que leur langues.

SELECT title, name
FROM film
JOIN language on film.language_id = language.language_id
LIMIT 10;

#2. Afficher les film dans les quel à joué « JENNIFER DAVIS » sortie en 2006.

SELECT title, first_name, last_name, film_actor.last_update
FROM film
JOIN film_actor on film.film_id = film_actor.actor_id
JOIN actor on film_actor.actor_id = actor.actor_id
WHERE actor.first_name = "JENNIFER" AND actor.last_name = "DAVIS" AND year(film_actor.last_update) = 2006  ;

#3. Afficher le noms des client ayant emprunté « ALABAMA DEVIL ».

SELECT last_name, first_name, title 
FROM customer 
JOIN rental on customer.customer_id = rental.customer_id
JOIN inventory on rental.inventory_id = inventory.inventory_id
JOIN film on inventory.film_id = film.film_id
WHERE (film.title = 'ALABAMA DEVIL');

#4. Afficher les films louer par des personne habitant à « Woodridge ».
#   Vérifié s’il y a des films qui n’ont jamais été emprunté.

SELECT last_name, first_name, city, title
FROM city
JOIN address on city.city_id = address.city_id
JOIN customer on address.address_id = customer.address_id
JOIN rental on customer.customer_id = rental.customer_id
JOIN inventory on rental.inventory_id = inventory.inventory_id
JOIN film on inventory.film_id = film.film_id
WHERE city = 'Woodridge';

SELECT title
FROM film
JOIN inventory on inventory.film_id = film.film_id
LEFT JOIN rental on rental.inventory_id = inventory.inventory_id
WHERE rental.rental_id IS NULL ;

#5. Quel sont les 10 films dont la durée d’emprunt à été la plus courte ?

SELECT DISTINCT title,TIMEDIFF(return_date, rental_date) as temps_emprunt
FROM rental
JOIN inventory on rental.rental_id = inventory.inventory_id
JOIN film on inventory.inventory_id = film.film_id
ORDER BY temps_emprunt ASC
LIMIT 10;

#6. Lister les films de la catégorie « Action » ordonnés par ordre alphabétique.

SELECT F.title
FROM film as F
JOIN film_category as FC on FC.film_id = F.film_id
JOIN category as C on FC.category_id = C.category_id
WHERE C.name = 'Action'
ORDER BY F.title;
    
#7. Quel sont les films dont la duré d’emprunt à été inférieur à 2 jour ?

SELECT DISTINCT F.title, DATEDIFF(return_date, rental_date) as temps_emprunt
FROM film as F
JOIN inventory as I on F.film_id = I.film_id
JOIN rental as R on I.inventory_id = R.inventory_id
WHERE DATEDIFF(return_date, rental_date) < 2
ORDER BY temps_emprunt;
    