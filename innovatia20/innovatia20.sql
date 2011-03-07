CREATE TABLE  `innovatia`.`userIdeas` (
  `ideaId` int(10) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) default NULL,
  `licence` varchar(255) default NULL,
  `visibility` varchar(255) default NULL,
  `username` varchar(255) default NULL,
  `clientid` varchar(255) default NULL,
  `lastupdated` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`ideaId`)
) ENGINE=MyISAM AUTO_INCREMENT=359 DEFAULT CHARSET=latin1
