
const express = require('express');
const router = express.Router();
const mysql = require('mysql');

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

router.post("/create-interests", function(req, res){    
    var interests = {
        interest_photo : req.body.interest_photo,
        interest_name : req.body.interest_name
    };

    db_config.query('INSERT INTO interests SET ?', interests, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Interests succesfully added");
    });
});

router.get("/get-user-interests-names", function(req, res){
    var q = 'SELECT interestId, interest_name FROM interests ORDER BY interest_name';

    db_config.query(q, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.json(result);
     });
});

router.get("/get-all-interests", function(req, res){

    db_config.query('SELECT * FROM interests ORDER BY interest_name', function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.json(result);
    });
});

router.get("/get-user-interests", function(req, res){
    var selectedUser = req.query.userId;

    var q = 'SELECT interests.*, IFNULL(user_interests.is_selected, 0) as selected_interests ' +
    'FROM interests LEFT JOIN user_interests ON ' +
    'interests.interestId = user_interests.interestId ' +
    'AND user_interests.userId = ? ' +
    'ORDER BY interests.interest_name';

    db_config.query(q, selectedUser, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.json(result);
     });
});

router.get("/get-signup-interests", function(req, res){
    var q = 'SELECT interests.* FROM interests ORDER BY interests.interest_name';

    db_config.query(q, function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
         res.json(result);
     });
});

router.post("/toggle-user-interests", function(req, res){
    var interests = {
      is_selected : req.body.is_selected,
      userId : req.body.userId,
      interestId : req.body.interestId
    };

    var selected = req.body.is_selected;
    var q = 'INSERT INTO user_interests SET ? ON DUPLICATE KEY UPDATE is_selected = ? ';

    db_config.query(q, [interests, selected], function(err, result) {
        if (err) {
            console.log("Failed to query " + err);
            res.sendStatus(500)
            return
        } 
        res.send("Success");
    });
});

function getConnection(){
    return db_config
}

module.exports = router