
var express = require("express");
var app = express();
var morgan = require("morgan")
var mysql = require("mysql");
var bodyParser = require("body-parser");

var users = require('./routes/users');
var engagements = require('./routes/engagements');
var interests = require('./routes/interests');
var posts = require('./routes/posts');
var pursuits = require('./routes/pursuits');
var search = require('./routes/search');

var PORT = process.env.PORT || 8080;

var db_config = mysql.createConnection ({
  host : 'uoa25ublaow4obx5.cbetxkdyhwsb.us-east-1.rds.amazonaws.com',
  user : 'sugegrobpyr4cpea',
  database : 'qnedwtxcaccmbl1h',
  password : 'mglzpy4jwe2emfjr'
});

var connection;

app.use(bodyParser.urlencoded({extended: true}));
app.use( bodyParser.json() );
app.use(morgan('short'));

app.use('/users', users);
app.use('/engagements', engagements);
app.use('/interests', interests);
app.use('/posts', posts);
app.use('/pursuits', pursuits);
app.use('/search', search);

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

app.listen(process.env.PORT || 3000, function(){
  console.log("Express server listening on port %d in %s mode", this.address().port, app.settings.env);
});

app.get("/", function(req, res) {
  res.send('We have a new connection');
});
