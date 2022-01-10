#

#doing some exploration on some product related tables which is the films

select count(*), count(actor_id), count(distinct actor_id) from actor;
#200

select count(*), count(actor_id), count(distinct actor_id) from film_actor;
#5462 and 200 actors

select count(*), count(film_id), count(distinct film_id) from film_actor;
#5462 and 997 films

select count(*), count(film_id), count(distinct film_id) from film;
#1000 fims

select * from actor limit 500;
select * from film_actor limit 500;
select * from film limit 500;
select * from language limit 500;
select * from film_category limit 500;
select * from category limit 500;

#checking the maximum rental rate for each rating of films

select rating, max(rental_rate) as max_rental from film group by 1;

#checking the number of films under each rating

select rating, count(firm_id) as num_firm from film group by 1;

#creating a segmetation for the length of films; three level: short, standard and long, and count the number of films in each level of length

select case when length < 60 then 'short' when length <120 then 'standard' 
when length >= 120 then 'long' end as film_length, count(distinct film_id) from film group by 1;

#listing the actors who have the last name Johansson

select * from actor where last_name = 'Johansson';

#listing all the actors who have the distinct last name

select count(distinct last_name) as dist_name from actor;

#listing the last names which only appear once

select last_name, count(*) as num_dist from actor group by 1 having num_dist = 1;

#listing the last names which appear more than once

select last_name, count(*) as num_dist from actor group by 1 having num_dist > 1;

#checking how many actors in each films

select film_id, count(distinct actor_id) as num_actor from film_actor group by 1 order by num_actor desc;

#since one actor can play in more than one film, checking how many films each actors played in

select actor_id, count(distinct film_id) as num_play from film_actor group by 1;

#finding out the language used for each films

select * from film;
select * from language;
select name, film_id, title from film join language on film.language_id = language.language_id;

#displaying the actor names for each actor id and the films they played

select * from actor;
select * from film;
select actor.actor_id, first_name, last_name, title, film.film_id from film_actor, actor, film 
where actor.actor_id = film_actor.actor_id and film.film_id = film_actor.film_id;

#adding the catogory name for each films into the table film

select * from film_category;
select * from category;
select * from film;
select film.*, ca.name from film, film_category as fc, category as ca 
where ca.category_id = fc.category_id and fc.film_id = film.film_id;

#displaying the films which have rental rate bigger than 2 and film rating is G, PG-13 and PG

select * from film where rating in ('G', 'PG-13', 'PG') and rental_rate > 2;
