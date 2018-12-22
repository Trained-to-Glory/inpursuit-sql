const express = require('express')
const router = express.Router()
const mysql = require('mysql')

const db_config = mysql.createConnection ({
    multipleStatements: true,
    host : 'uoa25ublaow4obx5.cbetxkdyhwsb.us-east-1.rds.amazonaws.com',
    user : 'sugegrobpyr4cpea',
    database : 'qnedwtxcaccmbl1h',
    password : 'mglzpy4jwe2emfjr'
 });

 var connection;

 function handleDisconnect(){
    connection = mysql.createConnection(db_config);
    
    connection.connect(function(err) {
       if (err) {
         setTimeout(handleDisconnect, 2000);
       }
    });
  
    connection.on('error', function(err) {
      if(err.code === 'PROTOCOL_CONNECTION_LOST') { // Connection to the MySQL server is usually
        handleDisconnect();                         // lost due to either server restart, or a
      } else {                                      // connnection idle timeout (the wait_timeout
        throw err;                                  // server variable configures this)
      }
    })
  }
  
  handleDisconnect();

 router.get("/get_home_feed", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(COUNT(posts.postId), 0) as posts_count, IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "postId", posts.postId, "thumbnailUrl", ' +
        'posts.thumbnailUrl, "interestId", pursuits.interestId, "username", users.username, "userId", users.userId, "userPhotourl", users.photoUrl, "videoUrl", posts.videoUrl,"created_at", posts.created_at, "posts_description", posts.posts_description) ORDER BY posts.created_at DESC), "{}") as posts FROM pursuits JOIN posts ' +
        'ON pursuits.pursuitId = posts.pursuitId && pursuits.is_public = 1 JOIN users ON users.userId = pursuits.userId ' +
        'GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId ' +
        'ORDER BY posts.created_at DESC LIMIT 25';

     db_config.query(q, function(err, result) {
        if (err) {            
            res.sendStatus(500)
            return
        } 

        var dictionary = []
        
        if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({                
                    "posts_count" : result[1][i].posts_count,
                    "posts": JSON.parse("[" + parsedJSON[i].posts + "]")
                });
            }
        }
                
        res.json(dictionary);
     
     });
});

router.get("/get_refresh_feed", function(req, res){
    var postId = req.query.postId;
    
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(COUNT(posts.postId), 0) as posts_count, IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", ' +
            'posts.thumbnailUrl, "interestId", pursuits.interestId, "username", users.username, "userId", users.userId, "userPhotourl", users.photoUrl, "videoUrl", posts.videoUrl,"created_at", posts.created_at, "posts_description", posts.posts_description) ORDER BY posts.created_at DESC), "{}") as posts FROM pursuits JOIN posts ' +
            'ON pursuits.pursuitId = posts.pursuitId && pursuits.is_public = 1 && posts.postId > ? JOIN users ON users.userId = pursuits.userId ' +
            'GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId ' +
            'ORDER BY posts.created_at DESC LIMIT 15';

     db_config.query(q, postId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 

        var dictionary = []
        if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
            
                dictionary.push({                
                    "posts_count" : result[1][i].posts_count,
                    "posts": JSON.parse("[" + parsedJSON[i].posts + "]")
                });
            }
        }
        
        res.json(dictionary);
     
     });
});

router.get("/get_post_count", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(COUNT(posts.postId), 0) as posts_count, IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "postId", posts.postId, "thumbnailUrl", ' +
        'posts.thumbnailUrl, "posts_count", posts.postId, "interestId", pursuits.interestId, "username", users.username, "userId", users.userId, "userPhotourl", users.photoUrl, "videoUrl", posts.videoUrl,"created_at", posts.created_at, "posts_description", posts.posts_description) ORDER BY posts.created_at DESC), "{}") as posts FROM pursuits JOIN posts ' +
        'ON pursuits.pursuitId = posts.pursuitId && pursuits.is_public = 1 JOIN users ON users.userId = pursuits.userId ' +
        'GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId ' +
        'ORDER BY posts.created_at DESC LIMIT 15';

     db_config.query(q, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        var dictionary = []
        if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
            
                dictionary.push({                
                    "posts_count" : result[1][i].posts_count
                });
    
            }
        }
        res.json(dictionary);
     
     });
});

router.get("/get_more_post", function(req, res){
    var postId = req.query.postId;
    
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(COUNT(posts.postId), 0) as posts_count, IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", ' +
            'posts.thumbnailUrl, "interestId", pursuits.interestId, "username", users.username, "userId", users.userId, "userPhotourl", users.photoUrl, "videoUrl", posts.videoUrl,"created_at", posts.created_at, "posts_description", posts.posts_description) ORDER BY posts.created_at DESC), "{}") as posts FROM pursuits JOIN posts ' +
            'ON pursuits.pursuitId = posts.pursuitId && pursuits.is_public = 1 && posts.postId < ? JOIN users ON users.userId = pursuits.userId ' +
            'GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId ' +
            'ORDER BY posts.created_at DESC LIMIT 25';

     db_config.query(q, postId, function(err, result) {
        if (err) {
            res.sendStatus(500)
            return
        } 

        var dictionary = []
        if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "posts_count" : result[1][i].posts_count,
                    "posts": JSON.parse("[" + parsedJSON[i].posts + "]")
                });
            }
        }

        res.json(dictionary);
     
     });
});

router.get("/get_post_details", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at) ORDER BY posts.created_at DESC), "{}") as key_posts, ' +
    '(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "userId", posts.userId, "description", posts.posts_description, "interestId", pursuits.interestId, "created_at", posts.created_at) ORDER BY posts.created_at DESC), "{}") FROM pursuits JOIN posts ' +
    'ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = ? ORDER BY posts.created_at DESC) as days, ' +
    '(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username) ORDER BY users.created_at DESC), "{}") FROM users JOIN pursuit_follows ON users.userId = pursuit_follows.userId && pursuit_follows.pursuitId = ?) as team, ' +
    '(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "userId", users.userId, "userPhotourl", users.photoUrl, "username", users.username, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at) ORDER BY pursuits.created_at DESC), "{}") FROM pursuits ' +
    'JOIN similar_pursuit ON pursuits.pursuitId = similar_pursuit.new_pursuitId && similar_pursuit.pursuitId = ?' +
    'JOIN users ON pursuits.userId = users.userId ' +
    'ORDER BY pursuits.created_at DESC LIMIT 15) as trying, ' +
    '(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, ' +
    '"posts_description", posts.posts_description, "username", users.username) ORDER BY posts.created_at DESC), "{}") FROM posts JOIN posts_responses ON posts_responses.pursuitId = posts.pursuitId && posts.pursuitId = ? ' +
    'JOIN users ON users.userId = posts_responses.userId) as responses ' +
    'FROM posts JOIN users ON users.userId = ? && posts.pursuitId = ? && posts.is_keyPost = 1 ' +
    'ORDER BY posts.created_at DESC LIMIT 5';

    var pursuitId = req.query.pursuitId;
    var userId = req.query.userId;

     db_config.query(q, [pursuitId, pursuitId, pursuitId, pursuitId, userId, pursuitId], function(err, result) {
             
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 

         var dictionary = []
         if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "days": JSON.parse("[" + parsedJSON[i].days + "]"),
                    "key_posts": JSON.parse("[" + parsedJSON[i].key_posts + "]"),
                    "team": JSON.parse("[" + parsedJSON[i].team + "]"),
                    "trying": JSON.parse("[" + parsedJSON[i].trying + "]"),
                    "responses": JSON.parse("[" + parsedJSON[i].responses + "]")
                });
            } 
         }        
         res.json(dictionary[0]);
     });
});

router.get("/get_days", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT pursuits.pursuitId, IFNULL(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at), "{}") as days FROM pursuits JOIN posts ' +
            'ON pursuits.pursuitId = posts.pursuitId && pursuits.pursuitId = ? ' +
            'GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId ' +
            'ORDER BY posts.created_at DESC LIMIT 15';

    var pursuitId = req.query.pursuitId;

     db_config.query(q, pursuitId, function(err, result) {
        if (err) {
            res.sendStatus(500)
            return
        } 
         var dictionary = []
         if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);
            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "pursuitId": result[1][i].pursuitId,
                    "days": JSON.parse("[" + parsedJSON[i].days + "]")
                });
            }
         }
         
         res.json(dictionary[0]);
     });
});

router.get("/get_responses", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, ' +
            '"posts_description", posts.posts_description, "username", users.username) ORDER BY posts.created_at DESC), "{}") as responses FROM posts JOIN posts_responses ON posts_responses.postId = posts.postId && posts.pursuitId = ? ' +
            'JOIN users ON users.userId = posts_responses.userId ';

    var pursuitId = req.query.pursuitId;

     db_config.query(q, pursuitId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         var dictionary = []

         if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "responses": JSON.parse("[" + parsedJSON[i].responses + "]")
                });
            }
         }
         
         res.json(dictionary[0]);
     });
});

router.get("/get_key_posts", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at) ORDER BY posts.created_at DESC), "{}") as key_posts ' +
            'FROM posts WHERE posts.pursuitId = ? && posts.is_keyPost = 1 ' +
            'ORDER BY posts.created_at DESC LIMIT 15';

    var pursuitId = req.query.pursuitId;

     db_config.query(q, pursuitId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         var dictionary = []

         if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "key_posts": JSON.parse("[" + parsedJSON[i].key_posts + "]")
                });
            }
         }
         
         res.json(dictionary[0]);
     });
});

router.get("/get_postsIds", function(req, res){
    var userId = req.query.userId;

    var q = 'SET FOREIGN_KEY_CHECKS = 0; SELECT postId FROM posts ' +
        'WHERE userId = ? ORDER BY created_at DESC LIMIT 1';
    db_config.query(q, userId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        
         res.json(result[1][0]);
     });
});

router.get("/get_trying", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "userId", users.userId, "userPhotourl", users.photoUrl, "username", users.username, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at) ORDER BY pursuits.created_at DESC), "{}") as trying FROM pursuits ' +
            'JOIN similar_pursuit ON pursuits.pursuitId = similar_pursuit.new_pursuitId && similar_pursuit.pursuitId = ? ' +
            'JOIN users ON pursuits.userId = users.userId ' +
            'ORDER BY pursuits.created_at DESC LIMIT 15';

    var pursuitId = req.query.pursuitId;

     db_config.query(q, pursuitId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         var dictionary = []

         if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "trying": JSON.parse("[" + parsedJSON[i].trying + "]")
                });
            }
         }
         
         res.json(dictionary[0]);
     });
});

router.get("/array_of_posts", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "videoUrl", posts.videoUrl,"created_at", posts.created_at, "posts_description", posts.posts_description, "userId", users.userId, "username", users.username, "pursuitId", pursuits.pursuitId, ' +
	        '"userPhotourl", users.photoUrl) ORDER BY posts.created_at DESC), "{}") as posts FROM pursuits JOIN posts ' +
            'ON pursuits.pursuitId = posts.pursuitId && posts.pursuitId = ? && posts.postId <= ? JOIN users ON users.userId = pursuits.userId ' +
            'GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId ' +
            'ORDER BY posts.created_at DESC LIMIT 1';

    var pursuitId = req.query.pursuitId;
    var postId = req.query.postId;

     db_config.query(q, [pursuitId, postId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         var dictionary = []
         
         if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);
            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "posts": JSON.parse("[" + parsedJSON[i].posts + "]")
                });
            }
         }
         
         res.json(dictionary[0]);
     });
});

router.get("/profile_posts", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "videoUrl", posts.videoUrl,"created_at", posts.created_at, "posts_description", posts.posts_description, "userId", users.userId, "username", users.username, "pursuitId", pursuits.pursuitId, ' +
	        '"userPhotourl", users.photoUrl) ORDER BY posts.created_at DESC), "{}") as posts FROM pursuits JOIN posts ' +
            'ON pursuits.pursuitId = posts.pursuitId && posts.pursuitId = ? JOIN users ON users.userId = pursuits.userId ' +
            'GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId ' +
            'ORDER BY posts.created_at DESC LIMIT 1';

    var pursuitId = req.query.pursuitId;

     db_config.query(q, pursuitId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         var dictionary = []

         if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "posts": JSON.parse("[" + parsedJSON[i].posts + "]")
                });
            }    
         }
              
         res.json(dictionary[0]);
     });
});

router.get("/get_pursuit_team", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username), "{}") as team ' +
        'FROM users JOIN pursuit_follows ON pursuit_follows.pursuitId = ?';

    var pursuitId = req.query.pursuitId;

     db_config.query(q, pursuitId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.json(result);
     });
});

router.get("/get_postId", function(req, res){
    var q = 'SELECT postId FROM posts WHERE pursuitId = ? ORDER BY created_at DESC;';

    var pursuitId = req.query.pursuitId;

     db_config.query(q, pursuitId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.json(result);
     });
});

router.get("/get_create_details", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("interestId", interests.interestId, "interest_name", interests.interest_name)), "{}") as interests, ' +
        '(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username) ORDER BY users.created_at DESC), "{}") as users FROM users ' +
        'JOIN user_follows ON user_follows.followerId = ? && user_follows.followeeId = users.userId LIMIT 15) as team, ' +
        '(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "pursuit_description", pursuits.pursuit_description, ' +
        '"thumbnailUrl", pursuits.thumbnailUrl) ORDER BY pursuits.created_at DESC), "{}") FROM pursuits ' +
        'WHERE userId = ? ORDER BY created_at LIMIT 15) as pursuits ' +
        'FROM interests ORDER BY interest_name';

    var userId = req.query.userId;

     db_config.query(q, [userId, userId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 

         var dictionary = []
         if (result[1].length != 0) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);

            for (var i = 0; i < result[1].length; i++) {
                dictionary.push({
                    "interests": JSON.parse("[" + parsedJSON[i].interests + "]"),
                    "team": JSON.parse("[" + parsedJSON[i].team + "]"),
                    "pursuits": JSON.parse("[" + parsedJSON[i].pursuits + "]")
                });
            }
         }

         res.json(dictionary[0]);
     });
});

router.post("/create_post", function(req, res){
     var post = {
         pursuitId: req.body.pursuitId,
         videoUrl : req.body.videoUrl,
         thumbnailUrl : req.body.thumbnailUrl,
         is_visible : req.body.is_visible,
         is_keyPost : req.body.is_keyPost,
         posts_description : req.body.posts_description,
         is_response : req.body.is_response,
         is_saved : req.body.is_saved,
         userId : req.body.userId
     };

     db_config.query('INSERT INTO posts SET ? ', post, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.send("Success")
     });
});

router.post("/upload_video", function(req, res){
    db_config.query('UPDATE posts SET videoUrl = ? WHERE postId = ? ', [req.body.videoUrl, req.body.postId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/create_responses", function(req, res){
    var response = {
        pursuitId: req.body.pursuitId,
        videoUrl : req.body.videoUrl,
        thumbnailUrl : req.body.thumbnailUrl,
        is_visible : req.body.is_visible,
        is_keyPost : req.body.is_keyPost,
        posts_description : req.body.posts_description,
        is_response : req.body.is_response,
        is_saved : req.body.is_saved,
        userId : req.body.userId
    };
    
    db_config.query('INSERT INTO posts SET ? ', response, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/create_responses_ids", function(req, res){
    var response = {
        pursuitId: req.body.pursuitId,
        userId : req.body.userId,
        postId : req.body.postId
    };
    
    db_config.query('INSERT INTO posts_responses SET ? ', response, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/delete_post", function(req, res){
    var postId = req.body.postId;

    db_config.query('DELETE FROM posts WHERE postId ? ', postId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

function getConnection(){
    return db_config
}

module.exports = router