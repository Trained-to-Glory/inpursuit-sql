
DROP TRIGGER add_thumbnail_to_pursuit;

delimiter |

CREATE TRIGGER add_thumbnail_to_pursuit AFTER INSERT ON posts
  FOR EACH ROW
  BEGIN
    UPDATE pursuits SET thumbnailUrl = NEW.thumbnailUrl WHERE pursuitId = NEW.pursuitId;
  END;
|

delimiter ;

DROP TRIGGER add_to_pursuit_response;

delimiter |

CREATE TRIGGER add_to_pursuit_response AFTER INSERT ON posts
  FOR EACH ROW
  BEGIN
     IF NEW.is_response = 1 THEN BEGIN
     INSERT INTO posts_responses SET postId = NEW.postId && pursuitId = NEW.pursuitId && userId = NEW.userId;
    END; END IF;
  END;
|

delimiter ;

DROP TRIGGER add_pursuit_to_similar_pursuit;

delimiter |

CREATE TRIGGER add_pursuit_to_similar_pursuit AFTER INSERT ON pursuits
  FOR EACH ROW
  BEGIN
     IF NEW.is_tried = 1 THEN BEGIN
     INSERT INTO similar_pursuit SET pursuitId = NEW.pursuitId && new_pursuitId = NEW.old_pursuitId;
    END; END IF;
  END;
|

delimiter ;


DROP TRIGGER save_post_trigger;

delimiter |

CREATE TRIGGER save_post_trigger BEFORE INSERT ON posts_saved
  FOR EACH ROW
  BEGIN
   IF NEW.postId = OLD.postId && NEW.userId = OLD.userId THEN
               DELETE FROM posts_saved WHERE postId = NEW.postId && userId = NEW.userId;
           ELSEIF NEW.postId != OLD.postId && NEW.userId != OLD.userId THEN
               INSERT INTO posts_saved SET postId = NEW.postId && userId = NEW.userId && is_saved = NEW.is_saved;
           END IF;
  END;
|

delimiter ;
