-- Создаём таблицу пользователей
DROP TABLE IF EXISTS users;

create table users (id INT unsigned not null auto_increment primary key COMMENT "Идентификатор строки",
first_name VARCHAR(100) not null COMMENT "Имя пользователя",
last_name VARCHAR(100) not null COMMENT "Фамилия пользователя",
email VARCHAR(100) not null unique COMMENT "Почта",
cities_id INT unsigned COMMENT "Ссылка на город",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "Время создания строки",
updated_at DATETIME default CURRENT_TIMESTAMP on
update
	CURRENT_TIMESTAMP COMMENT "Время обновления строки" ) COMMENT "Пользователи";


update
	users
set
	created_at = str_to_date(created_at,
	'%d.%m.%Y %h:%i'),
	updated_at = STR_TO_DATE(updated_at,
	'%d.%m.%Y %h:%i');

alter table users change created_at created_at datetime default current_timestamp;

alter table users change updated_at updated_at datetime default current_timestamp on
update
	current_timestamp;

desc subscribers;

ALTER TABLE users DROP INDEX users_last_name_idx;
ALTER TABLE users DROP INDEX users_first_name_last_name_idx;
ALTER TABLE users DROP index users_email_uq;

CREATE INDEX users_last_name_idx ON users(last_name);
CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);
CREATE UNIQUE INDEX users_email_uq ON users(email);
SHOW INDEX FROM users;


-- Создаём таблицу подписчиков
DROP TABLE IF EXISTS subscribers;
truncate subscribers;
create table subscribers (id INT unsigned not null COMMENT "Ссылка на пользователя",
user_id INT unsigned not null COMMENT "Ссылка на подписчика",
subscription_statuses__id INT unsigned not null COMMENT "Ссылка на статус (текущее состояние) подписки",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "Время создания строки",
updated_at DATETIME default CURRENT_TIMESTAMP on
update
	CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	primary key (id) COMMENT "Составной первичный ключ" ) COMMENT "Подписчики";

-- Таблица статусов подписки
DROP TABLE IF EXISTS subscription_statuses;

CREATE TABLE subscription_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name enum("subscribe", "subscribed") NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Статусы подписки";
TRUNCATE subscription_statuses;

INSERT INTO subscription_statuses (name) VALUES
  ('subscribe'),
  ('subscribed');
 
 UPDATE subscribers SET subscription_statuses__id = FLOOR(1 + RAND() * 2); 



-- Создаём таблицу подписок
DROP TABLE IF EXISTS subscriptions;

CREATE TABLE  subscriptions (
  users_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Ссылка на пользователя",
  perfomer_id INT UNSIGNED NOT NULL COMMENT "Ссылка на исполнителя", 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Подписки";  

-- Создаём таблицу альбомов
DROP TABLE IF EXISTS albums;

CREATE TABLE  albums (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Название альбома",
  release_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания альбома",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Альбомы";

-- Создаём таблицу плэйлистов
DROP TABLE IF EXISTS playlists;
  
CREATE TABLE  playlists (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Название альбома",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя", 
  song_id INT UNSIGNED NOT NULL COMMENT "Ссылка на песню",
  subscribers_id INT unsigned COMMENT "Ссылка на подписчика",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Плэйлисты";

-- Создаём таблицу исполнителей
DROP TABLE IF EXISTS perfomer;
  
CREATE TABLE perfomer (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  song_id INT UNSIGNED NOT NULL COMMENT "Ссылка на песню",
  discography_id INT UNSIGNED NOT NULL COMMENT "Ссылка на дискографию",
  playlists_id INT UNSIGNED NOT NULL COMMENT "Ссылка на плэйлист",
  subscribers_id INT unsigned COMMENT "Ссылка на подписчика",
  merchbar_link VARCHAR(150) COMMENT "Ссылка на мерч",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Исполнители";

TRUNCATE perfomer;


UPDATE perfomer SET merchbar_link = CONCAT(
  'https://www.merchbar/',
  merchbar_link,
  '.com');

-- Создаём таблицу песен
DROP TABLE IF EXISTS songs;
  
CREATE TABLE `songs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Название песни',
  `song_duration` int(10) unsigned NOT NULL COMMENT 'Продолжительность песни',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Песни';
select * from songs order by song_duration;
update songs set song_duration = 5 where songs.id = 86;


-- Создаём таблицу концертов
DROP TABLE IF EXISTS concerts;
  
CREATE TABLE concerts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  date_of_concerts DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата выступления",  
  perfomer_id INT UNSIGNED NOT NULL COMMENT "Ссылка на исполнителя", 
  countries_id INT UNSIGNED NOT null COMMENT "Ссылка на страну",
  cities_id INT UNSIGNED NOT NULL COMMENT "Ссылка на город",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Концерты";

-- Создаём таблицу городов
DROP TABLE IF EXISTS cities;

create table cities ( id INT unsigned not null auto_increment primary key COMMENT "Идентификатор строки",
name VARCHAR(150) not null COMMENT "Название города",
countries_id INT unsigned COMMENT "Ссылка на страну",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "Время создания строки",
updated_at DATETIME default CURRENT_TIMESTAMP on
update
	CURRENT_TIMESTAMP COMMENT "Время обновления строки" ) COMMENT "Города";

-- Создаём таблицу стран
DROP TABLE IF EXISTS countries;

create table countries ( id INT unsigned not null auto_increment primary key COMMENT "Идентификатор строки",
name VARCHAR(150) not null COMMENT "Название страны",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "Время создания строки",
updated_at DATETIME default CURRENT_TIMESTAMP on
update
	CURRENT_TIMESTAMP COMMENT "Время обновления строки" ) COMMENT "Страны";
ALTER TABLE countries MODIFY COLUMN name VARCHAR(150) NOT NULL UNIQUE;
select * from countries order by name;

-- Создаём таблицу дискографии
DROP TABLE IF EXISTS discography;
  
CREATE TABLE discography (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  album_id INT UNSIGNED NOT NULL COMMENT "Ссылка на альбом",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Дискография";

-- Создаём таблицу жанров
DROP TABLE IF EXISTS genre;
  
CREATE TABLE genre (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(100) NOT NULL COMMENT "Название жанра",
  song_id INT UNSIGNED NOT NULL COMMENT "Ссылка на песню",
  playlists_id INT UNSIGNED NOT NULL COMMENT "Ссылка на плэйлист",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Жанры";

-- Создаём таблицу журнал недавно прослушанного
DROP TABLE IF EXISTS recently_listened;
  
CREATE TABLE recently_listened (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  date_of_hearing DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата прослушивания",   
  song_id INT UNSIGNED NOT NULL COMMENT "Ссылка на песню",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Журнал недавно прослушанного";

-- Создаём таблицу избранных
DROP TABLE IF EXISTS favorites;
  
CREATE TABLE favorites (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, поставившего в избранное",
  content_type ENUM ('songs', 'playlists', 'perfomer') NOT NULL COMMENT "Тип контента, который выбирают",
  content_id INT UNSIGNED NOT NULL COMMENT "Ид. контента",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
  ) COMMENT "Таблица избранных";


-- Временная таблица типов контента в избранном
DROP TABLE IF EXISTS target_types;
CREATE TEMPORARY TABLE target_types (
  name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO target_types (name) VALUES 
  ('songs'),
  ('playlists'),
  ('perfomer');



