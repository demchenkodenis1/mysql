DROP FUNCTION IF EXISTS is_row_exists;
DELIMITER //

CREATE FUNCTION is_row_exists (content_id INT, content_type VARCHAR(50))
RETURNS BOOLEAN READS SQL DATA

BEGIN
  CASE content_type
    WHEN 'songs' THEN
      RETURN EXISTS(SELECT 1 FROM songs WHERE id = content_id);
    WHEN 'playlists' THEN 
      RETURN EXISTS(SELECT 1 FROM playlists WHERE id = content_id);
    WHEN 'perfomer' THEN
      RETURN EXISTS(SELECT 1 FROM perfomer WHERE id = content_id);
    ELSE 
      RETURN FALSE;
  END CASE;
END//

DELIMITER ;

SELECT is_row_exists(5, 'songs');

drop trigger if exists favorites_validation;
DELIMITER //
create trigger favorites_validation before
insert
	on
	favorites for each row begin if not is_row_exists(NEW.content_id,
	NEW.content_type) then signal sqlstate "45000" set
	MESSAGE_TEXT = "Error adding like! Target table doesn't contain row id provided!";
end if;
end //
DELIMITER ;

INSERT INTO favorites (user_id, content_id, content_type) VALUES (1, 8, 'playlists');
select * from favorites;
select * from vk.likes;

-- Просмотр функций и процедур
SHOW FUNCTION STATUS LIKE 'is_row_exists';
SHOW CREATE FUNCTION is_row_exists;
