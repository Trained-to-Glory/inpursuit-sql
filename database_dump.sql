# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: us-cdbr-iron-east-04.cleardb.net (MySQL 5.5.56-log)
# Database: heroku_b880653a88c80f0
# Generation Time: 2018-12-22 22:15:38 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table interests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `interests`;

CREATE TABLE `interests` (
  `interestId` int(11) NOT NULL AUTO_INCREMENT,
  `interest_photo` text,
  `interest_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`interestId`),
  UNIQUE KEY `interest_name` (`interest_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `interests` WRITE;
/*!40000 ALTER TABLE `interests` DISABLE KEYS */;

INSERT INTO `interests` (`interestId`, `interest_photo`, `interest_name`)
VALUES
	(2,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F28C31ADE-298E-4468-9B1B-BAC389ABE811?alt=media&token=ced0c127-30d7-4072-a3c0-6fa63e0b5a14','Cars'),
	(12,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F9C8EC790-B41E-4C26-B233-D17B1182A2C7?alt=media&token=07e909f3-7d0a-4b7f-a5ee-515155e84598','Graphic Design'),
	(22,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2FDBFAAC5A-497E-46B6-81C5-2EAC16441DA4?alt=media&token=fdc41083-7462-44bc-887a-569dd6bf8919','Business'),
	(32,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F08B93965-AB83-4347-B0A9-F3081A665D42?alt=media&token=4135cfdc-88d7-41a0-9243-942e9d09699d','Food'),
	(42,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2FED03BCCF-03DF-43C9-AE55-CD2AB0956001?alt=media&token=b6feef7e-b3b3-436d-9145-6abc109483f5','Fashion Design'),
	(52,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F020D969B-2DF0-4C81-88C2-9CE95EFCFE21?alt=media&token=48a61d1b-0d57-4216-927f-26fc92ddc238','Health'),
	(62,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2FDB00DDD6-FDA7-426B-81BC-DD8B9245850F?alt=media&token=1b5efb55-55dd-4bbf-8ce6-e719786fb91f','Technology'),
	(72,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F3A27869A-0CC3-4BBE-9722-54A5C6000323?alt=media&token=cb1c79f9-cf89-48b1-8f67-4342f79b07ee','Self'),
	(82,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F4DB8B85F-6155-4D26-901F-25C6C37C8554?alt=media&token=cb473f79-2c4e-4e3e-9d6e-b9ce18b34928','Men Style'),
	(92,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2FAF2AC970-0774-4E96-A80C-74109251F14D?alt=media&token=dbcd9a4f-5487-4330-87b4-624f82f67b60','Digital Design'),
	(102,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2FEFF8BC0B-1687-4CCE-8B3D-7D88CB1C9E64?alt=media&token=8d6c9a35-43e0-4a62-b874-0cb94f5a16e0','Women Style'),
	(112,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2FE47F5F2A-FB30-4CE5-B290-02492057A9A5?alt=media&token=0d3b1a62-a524-49d3-bbca-dfaeb7dc9592','Academics'),
	(122,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2FD49735D4-92B1-4854-BEFF-8942C1ED3962?alt=media&token=7958866c-3b97-4925-8ccd-37b9add2d2f5','Sports'),
	(132,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F7449FDAE-91EC-4B10-AD42-1E9C0BF7EBA4?alt=media&token=f8895ee6-d930-4533-9323-5ad4f205290c','Photography'),
	(142,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F5371804D-C5F0-4AD1-821D-8014DBF88468?alt=media&token=dbdb0b38-d2f3-4a3e-8cf1-7b7dbfe9f0a0','Productivity'),
	(152,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F75C91EFC-4FF0-422D-84AF-D699A358D2D8?alt=media&token=6fa1b740-d85e-4123-90d4-220a8358b9b1','Animals'),
	(162,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F5B820E07-0161-4CED-A8A2-7B3BFDF18FB0?alt=media&token=681d426d-6bd6-4865-aee2-2e0624f27438','Travel'),
	(172,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F4F21CF29-11DA-46BF-8150-3583ED6E41F3?alt=media&token=3a735e1a-282e-472b-9de5-e5bb0dc39722','Music'),
	(182,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2FCAA58795-F542-4751-AAFC-E6ED762D8729?alt=media&token=935f6fe4-0bb3-42d6-aa56-f64bd9a12b9b','Beauty'),
	(192,'https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/interests-images%2F5D30AEF5-F003-4E5B-8850-3EDE68DE4220?alt=media&token=46865dad-6726-48f0-9ecd-2b505d144e6f','Interior Design');

/*!40000 ALTER TABLE `interests` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table posts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `posts`;

CREATE TABLE `posts` (
  `postId` int(11) NOT NULL AUTO_INCREMENT,
  `pursuitId` int(11) NOT NULL,
  `videoUrl` text,
  `thumbnailUrl` text,
  `posts_description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_keyPost` tinyint(4) NOT NULL DEFAULT '0',
  `is_visible` tinyint(4) NOT NULL DEFAULT '1',
  `is_saved` tinyint(4) NOT NULL DEFAULT '0',
  `is_response` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`postId`),
  KEY `pursuitId` (`pursuitId`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`pursuitId`) REFERENCES `pursuits` (`pursuitId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table posts_responses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `posts_responses`;

CREATE TABLE `posts_responses` (
  `postId` int(11) NOT NULL,
  `pursuitId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  KEY `postId` (`postId`),
  KEY `pursuitId` (`pursuitId`),
  KEY `userId` (`userId`),
  CONSTRAINT `posts_responses_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `posts` (`postId`),
  CONSTRAINT `posts_responses_ibfk_2` FOREIGN KEY (`pursuitId`) REFERENCES `pursuits` (`pursuitId`),
  CONSTRAINT `posts_responses_ibfk_3` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table posts_saved
# ------------------------------------------------------------

DROP TABLE IF EXISTS `posts_saved`;

CREATE TABLE `posts_saved` (
  `postId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `is_saved` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`postId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `posts_saved_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `posts` (`postId`),
  CONSTRAINT `posts_saved_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table pursuit_follows
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pursuit_follows`;

CREATE TABLE `pursuit_follows` (
  `pursuitId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `is_following` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`pursuitId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `pursuit_follows_ibfk_1` FOREIGN KEY (`pursuitId`) REFERENCES `pursuits` (`pursuitId`),
  CONSTRAINT `pursuit_follows_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table pursuit_tried
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pursuit_tried`;

CREATE TABLE `pursuit_tried` (
  `pursuitId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `is_tried` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`pursuitId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `pursuit_tried_ibfk_1` FOREIGN KEY (`pursuitId`) REFERENCES `pursuits` (`pursuitId`),
  CONSTRAINT `pursuit_tried_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table pursuits
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pursuits`;

CREATE TABLE `pursuits` (
  `pursuitId` int(11) NOT NULL AUTO_INCREMENT,
  `interestId` int(11) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `thumbnailUrl` text,
  `pursuit_description` text,
  `old_pursuitId` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_visible` tinyint(4) NOT NULL DEFAULT '1',
  `is_public` tinyint(4) NOT NULL DEFAULT '1',
  `is_tried` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pursuitId`),
  KEY `interestId` (`interestId`),
  KEY `userId` (`userId`),
  CONSTRAINT `pursuits_ibfk_1` FOREIGN KEY (`interestId`) REFERENCES `interests` (`interestId`),
  CONSTRAINT `pursuits_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table similar_pursuit
# ------------------------------------------------------------

DROP TABLE IF EXISTS `similar_pursuit`;

CREATE TABLE `similar_pursuit` (
  `pursuitId` int(11) NOT NULL,
  `new_pursuitId` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`pursuitId`,`new_pursuitId`),
  KEY `new_pursuitId` (`new_pursuitId`),
  CONSTRAINT `similar_pursuit_ibfk_1` FOREIGN KEY (`pursuitId`) REFERENCES `pursuits` (`pursuitId`),
  CONSTRAINT `similar_pursuit_ibfk_2` FOREIGN KEY (`new_pursuitId`) REFERENCES `pursuits` (`pursuitId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table user_follows
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_follows`;

CREATE TABLE `user_follows` (
  `followerId` int(11) NOT NULL,
  `followeeId` int(11) NOT NULL,
  `is_following` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`followerId`,`followeeId`),
  KEY `followeeId` (`followeeId`),
  CONSTRAINT `user_follows_ibfk_1` FOREIGN KEY (`followerId`) REFERENCES `users` (`userId`),
  CONSTRAINT `user_follows_ibfk_2` FOREIGN KEY (`followeeId`) REFERENCES `users` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table user_interests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_interests`;

CREATE TABLE `user_interests` (
  `interestId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `is_selected` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`interestId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `user_interests_ibfk_1` FOREIGN KEY (`interestId`) REFERENCES `interests` (`interestId`),
  CONSTRAINT `user_interests_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `user_interests` WRITE;
/*!40000 ALTER TABLE `user_interests` DISABLE KEYS */;

INSERT INTO `user_interests` (`interestId`, `userId`, `is_selected`)
VALUES
	(112,102,1),
	(182,102,1);

/*!40000 ALTER TABLE `user_interests` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `fullname` varchar(255) NOT NULL,
  `photoUrl` text NOT NULL,
  `bio` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`userId`, `email`, `username`, `fullname`, `photoUrl`, `bio`, `created_at`)
VALUES
	(102,'Test@test.com','Test','Test','https://firebasestorage.googleapis.com/v0/b/pursue-c5afe.appspot.com/o/profile-images%2FCA914CE8-CC0F-4464-9D72-CB9CA9DDAFC9?alt=media&token=92f95beb-e21c-4986-9c63-7eddcc88dace',NULL,'2018-12-06 03:30:15'),
	(112,'Test2@test.com','','Test2','https://photoUrl.com',NULL,'2018-12-06 04:00:27');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
