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

router.get("/interest-pursuits", function(req, res){

    var selectedUser = req.query.userId;
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", posts.pursuitId, "postId", posts.postId, "contentUrl", posts.contentUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description)), "{}") as pursuit_array, ' +
      '(CASE WHEN posts.is_step = 1 THEN GROUP_CONCAT(JSON_OBJECT("pursuitId", posts.pursuitId, "postId", posts.postId, "contentUrl", posts.contentUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description)) ' +
      'WHEN posts.is_step != 1 THEN "{}" END) as steps, ' +
      '(CASE WHEN posts.is_principle = 1 THEN GROUP_CONCAT(JSON_OBJECT("pursuitId", posts.pursuitId, "postId", posts.postId, "contentUrl", posts.contentUrl, "thumbnailUrl", posts.thumbnailUrl, "description", posts.description)) ' +
      'WHEN posts.is_principle != 1 THEN "{}" END) as principles, ' +
      'IFNULL((SELECT JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username) FROM users WHERE posts.userId = users.userId), "{}") as user, ' +
      'IFNULL((SELECT GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username, "fullname", users.fullname)) FROM follow_pursuits ' +
      'JOIN users WHERE users.userId = follow_pursuits.userId && follow_pursuits.pursuitId = posts.pursuitId), "{}") as searched_users ' +
      'FROM posts GROUP BY posts.pursuitId ORDER BY posts.created_at && posts.interestId';

    db_config.query(q, selectedUser, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         if (result) {
           for (i = 0; i < result.length; i++) {
            var stringJSON = JSON.stringify(result[1]);
            var parsedJSON = JSON.parse(stringJSON);
             var pursuitParsed = JSON.parse("[" + parsedJSON[i].pursuit_array + "]");
             var principlesParsed = JSON.parse("[" + parsedJSON[i].principles + "]");
             var stepsParsed = JSON.parse("[" + parsedJSON[i].steps + "]");
             var searchedUsersParsed = JSON.parse("[" + parsedJSON[i].searched_users + "]");
             var userParsed = JSON.parse(parsedJSON[i].user);
             result[i].principles = principlesParsed;
             result[i].steps = stepsParsed;
             result[i].pursuit_array = pursuitParsed;
             result[i].user = userParsed;
             result[i].searched_users = searchedUsersParsed;
            }
            res.json(result);
         } else {
           res.json(result);
         }
     });
});

router.get("/user-create-pursuits", function(req, res){

    var selectedUser = req.query.userId;
    var q = 'SELECT * FROM pursuits WHERE userId = ' + mysql.escape(selectedUser) +
            ' ORDER BY created_at';

    connection.query(q, selectedUser, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.json(result);
     });
});

router.get("/get_pursuitIds", function(req, res){
    var userId = req.query.userId;

    var q = 'SELECT pursuits.pursuitId FROM pursuits ' +
        'WHERE userId = ? ORDER BY created_at DESC LIMIT 1';
    db_config.query(q, userId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.json(result[0]);
     });
});

router.get("/get_days_of_pursuits", function(req, res){

    var pursuitId = req.query.pursuitId;

    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") as days ' +
        'FROM pursuits JOIN posts ON pursuits.pursuitId = posts.postId && pursuits.pursuitId = ? ' +
        'GROUP BY DATE(DATE_SUB(posts.created_at, INTERVAL 19 HOUR)), posts.pursuitId ' +
        'ORDER BY posts.created_at DESC LIMIT 15';

    db_config.query(q, pursuitId, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.json(result);
     });
});

router.post("/create_pursuit", function(req, res){
    var pursuit = {
        interestId : req.body.interestId,
        is_visible : req.body.is_visible,
        is_public : req.body.is_public,
        thumbnailUrl : req.body.thumbnailUrl,
        pursuit_description : req.body.pursuit_description,
        userId : req.body.userId,
        is_tried : req.body.is_tried
    };
    
    var q = 'INSERT INTO pursuits SET ? '

    db_config.query(q, pursuit, function(err, result) {
        
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/try_pursuit", function(req, res){
    var pursuit = {
        interestId : req.body.interestId,
        is_visible : req.body.is_visible,
        is_public : req.body.is_public,
        thumbnailUrl : req.body.thumbnailUrl,
        pursuit_description : req.body.pursuit_description,
        userId : req.body.userId,
        is_tried : req.body.is_tried,
        old_pursuitId : req.body.old_pursuitId
    };
    
    var q = 'INSERT INTO pursuits SET ? '

    db_config.query(q, pursuit, function(err, result) {        
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/similar_pursuit", function(req, res){
    var pursuit = {
        new_pursuitId : req.body.new_pursuitId,
        pursuitId : req.body.pursuitId
    };
    
    var q = 'INSERT INTO similar_pursuit SET ? '

    db_config.query(q, pursuit, function(err, result) {
        
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/add_team_to_pursuit", function(req, res){
    var pursuit = {
        userId: req.body.userId,
        pursuitId : req.body.pursuitId,
        is_following  : req.body.is_following
    };

    var is_following = req.body.is_following;

    db_config.query('INSERT INTO pursuit_follows SET ? ON DUPLICATE KEY UPDATE is_following = ?', [pursuit, is_following], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/follow_pursuit", function(req, res){
    var followPursuit = {
        pursuitId : req.body.pursuitId,
        userId : req.body.userId,
        is_following : req.body.is_following
    };

    var is_following = req.body.is_following;

    db_config.query('INSERT INTO follow_pursuits SET ? ON DUPLICATE KEY UPDATE is_following = ? ', [followPursuit, is_following], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/delete_pursuit", function(req, res){
    var pursuitId = req.body.pursuitId;

    db_config.query('DELETE FROM pursuits WHERE pursuitId ? ', pursuitId, function(err, result) {
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