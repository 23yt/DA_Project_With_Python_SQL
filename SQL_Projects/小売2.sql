#sales part
#checking the sales volume which is the number of renting out from 2005/05 to 2005/08

select * from rental;
select count(*) as sale_vol from rental where rental_date between '2005-05-01' and '2005-08-31';

#checking the sales volumes by each months from 2005/05 to 2005/08

select substring(rental_date,6,2) as month, count(*) as rental_vol from rental group by 1;

#ranking the sales volumns of the staffs to see their sales status

select * from staff;
select count(*) as rental_vol, rental.staff_id, staff.first_name, staff.last_name from rental join staff 
on rental.staff_id = staff.staff_id group by 2 order by 1;

#inventory part
#checking the inventory status for each film in each stores

select * from inventory;
select film_id, store_id, count(inventory_id) as num_of_inventory from inventory group by 1, 2;

#showing the names for each films

select * from film;
select i.film_id, film.title, i.store_id, count(i.inventory_id) as num_of_inventory from inventory as i 
join film on i.film_id = film.film_id group by 1, 3;

#showing which category each films belong to

select * from film;
select * from category;
select * from inventory;
select * from film_category;
select film.film_id, film.title, i.store_id, c.name as category, count(i.inventory_id) as num_of_inventory from film
left join inventory as i on film.film_id = i.film_id left join film_category as fc on film.film_id = fc.film_id 
left join category as c on fc.category_id = c.category_id group by 1, 3;

#saving the inventory status into a table for future use purpose

create table inventory_rep as
select film.film_id, film.title, i.store_id, c.name as category, count(i.inventory_id) as num_of_inventory from film
left join inventory as i on film.film_id = i.film_id left join film_category as fc on film.film_id = fc.film_id 
left join category as c on fc.category_id = c.category_id group by 1, 3;

#finding out which films have 0 inventory

select * from inventory_rep where num_of_inventory = 0;

#Revenue part
#checking the revenue made by each months from  2005/05 to 2005/08

select * from payment;
select substring(payment_date, 1, 7) as month, sum(amount) as revenue from payment 
where payment_date between "2005-05-01 00:00:00" and "2005-08-31 23:59:59" group by 1;

#checking the revenue made by each stores from 2005/05 to 2005/08

select * from staff;
select s.store_id as store, sum(p.amount) as revenue from staff as s left join payment as p 
on s.staff_id = p.staff_id where p.payment_date between "2005-05-01 00:00:00" 
and "2005-08-31 23:59:59" group by 1;

#joining tables to see which films are popular or unpopular

select * from rental;
select * from film;
select * from inventory;
select * from category;
select * from film_category;
select film.film_id, film.title as film_name, c.name as catagory, count(rental_id) from rental 
left join inventory as i on rental.inventory_id = i.inventory_id left join film
on film.film_id = i.film_id left join film_category as fc on film.film_id = fc.film_id 
left join category as c on fc.category_id = c.category_id group by 1 order by 4 asc;

#customer part
#finding out how many films did each customers rent and ranking it to check the loyalty customers

select * from customer;
select * from rental;
select c.customer_id, c.first_name, c.last_name, count(rental_id) as total_rented from rental as r
left join customer as c on r.customer_id = c.customer_id group by 1 order by 4 desc;

#which kind of categories are the most popular among the customers

select c.name as categoty, count(rental_id) from rental left join inventory as i 
on rental.inventory_id = i.inventory_id left join film_category as fc on i.film_id = fc.film_id 
left join category as c on fc.category_id = c.category_id group by 1 order by 2 desc;

#how many rentals were not returned from customer

select count(*) as num_nonreturn from rental where return_date is null;

#which customers were having larger risk of non returning films

select r.rental_id, c.first_name, c.last_name, count(*) as total from rental as r left join customer 
as c on r.customer_id = c.customer_id where r.return_date is null group by 1 order by 1;

#which staffs are more likely to rent out to a risky customer

select r.staff_id, staff.first_name, staff.last_name, count(*) as total from rental as r 
left join staff on r.staff_id = staff.staff_id where r.return_date is null group by 1;
