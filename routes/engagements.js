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

router.post("/post-saved", function(req, res){
    var savePost = {
      userId : req.body.userId,
      postId : req.body.postId,
      is_saved : req.body.is_saved
    };  

    
    var is_saved = req.body.is_saved;
    var q = 'INSERT INTO posts_saved SET ? ON DUPLICATE KEY UPDATE is_saved = 0 ';

    db_config.query(q, [savePost, is_saved], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/pursuit_tried", function(req, res){
    var tryPost = {
      is_tried : req.body.is_tried,
      userId : req.body.userId,
      pursuitId : req.body.pursuitId
    };

    var is_tried = req.body.is_tried;
    var q = 'INSERT INTO pursuit_tried SET ? ON DUPLICATE KEY UPDATE is_tried = ? ';

    db_config.query(q, [tryPost, is_tried], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.post("/add_team", function(req, res){
    var team = {
      is_following : req.query.is_following,
      userId : req.query.userId,
      pursuitId : req.query.pursuitId
    };

    var is_following = req.query.is_following;
    var q = 'INSERT INTO pursuit_follows SET ? ON DUPLICATE KEY UPDATE is_following = ? ';

    db_config.query(q, [team, is_following], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success")
    });
});

router.get("/get_save_status", function(req, res){
    var q = 'SELECT IFNULL(posts_saved.is_saved, "{}") as saved FROM posts_saved ' +
        'WHERE posts_saved.postId = ? && posts_saved.userId = ?';

    var savePostId = req.query.postId;
    var userId = req.query.userId;

    db_config.query(q, [savePostId, userId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         var dictionary = []
         var stringJSON = JSON.stringify(result);
         var parsedJSON = JSON.parse(stringJSON);

         if (result.length === 0) {
            dictionary.push({
                "saved": 0
            });
         } else {
            for (var i = 0; i < result.length; i++) {
             
                dictionary.push({
                    "saved": JSON.parse(parsedJSON[i].saved)
                });
            }
         }

         res.json(result)
     });
});

router.get("/get_try_status", function(req, res){
    var q = 'SELECT IFNULL(pursuit_tried.is_tried, "{}") as tried ' +
        'FROM pursuit_tried WHERE pursuit_tried.pursuitId = ? && pursuit_tried.userId = ?';

    var pursuitId = req.query.pursuitId;
    var userId = req.query.userId;

    db_config.query(q, [pursuitId, userId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         var dictionary = []
         var stringJSON = JSON.stringify(result);
         var parsedJSON = JSON.parse(stringJSON);

         if (result.length === 0) {
            dictionary.push({
                "tried": 0
            });
         } else {
            for (var i = 1; i < result.length; i++) {
             
                dictionary.push({
                    "tried": JSON.parse(parsedJSON[i].tried)
                });
            }
         }

         res.json(result)
     });
});

router.get("/get_team", function(req, res){
    var q = 'SET group_concat_max_len = 1000000; SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("userId", users.userId, "photoUrl", users.photoUrl, "username", users.username) ORDER BY users.created_at DESC), "{}") as team FROM users JOIN pursuit_follows ON users.userId = pursuit_follows.userId && pursuit_follows.pursuitId = ?';

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
                    "team": JSON.parse("[" + parsedJSON[i].team + "]")
                });
            }
         }
         
         res.json(dictionary[0]);
     });
});

router.get("/get_save_try_status", function(req, res){
    var q = 'SELECT IFNULL(is_tried, 0) as tried, (SELECT IFNULL(is_saved, 0) FROM posts_saved ' +
            'WHERE posts_saved.postId = ? && posts_saved.userId = ?) as saved ' +
            'FROM pursuit_tried WHERE pursuit_tried.pursuitId = ? && pursuit_tried.userId = ?';
    
    var postId = req.query.postId;
    var userId = req.query.userId;
    var pursuitId = req.query.pursuitId;
    
    db_config.query(q, [postId, userId, pursuitId, userId], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         var dictionary = []
         var stringJSON = JSON.stringify(result);
         var parsedJSON = JSON.parse(stringJSON);

         for (var i = 0; i < result.length; i++) {
            dictionary.push({
                "is_tried": JSON.parse(parsedJSON[i].is_tried),
                "is_saved": JSON.parse(parsedJSON[i].is_saved)
            });
        }

         res.json(dictionary)
     });
});

function getConnection(){
    return db_config
}

module.exports = router