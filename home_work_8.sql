-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?      
select * from likes;
select * from profiles;  
-- верное решение
SELECT
	(SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender,
	COUNT(*) AS total
    FROM likes
    GROUP BY gender
    ORDER BY total DESC
    LIMIT 1;  
-- Вариант с JOIN
select profiles.gender,
COUNT(*) as total
from
profiles
join likes on
profiles.user_id = likes.user_id GROUP BY gender ORDER BY total desc LIMIT 1;

-- 4. Вывести для каждого пользователя количество созданных сообщений, постов, загруженных медиафайлов и поставленных лайков.

   SELECT 
  CONCAT(first_name, ' ', last_name) AS user,
  (SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS total_messages,
  (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id) AS total_posts,  
	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id) AS total_media, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) AS total_likes
	  FROM users;
	 
-- Вариант с JOIN
desc messages;
desc users;
desc profiles;
desc posts;

-- Получилось только отдельно по типам таргета
select CONCAT(first_name, ' ', last_name) as user,
count(*) as total_messages
from
users
join messages on
messages.from_user_id = users.id
group by
users.id;

select CONCAT(first_name, ' ', last_name) as user,
count(*) as total_posts
from
users
join posts on
posts.user_id = users.id
group by
users.id;

select CONCAT(first_name, ' ', last_name) as user,
count(*) as total_media
from
users
join media on
media.user_id = users.id
group by
users.id;

select CONCAT(first_name, ' ', last_name) as user,
count(*) as total_likes
from
users
join likes on
likes.user_id = users.id
group by
users.id;
-- 
select CONCAT(first_name, ' ', last_name) as user,
count(*) as total_messages
from
users
join messages on
messages.from_user_id = users.id
group by
users.id;

	 
-- 5. (по желанию) Подсчитать количество лайков которые получили 10 самых последних сообщений.

SELECT SUM(likes_total) FROM  
  (SELECT 
    (SELECT COUNT(*) FROM likes 
      WHERE target_id = messages.id AND target_type = 'messages') AS likes_total  
    FROM messages
    ORDER BY created_at DESC 
    LIMIT 10) AS messages_likes;  

   -- второй способ	 
	 SELECT COUNT(*) FROM likes 
  WHERE target_type = 'messages'
    AND target_id IN (SELECT * FROM (
      SELECT id FROM messages 
        ORDER BY created_at DESC LIMIT 10) AS sorted_messages);	  

-- Вариант с JOIN

select * from messages;
select * from likes;     

-- Получилось посчитать сколько всего лайков у таргета messages, ограничить не получилось
select COUNT(messages.id) AS likes_total  
from messages
join likes
on target_id = messages.id where target_type = 'messages' ORDER BY messages.created_at DESC LIMIT 10;

-- В этом варианте получилось детально 
SELECT users.id, first_name, last_name, COUNT(likes.id) AS total_likes, messages.created_at
  FROM users
    LEFT JOIN messages
      ON users.id = messages.id
    LEFT JOIN likes
      ON messages.id = likes.target_id
        AND target_type = 'messages'
  GROUP BY users.id
  ORDER BY messages.created_at DESC
  LIMIT 10;
  
 