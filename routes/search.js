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

router.get("/get-search", function(req, res){
    var searchText = req.query.searchText;
    var q = 'SET group_concat_max_len = 1000000; SELECT users.userId, users.photoUrl, users.username, (SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("pursuitId", pursuits.pursuitId, "thumbnailUrl", pursuits.thumbnailUrl, ' +
    '"description", pursuits.pursuit_description, "created_at", pursuits.created_at)), "{}") ' +
    'FROM pursuits WHERE pursuits.pursuit_description LIKE ? ' +
    'ORDER BY pursuits.created_at) as pursuits, ' +
    '(SELECT IFNULL(GROUP_CONCAT(JSON_OBJECT("postId", posts.postId, "pursuitId", posts.pursuitId, "thumbnailUrl", posts.thumbnailUrl, "description", posts.posts_description, "created_at", posts.created_at)), "{}") FROM ' +
    'posts WHERE posts.posts_description LIKE ? ORDER BY posts.created_at) as posts ' +
    'FROM users WHERE users.username LIKE ? LIMIT 1';

    db_config.query(q, [searchText, searchText, searchText], function(err, result) {
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
                    "posts" : JSON.parse("[" + parsedJSON[i].posts + "]"),
                    "pursuits": JSON.parse("[" + parsedJSON[i].pursuits + "]")
                });
            }  
        }       
         res.json(dictionary[0])

     });
});

function getConnection(){
    return db_config
}

module.exports = router