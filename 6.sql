-- включающие группировки
 select
	content_type as type_of_content,
	count(user_id) as count_of_users
from
	favorites
group by
	content_type;

-- Количество избранных плэйлистов 
 select
	(
	select
		content_type
	from
		favorites
	where
		user_id = playlists.user_id) as content_type,
	COUNT(*) as total
from
	playlists
group by
	content_type
order by
	total desc
limit 1;

-- Количество избранных плэйлистов (вариант с JOIN)
 select
	favorites.content_type,
	COUNT(*) as total
from
	favorites
join playlists on
	favorites.user_id = playlists.user_id
group by
	content_type
order by
	total desc
limit 1;

-- Наглядное количество песен, плейлистов, исполнителей в избранном по пользователям
select
	users.first_name,
	users.last_name,
	COUNT(distinct songs.id) as total_songs,
	COUNT(distinct playlists.id) as total_playlists,
	COUNT(distinct perfomer.id) as total_perfomer
from
	users
left join songs on
	users.id = songs.id
left join playlists on
	users.id = playlists.user_id
left join perfomer on
	users.id = perfomer.id
group by
	users.id;

-- Из каких стран пользователи приложения    
select
	countries.name as countries,
	users.first_name,
	users.last_name
from
	users
left join countries on
	users.id = countries.id
order by
	countries.name;

select
	*
from
	songs;

-- Выборка песен продолжительностью более 15 мин
 select
	*
from
	songs
where
	ID in (
	select
		ID
	from
		songs
	where
		song_duration > 15);