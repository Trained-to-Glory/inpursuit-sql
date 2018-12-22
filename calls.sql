-- SELECT IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") as pursuit_array,
--   CASE WHEN posts.is_step = 1 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as steps,
--   CASE WHEN posts.is_principle = 1 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as principles,
--   CASE WHEN posts.is_step = 0 && posts.is_principle = 0 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as posts,
--   (SELECT JSON_OBJECT("usersId", users.userId, "photoUrl", users.photoUrl, "username", users.username) FROM users WHERE posts.userId = users.userId)
--   FROM posts JOIN user_interests ON user_interests.interestId = posts.interestId
--   AND user_interests.userId = 'vdjf4xE59cYtmQA6CBApQN2k3Wz2' ORDER BY posts.created_at;
--
-- SELECT IFNULL(
--   JSON_OBJECT('postId', posts.postId, 'postThumbnail', posts.thumbnailUrl,
--      'stepId', steps.stepId, 'stepThumbnail', steps.thumbnailUrl, 'stepDescription', steps.stepDescription,
--       'principleId', principles.principleId, 'principleThumbnail', principles.thumbnailUrl,
--       'principleDescription', principles.principleDescription, 'userId', users.userId,
--       'profilePicture', users.photoUrl, 'username', users.username,
--       'pursuitDescription', pursuits.pursuitDescription), "{}") as returned_content,
--       IFNULL((SELECT JSON_OBJECT("principleId", principles.principleId, "thumbnailUrl",
--       principles.thumbnailUrl, "principleDescription", principles.principleDescription) FROM principles
--       WHERE principles.pursuitId = pursuits.pursuitId
--       ORDER BY principles.created_at), "{}") as principles,
--       IFNULL((SELECT JSON_OBJECT("stepId", steps.stepId, "thumbnailUrl",
--       steps.thumbnailUrl, "stepDescription", steps.stepDescription) FROM steps WHERE steps.pursuitId = pursuits.pursuitId
--       ORDER BY steps.created_at), "{}") as steps
-- FROM pursuits JOIN user_interests ON user_interests.interestId = pursuits.interestId
-- AND user_interests.userId = 'vdjf4xE59cYtmQA6CBApQN2k3Wz2'
-- JOIN users ON users.userId = pursuits.userId
-- LEFT JOIN posts ON posts.pursuitId = pursuits.pursuitId
-- LEFT JOIN steps ON steps.pursuitId = pursuits.pursuitId
-- LEFT JOIN principles ON principles.pursuitId = pursuits.pursuitId;
--
--
-- SELECT interestId FROM pursuits JOIN
-- user_interests ON user_interests.interestId = pursuits.interestId AND
-- user_interests.userId = 'vdjf4xE59cYtmQA6CBApQN2k3Wz2'
-- JOIN users ON users.userId = pursuits.userId;
--
-- SELECT interest_name FROM interests WHERE interestId = '589B07DD-21F8-417E-A92F-618FA5B6C9FE';
--
-- SELECT photoUrl FROM users WHERE userId = 'vdjf4xE59cYtmQA6CBApQN2k3Wz2';

-- SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", posts.pursuitId, "postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description)), "{}") as pursuit_array,
--   (CASE WHEN posts.is_step = 1 THEN GROUP_CONCAT(JSON_OBJECT("pursuitId", posts.pursuitId, "postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description))
--   WHEN posts.is_step != 1 THEN "{}" END) as steps,
--   (CASE WHEN posts.is_principle = 1 THEN GROUP_CONCAT(JSON_OBJECT("pursuitId", posts.pursuitId, "postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description))
--   WHEN posts.is_principle != 1 THEN "{}" END) as principles,
--   IFNULL((SELECT JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username) FROM users WHERE posts.userId = users.userId), "{}") as user,
--   IFNULL((SELECT GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username, "fullname", users.fullname)) FROM follow_pursuits
--   JOIN users WHERE users.userId = follow_pursuits.userId && follow_pursuits.pursuitId = posts.pursuitId), "{}") as searched_users
--   FROM posts GROUP BY posts.pursuitId ORDER BY posts.created_at && posts.interestId
--   LIMIT 20;
--
-- SELECT users.photoUrl, users.username, users.userId,
--   (CASE WHEN posts.is_step = 1 THEN GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description))
--   WHEN posts.is_step != 1 THEN "{}" END) as steps,
--   (CASE WHEN posts.is_principle = 1 THEN GROUP_CONCAT(JSON_OBJECT("postId", posts.postId,"thumbnailUrl", posts.thumbnailUrl, "description", posts.description))
--   WHEN posts.is_principle != 1 THEN "{}" END) as principles
--   FROM users LEFT JOIN posts WHERE users.username
--   LIKE 't' OR users.fullname LIKE 't' OR posts.description LIKE 't';
--
--   SELECT users.* , IFNULL((SELECT GROUP_CONCAT(JSON_OBJECT("photoUrl", users.photoUrl)) FROM user_follows JOIN users
--     WHERE user_follows.followerId = 'QFzPwjcWbuOTZfX9N8nqxmggGzH2'
--     AND users.userId = user_follows.followeeId
--     ORDER BY user_follows.created_at LIMIT 3), "{}") as followees,
--     IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0)
--     FROM user_follows WHERE user_follows.followerId = 'QFzPwjcWbuOTZfX9N8nqxmggGzH2'), "{}") as followers_count,
--     IFNULL((SELECT IFNULL(COUNT(user_follows.followeeId), 0)
--     FROM user_follows WHERE user_follows.followeeId = 'QFzPwjcWbuOTZfX9N8nqxmggGzH2'), "{}") as following_count,
--     IFNULL((SELECT GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "thumbnailUrl",
--     pursuits.thumbnailUrl, "pursuitDescription", pursuits.pursuitDescription))
--     FROM pursuits WHERE userId = 'QFzPwjcWbuOTZfX9N8nqxmggGzH2'
--     ORDER BY pursuits.created_at LIMIT 15), "{}") as pursuits
--     FROM users WHERE users.userId = 'QFzPwjcWbuOTZfX9N8nqxmggGzH2';
--
-- SELECT IFNULL(JSON_OBJECT("usersId", users.userId, "photoUrl", users.photoUrl, "username", users.username), "{}") as users,
--           (SELECT (CASE WHEN posts.is_step = 1 && posts.description LIKE 't%' THEN GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description))
--           WHEN posts.is_step != 1 THEN "{}" END) FROM posts
--           ORDER BY posts.created_at LIMIT 3) as steps,
--           (SELECT (CASE WHEN posts.is_principle = 1 && posts.description LIKE 't%' THEN GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description))
--           WHEN posts.is_step != 1 THEN "{}" END) FROM posts
--           ORDER BY posts.created_at LIMIT 3) as principles
--          FROM users WHERE users.username LIKE 'T%';

-- SELECT users.* , IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0) 
--             FROM user_follows WHERE user_follows.followerId = "122"), "{}") as followers_count,  
--             IFNULL((SELECT GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId,  "pursuitDescription", pursuits.pursuitDescription)) 
--             FROM pursuits WHERE userId = "122"
--             ORDER BY pursuits.created_at LIMIT 15), "{}") as pursuits 
--             FROM users WHERE users.userId = "122";


-- SELECT * FROM users WHERE userId = "122";

-- SELECT users.* , IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0)
--                 FROM user_follows WHERE user_follows.followerId = "9"), "{}") as followers_count, 
--                 IFNULL((SELECT IFNULL(COUNT(pursuits.userId), 0)
--                 FROM pursuits WHERE pursuits.userId = "9"), "{}") as pursuits_count
--                 FROM users WHERE users.userId = "9";

-- SELECT users.* , IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0) 
--                 FROM user_follows WHERE user_follows.followerId = "8"), "{}") as followers_count, 
--                 IFNULL((SELECT GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId,  "pursuitDescription", pursuits.pursuit_description)) 
--                 FROM pursuits WHERE pursuits.userId = "8" 
--                 ORDER BY pursuits.created_at LIMIT 15), "{}") as pursuits 
--                 FROM users WHERE users.userId = "";

-- SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuitId, "pursuitDescription", pursuit_description)), "{}") as pursuits FROM pursuits 
--                 WHERE userId = "1" ORDER BY created_at LIMIT 15;

-- UPDATE users SET username = "Test", fullname = "Test", bio = "I have worked for this" WHERE userId = "1"; 

-- SELECT IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") as pursuit_array,
--   CASE WHEN posts.is_step = 1 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as steps,
--   CASE WHEN posts.is_principle = 1 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as principles,
--   CASE WHEN posts.is_step = 0 && posts.is_principle = 0 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as posts,
--   (SELECT JSON_OBJECT("usersId", users.userId, "photoUrl", users.photoUrl, "username", users.username) FROM users WHERE posts.userId = users.userId)
--   FROM posts JOIN user_interests ON user_interests.interestId = posts.interestId
--   AND user_interests.userId = 'vdjf4xE59cYtmQA6CBApQN2k3Wz2' ORDER BY posts.created_at;

INSERT posts_saved SET 
INSERT pursuit_follows SET

SELECT IFNULL(JSON_OBJECT("usersId", users.userId, "photoUrl", users.photoUrl, "username", users.username), "{}") as users,
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description)), "{}") FROM pursuits JOIN posts 
             WHERE pursuits.pursuit_description LIKE 't' && pursuits.last_postId = posts.postId  ORDER BY pursuits.created_at LIMIT 10) as pursuits
            FROM users WHERE users.username LIKE 't';

SELECT IFNULL(JSON_OBJECT("usersId", users.userId, "photoUrl", users.photoUrl, "username", users.username), "{}") as users,
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description)), "{}") FROM pursuits JOIN posts 
             WHERE pursuits.pursuit_description LIKE 't' && pursuits.last_postId = posts.postId  ORDER BY pursuits.created_at LIMIT 10) as pursuits
            FROM users WHERE users.username LIKE 't';

SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "videoUrl", posts.videoUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") as pursuits,
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "username", users.username, "photoUrl", users.photoUrl)), "{}") FROM users 
        WHERE users.userId = 1) as user FROM pursuits JOIN posts 
        ON pursuits.pursuitId = posts.postId && pursuits.pursuitId = 1
    GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId
    ORDER BY posts.created_at DESC;
    
SELECT IFNULL(JSON_OBJECT("is_tried", pursuit_tried.is_tried), "{}") as tried,
    (SELECT IFNULL(JSON_OBJECT("is_saved", posts_saved.is_saved), "{}") FROM posts_saved 
             ON posts_saved.postId = 1 && posts_saved.userId = 1) as saved
            FROM pursuit_tried ON pursuit_tried.pursuitId = 1 && pursuit_tried.userId = 1;

SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") as pursuits,
    FROM pursuits JOIN posts ON pursuits.pursuitId = posts.postId && pursuits.pursuitId = 1
    GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId
    ORDER BY posts.created_at DESC LIMIT 15;

SELECT users.userId, users.photoUrl, users.username, (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "pursuitId", pursuits.pursuitId, "thumbnailUrl", posts.thumbnailUrl, 
        "description", pursuits.pursuit_description, "created_at", posts.created_at)), "{}") 
        FROM pursuits JOIN posts WHERE pursuits.pursuit_description LIKE ? 
        && pursuits.pursuitId = posts.pursuitId GROUP BY pursuits.pursuitId ORDER BY pursuits.created_at LIMIT 10) as pursuits, 
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") FROM 
        posts WHERE posts.posts_description LIKE ? ORDER BY posts.created_at LIMIT 10) as posts 
        FROM users WHERE users.username LIKE ?;

SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description)), "{}") as key_post,
    (SELECT IFNULL(posts_saved.is_saved, "{}") FROM posts_saved JOIN posts
     WHERE posts.pursuitId = 1 && posts_saved.postId = posts.postId) as saved
    FROM posts WHERE posts.pursuitId = 1 && posts.is_keyPost = 1
    ORDER BY posts.created_at LIMIT 5;

SELECT IFNULL(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username), "{}") as team
 FROM users JOIN pursuit_follows ON pursuit_follows.pursuitId = 1;

SELECT IFNULL(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description,
     "username", users.username, "userId", users.userId, "photoUrl", users.photoUrl), "{}") as trying
 FROM posts JOIN similar_pursuit ON similar_pursuit.pursuitId = posts.pursuitId
 JOIN pursuits ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = 1
 JOIN users ON pursuits.userId = users.userId ORDER BY posts.created_at;

SELECT IFNULL(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, 
    "posts_description", posts.posts_description, "username", users.username), "{}") as responses
 FROM posts JOIN posts_responses ON posts_responses.postId = posts.postId && posts.pursuitId = 1
 JOIN users ON users.userId = posts_responses.userId;

SELECT IFNULL(posts_saved.is_saved, 0) as is_saved, IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description)), "{}") as key_post 
        FROM posts JOIN posts_saved ON posts_saved.postId = posts.postId && posts.pursuitId = 1 && posts.is_keyPost = 1 
        JOIN users ON users.userId = 1 && posts_saved.userId = users.userId
        ORDER BY posts.created_at LIMIT 5;


SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "is_saved", posts_saved.is_saved, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description)), "{}") as key_posts,
	(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") 
    FROM pursuits JOIN posts ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = ? 
        ORDER BY posts.created_at DESC LIMIT 15) as days,
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username)), "{}") FROM users JOIN pursuit_follows ON pursuit_follows.pursuitId = ?) as team,
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") FROM pursuits JOIN posts ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = ? 
        ORDER BY posts.created_at DESC LIMIT 15) as trying,
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, 
        "posts_description", posts.posts_description, "username", users.username)), "{}") FROM posts JOIN posts_responses ON posts_responses.postId = posts.postId && posts.pursuitId = ? 
        JOIN users ON users.userId = posts_responses.userId) as responses
        FROM posts JOIN posts_saved ON posts_saved.postId = posts.postId && posts.pursuitId = ? && posts.is_keyPost = 1 
        JOIN users ON users.userId = ? && posts_saved.userId = users.userId
        ORDER BY posts.created_at LIMIT 5;

SELECT users.userId, users.photoUrl, users.username, (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "pursuitId", pursuits.pursuitId, "thumbnailUrl", posts.thumbnailUrl, 
    "description", pursuits.pursuit_description, "created_at", posts.created_at)), "{}") 
    FROM pursuits JOIN posts WHERE pursuits.pursuit_description LIKE "%t" 
    && pursuits.pursuitId = posts.pursuitId ORDER BY pursuits.created_at LIMIT 10) as pursuits,
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") FROM 
    posts WHERE posts.posts_description LIKE "%t" ORDER BY posts.created_at LIMIT 10) as posts
    FROM users WHERE users.username LIKE "%t";

SELECT users.userId, users.photoUrl, users.username, (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "pursuitId", pursuits.pursuitId, "thumbnailUrl", posts.thumbnailUrl, 
    "description", pursuits.pursuit_description, "created_at", posts.created_at)), "{}") 
    FROM pursuits JOIN posts WHERE pursuits.pursuit_description LIKE ? 
    && pursuits.pursuitId = posts.pursuitId ORDER BY pursuits.created_at LIMIT 10) as pursuits,
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") FROM 
    posts WHERE posts.posts_description LIKE ? ORDER BY posts.created_at LIMIT 10) as posts
    FROM users WHERE users.username LIKE ?;

SELECT IFNULL(pursuit_tried.is_tried, "{}") FROM pursuit_tried ON pursuit_tried.pursuitId = 1 && pursuit_tried = 1;

SELECT users.* , IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0) 
    FROM user_follows WHERE user_follows.followerId = 1), "{}") as followers_count,
    (SELECT IFNULL(COUNT(pursuits.userId), 0) FROM pursuits WHERE pursuits.userId = 1) as pursuits_count,
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "pursuitId", pursuits.pursuitId, "thumbnailUrl", posts.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", posts.created_at)), "{}") 
    FROM pursuits JOIN posts WHERE pursuits.userId = 1
    && pursuits.pursuitId = posts.pursuitId ORDER BY pursuits.created_at LIMIT 10) as pursuits
    FROM users WHERE users.userId = 1

-- SELECT IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") as pursuit_array,
--   CASE WHEN posts.is_step = 1 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as steps,
--   CASE WHEN posts.is_principle = 1 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as principles,
--   CASE WHEN posts.is_step = 0 && posts.is_principle = 0 THEN IFNULL(JSON_OBJECT("postId", posts.postId, "videoUrl", posts.videoUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description), "{}") END as posts,
--   (SELECT JSON_OBJECT("usersId", users.userId, "photoUrl", users.photoUrl, "username", users.username) FROM users WHERE posts.userId = users.userId)
--   FROM posts JOIN user_interests ON user_interests.interestId = posts.interestId
--   AND user_interests.userId = 'vdjf4xE59cYtmQA6CBApQN2k3Wz2' ORDER BY posts.created_at;

SELECT IFNULL(JSON_OBJECT("tried", pursuit_tried.is_tried), 0) as tried,
        (SELECT IFNULL(JSON_OBJECT("saved", posts_saved.is_saved), 0) FROM posts_saved 
        WHERE posts_saved.postId = 1 && posts_saved.userId = 2) as saved 
        FROM pursuit_tried WHERE pursuit_tried.pursuitId = 1 && pursuit_tried.userId = 2;
SELECT CASE WHEN pursuit_tried.pursuitId = 1 && pursuit_tried.userId = 2 THEN IFNULL(JSON_OBJECT("saved", posts_saved.is_saved), 0) ELSE 
    JSON_OBJECT("saved", "{}") END,
        (SELECT CASE WHEN posts_saved.postId = 1 && posts_saved.userId = 2 THEN IFNULL(JSON_OBJECT("tried", pursuit_tried.is_tried), 0) ELSE 
        JSON_OBJECT("tried", "{}")) as tried;
        
SELECT users.userId, users.photoUrl, users.username, (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "thumbnailUrl", pursuits.thumbnailUrl, 
    "description", pursuits.pursuit_description, "created_at", pursuits.created_at)), "{}") 
    FROM pursuits WHERE pursuits.pursuit_description LIKE "%t%"
    ORDER BY pursuits.created_at) as pursuits, 
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") FROM 
    posts WHERE posts.posts_description LIKE "%t%" ORDER BY posts.created_at) as posts 
    FROM users WHERE users.username LIKE "%t%" LIMIT 1;

SELECT users.* , IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0) 
    FROM user_follows WHERE user_follows.followerId = ?), "{}") as followers_count, 
    (SELECT IFNULL(COUNT(pursuits.userId), 0) FROM pursuits WHERE pursuits.userId = ?) as pursuits_count, 
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at)), "{}") 
    FROM pursuits WHERE pursuits.userId = ? 
    ORDER BY pursuits.created_at LIMIT 10) as pursuits 
    FROM users WHERE users.userId = ?

SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "is_saved", posts_saved.is_saved, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description)), "{}") as key_posts, 
	    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") 
        FROM pursuits JOIN posts ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = ? 
        ORDER BY posts.created_at DESC LIMIT 15) as days, 
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username)), "{}") FROM users JOIN pursuit_follows ON pursuit_follows.pursuitId = ?) as team, 
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "userId", users.userId, "userPhotourl", users.photoUrl, "username", users.username, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at)), "{}") FROM pursuits 
		JOIN similar_pursuit ON pursuits.pursuitId = similar_pursuit.new_pursuitId
        JOIN users ON pursuits.userId = users.userId
        ORDER BY pursuits.created_at DESC LIMIT 15) as trying, 
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, 
        "posts_description", posts.posts_description, "username", users.username)), "{}") FROM posts JOIN posts_responses ON posts_responses.postId = posts.postId && posts.pursuitId = ? 
        JOIN users ON users.userId = posts_responses.userId) as responses 
        FROM posts JOIN posts_saved ON posts_saved.postId = posts.postId && posts.pursuitId = ? && posts.is_keyPost = 1 
        JOIN users ON users.userId = ? && posts_saved.userId = users.userId 
        ORDER BY posts.created_at LIMIT 5;

SELECT users.* , IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0) 
        FROM user_follows WHERE user_follows.followerId = ?), "{}") as followers_count, 
        (SELECT IFNULL(COUNT(pursuits.userId), 0) FROM pursuits WHERE pursuits.userId = ?) as pursuits_count, 
        (SELECT user_follows.is_following FROM user_follows WHERE user_follows.followerId = ?) as is_following,
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at)), "{}") 
        FROM pursuits WHERE pursuits.userId = ? 
        ORDER BY pursuits.created_at LIMIT 10) as pursuits 
        FROM users WHERE users.userId = ?;

 SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId) ORDER BY posts.postId ASC), "{}") as days
        FROM pursuits JOIN posts ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = ? 
        ORDER BY posts.created_at DESC LIMIT 15; 

SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "is_saved", posts_saved.is_saved, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description) ORDER BY posts.created_at DESC), "{}") as key_posts, 
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at) ORDER BY posts.created_at DESC), "{}") FROM pursuits JOIN posts
        ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = 1 ORDER BY posts.created_at DESC LIMIT 15) as days,
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username) ORDER BY users.created_at DESC), "{}") FROM users JOIN pursuit_follows ON pursuit_follows.pursuitId = ?) as team, 
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "userId", users.userId, "userPhotourl", users.photoUrl, "username", users.username, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at) ORDER BY pursuits.created_at DESC), "{}") FROM pursuits 
        JOIN similar_pursuit ON pursuits.pursuitId = similar_pursuit.new_pursuitId 
        JOIN users ON pursuits.userId = users.userId 
        ORDER BY pursuits.created_at DESC LIMIT 15) as trying, 
        (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, 
        "posts_description", posts.posts_description, "username", users.username) ORDER BY posts.created_at DESC), "{}") FROM posts JOIN posts_responses ON posts_responses.postId = posts.postId && posts.pursuitId = ? 
        JOIN users ON users.userId = posts_responses.userId) as responses 
        FROM posts JOIN posts_saved ON posts_saved.postId = posts.postId && posts.pursuitId = ? && posts.is_keyPost = 1 
        JOIN users ON users.userId = ? && posts_saved.userId = users.userId 
        ORDER BY posts.created_at DESC LIMIT 5

UPDATE posts_saved SET postId = 1, userId = 1, is_saved = 1 WHERE postId = 1 && userId = 1
    IF ROW_COUNT() = 0 
        INSERT INTO posts_saved (postId, userId, is_saved) VALUES (1, 1, 1)

SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at) ORDER BY posts.created_at DESC), "{}") FROM pursuits JOIN posts 
ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = ? ORDER BY posts.created_at DESC LIMIT 15 HAVING posts.created_at 

SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("interestId", interests.interestId, "interest_name", interests.interest_name)), "{}"),
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username) ORDER BY users.created_at DESC), "{}") FROM users 
    JOIN user_follows ON user_follows.followerId = ?) as team, 
    (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "pursuit_description", pursuits.pursuit_description,
        "thumbnailUrl", pursuits.thumbnailUrl)), "{}") FROM pursuits 
            WHERE userId = ? ORDER BY created_at LIMIT 15) as pursuits
FROM interests ORDER BY interest_name

SELECT users.* , IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0) 
            FROM user_follows WHERE user_follows.followerId = 1), "{}") as followers_count, 
            (SELECT IFNULL(COUNT(pursuits.userId), 0) FROM pursuits WHERE pursuits.userId = 1) as pursuits_count, 
            (SELECT user_follows.is_following FROM user_follows WHERE user_follows.followerId = 1) as is_following, 
            (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "username", users.username,
            "userPhotourl", users.photoUrl, "pursuitId", pursuits.pursuitId, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at) ORDER BY pursuits.created_at DESC), "{}") 
            FROM pursuits JOIN  ON users.userId = pursuits.userId && pursuits.userId = 1
            ORDER BY pursuits.created_at LIMIT 25) as pursuits 
            FROM users WHERE users.userId = 1;

SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "is_saved", posts_saved.is_saved, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description) ORDER BY posts.created_at DESC), "{}") as key_posts, 
            (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "interestId", pursuits.interestId, "created_at", posts.created_at) ORDER BY posts.created_at DESC), "{}") FROM pursuits JOIN posts 
            ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = ? ORDER BY posts.created_at DESC) as days, 
            (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "videoUrl", posts.videoUrl,"created_at", posts.created_at, "posts_description", posts.posts_description, "userId", users.userId, "username", users.username, "pursuitId", pursuits.pursuitId,
	        "userPhotourl", users.photoUrl) ORDER BY posts.created_at DESC) , "{}") FROM pursuits JOIN posts ON pursuits.pursuitId = posts.pursuitId && posts.pursuitId = ? && posts.postId <= ? JOIN users ON users.userId = pursuits.userId LIMIT 1) as posts, 
            (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username) ORDER BY users.created_at DESC), "{}") FROM users JOIN pursuit_follows ON pursuit_follows.pursuitId = ?) as team, 
            (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "userId", users.userId, "userPhotourl", users.photoUrl, "username", users.username, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at) ORDER BY pursuits.created_at DESC), "{}") FROM pursuits 
            JOIN similar_pursuit ON pursuits.pursuitId = similar_pursuit.new_pursuitId 
            JOIN users ON pursuits.userId = users.userId 
            ORDER BY pursuits.created_at DESC LIMIT 15) as trying, 
            (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl,
            "posts_description", posts.posts_description, "username", users.username) ORDER BY posts.created_at DESC), "{}") FROM posts JOIN posts_responses ON posts_responses.postId = posts.postId && posts.pursuitId = ? 
            JOIN users ON users.userId = posts_responses.userId) as responses 
            FROM posts JOIN posts_saved ON posts_saved.postId = posts.postId && posts.pursuitId = ? && posts.is_keyPost = 1 
            JOIN users ON users.userId = ? && posts_saved.userId = users.userId 
            ORDER BY posts.created_at DESC LIMIT 5