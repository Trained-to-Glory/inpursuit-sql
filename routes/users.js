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

router.post("/update_signup", function(req, res){
    
    db_config.query('UPDATE users SET username = ?, fullname = ?, photoUrl = ?, bio = ? WHERE userId = ?', 
        [req.body.username, req.body.fullname, req.body.photoUrl, req.body.bio, req.body.userId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success");
    });
});

router.post("/signup", function(req, res){   
  var person = {
        email: req.body.email,
        username : req.body.username,
        fullname : req.body.fullname,
        photoUrl : req.body.photoUrl,
        userId : req.body.userId
    };   
    
    db_config.query('INSERT INTO users SET ? ', person, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success");
    });
});

router.post("/posts", function(req, res){
    var post = {
        postId: req.body.postId,
        userId: req.body.userId,
        photoUrl : req.body.photoUrl,
        postDescription : req.body.postDescription,
        is_visible : req.body.is_visible
    };

    var is_visible = req.body.is_visible;
    db_config.query('INSERT INTO posts SET ? ON DUPLICATE KEY UPDATE is_visible = ?', [post, is_visible], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/added-user", function(req, res){
    var add = {
        pursuitId: req.body.pursuitId,
        userId: req.body.userId,
        is_following : req.body.is_following
    };

    var is_following= req.body.is_following;
    db_config.query('INSERT INTO pursuit_follows SET ? ON DUPLICATE KEY UPDATE is_following = ?', [add, is_following], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("User succesfully added");
    });
});

router.post("/block_user", function(req, res){
    var add = {
        blockerId: req.body.blockerId,
        blockeeId: req.body.blockeeId,
        is_blocked : req.body.is_blocked
    };

    db_config.query('INSERT INTO block_user SET ?', add, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("User succesfully added");
    });
});

router.get("/get_block_status", function(req, res){
    var blockerId = req.query.blockerId;
    var blockeeId = req.body.blockeeId;

    var q = 'SELECT is_blocked FROM block_user WHERE blockerId = ? && blockeeId = ?';

    db_config.query(q, [blockerId, blockeeId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        }         
        res.json(result);
    });
});

router.post("/delete_post", function(req, res){
    var blockerId = req.body.blockerId;
    var blockeeId = req.body.blockeeId;

    db_config.query('DELETE FROM block_user WHERE blockerId = ? &&  blockeeId = ?', [blockerId, blockeeId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/follow_user", function(req, res){

    var followUser = {
        followerId : req.body.followerId,
        followeeId : req.body.followeeId,
        is_following : req.body.is_following
    };
    var is_following = req.body.is_following;

    db_config.query('INSERT INTO user_follows SET ? ON DUPLICATE KEY UPDATE is_following = ? ', [followUser, is_following], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("User followed")
    });
});

router.post("/delete_account", function(req, res){
    var userId = req.body.userId;

    db_config.query('DELETE FROM users WHERE userId ? ', userId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Account Deleted")
    });
});

router.get("/user-details", function(req, res){
    var userId = req.query.userId;
    var q = 'SELECT users.* FROM users WHERE users.userId = ?';

    db_config.query(q, userId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.json(result[0]);
    });
});

router.get("/get-userid", function(req, res){ 
    var email = req.query.email;
    
    var q = 'SELECT userId FROM users WHERE email = ?';
    
    db_config.query(q, email, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        }        
        res.json(result[0]);
    });
});

router.get("/get_user_profile", function(req, res){
    var userId = req.query.userId;   
     
    var q = 'SET group_concat_max_len = 1000000; SELECT users.* , IFNULL((SELECT IFNULL(COUNT(user_follows.followerId), 0) ' +
            'FROM user_follows WHERE user_follows.followerId = ?), "{}") as followers_count, ' +
            '(SELECT IFNULL(COUNT(pursuits.userId), 0) FROM pursuits WHERE pursuits.userId = ?) as pursuits_count, ' +
            '(SELECT user_follows.is_following FROM user_follows WHERE user_follows.followerId = ?) as is_following, ' +
            '(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "username", users.username, ' +
            '"userPhotourl", users.photoUrl, "pursuitId", pursuits.pursuitId, "thumbnailUrl", pursuits.thumbnailUrl, "description", pursuits.pursuit_description, "created_at", pursuits.created_at) ORDER BY pursuits.created_at DESC), "{}") ' +
            'FROM pursuits JOIN users ON users.userId = pursuits.userId && pursuits.userId = ? ' +
            'ORDER BY pursuits.created_at LIMIT 25) as pursuits ' +
            'FROM users WHERE users.userId = ?';
                
    db_config.query(q, [userId, userId, userId, userId, userId], function(err, result) {        
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
                    "userId": parsedJSON[i].userId,
                    "username": parsedJSON[i].username,
                    "photoUrl" : parsedJSON[i].photoUrl,
                    "email" : parsedJSON[i].email,
                    "fullname" : parsedJSON[i].fullname,
                    "bio" : parsedJSON[i].bio,
                    "is_following" : parsedJSON[i].is_following,
                    "followers_count" : JSON.parse(parsedJSON[i].followers_count),
                    "pursuits_count" : JSON.parse(parsedJSON[i].pursuits_count),
                    "pursuits": JSON.parse("[" + parsedJSON[i].pursuits + "]")
                });
            }
         }
         res.json(dictionary[0]);
    });
});

router.get("/get_user_added", function(req, res){
    var userId = req.query.userId;   
     
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "username", users.username, "fullname", users.fullname, ' +
            '"photoUrl", users.photoUrl, "is_following", user_follows.is_following) ORDER BY users.created_at DESC), "{}") as added FROM user_follows JOIN users ' +
            'WHERE user_follows.followerId = ? && user_follows.followeeId = users.userId';
                
    db_config.query(q, userId, function(err, result) {        
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
                    "added" : JSON.parse("[" + parsedJSON[i].added + "]")
                });
            }
         }
         res.json(dictionary[0]);
    });
});


router.get("/get-user-pursuits", function(req, res){
    var userId = req.query.userId;   
     
    var q =  'SELECT pursuitId, pursuit_description, thumbnailUrl FROM pursuits ' +
            'WHERE userId = ? ORDER BY created_at LIMIT 15';
                
    db_config.query(q, userId, function(err, result) {        
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        var stringJSON = JSON.stringify(result);
        var parsedJSON = JSON.parse(stringJSON);
        res.json(result);
    });
});

function getConnection(){
    return db_config
}

module.exports = router