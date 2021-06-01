-- Представления

-- 1
select
	*
from
	genre;

drop view genre_view;

create view genre_view as
select
	name,
	song_id
from
	genre;

select
	*
from
	genre_view;
-- 2
 select
	*
from
	concerts;

drop view concerts_view;

create view concerts_view as
select
	date_of_concerts,
	countries_id
from
	concerts;

select
	*
from
	concerts_view;

-- 3
drop view vw_favorites_users;

create view vw_favorites_users as
select
	distinct CONCAT (users.first_name,
	" ",
	users.last_name) as name
from
	users, favorites f where
	users.id = f.user_id and content_type = "songs";

select
	*
from
	vw_favorites_users;

select * from favorites;
select * from users;
