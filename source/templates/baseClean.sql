-- MySQL dump 10.11
--
-- Host: localhost    Database: ojs_base
-- ------------------------------------------------------
-- Server version	5.0.51a-24+lenny5

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_keys`
--

DROP TABLE IF EXISTS `access_keys`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `access_keys` (
  `access_key_id` bigint(20) NOT NULL auto_increment,
  `context` varchar(40) NOT NULL,
  `key_hash` varchar(40) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) default NULL,
  `expiry_date` datetime NOT NULL,
  PRIMARY KEY  (`access_key_id`),
  KEY `access_keys_hash` (`key_hash`,`user_id`,`context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `access_keys`
--

LOCK TABLES `access_keys` WRITE;
/*!40000 ALTER TABLE `access_keys` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcement_settings`
--

DROP TABLE IF EXISTS `announcement_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `announcement_settings` (
  `announcement_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `announcement_settings_pkey` (`announcement_id`,`locale`,`setting_name`),
  KEY `announcement_settings_announcement_id` (`announcement_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `announcement_settings`
--

LOCK TABLES `announcement_settings` WRITE;
/*!40000 ALTER TABLE `announcement_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcement_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcement_type_settings`
--

DROP TABLE IF EXISTS `announcement_type_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `announcement_type_settings` (
  `type_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `announcement_type_settings_pkey` (`type_id`,`locale`,`setting_name`),
  KEY `announcement_type_settings_type_id` (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `announcement_type_settings`
--

LOCK TABLES `announcement_type_settings` WRITE;
/*!40000 ALTER TABLE `announcement_type_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcement_type_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcement_types`
--

DROP TABLE IF EXISTS `announcement_types`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `announcement_types` (
  `type_id` bigint(20) NOT NULL auto_increment,
  `assoc_type` smallint(6) default NULL,
  `assoc_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`type_id`),
  KEY `announcement_types_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `announcement_types`
--

LOCK TABLES `announcement_types` WRITE;
/*!40000 ALTER TABLE `announcement_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcement_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `announcements` (
  `announcement_id` bigint(20) NOT NULL auto_increment,
  `assoc_type` smallint(6) default NULL,
  `assoc_id` bigint(20) NOT NULL,
  `type_id` bigint(20) default NULL,
  `date_expire` datetime default NULL,
  `date_posted` datetime NOT NULL,
  PRIMARY KEY  (`announcement_id`),
  KEY `announcements_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_comments`
--

DROP TABLE IF EXISTS `article_comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_comments` (
  `comment_id` bigint(20) NOT NULL auto_increment,
  `comment_type` bigint(20) default NULL,
  `role_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `author_id` bigint(20) NOT NULL,
  `comment_title` varchar(255) NOT NULL,
  `comments` text,
  `date_posted` datetime default NULL,
  `date_modified` datetime default NULL,
  `viewable` tinyint(4) default NULL,
  PRIMARY KEY  (`comment_id`),
  KEY `article_comments_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_comments`
--

LOCK TABLES `article_comments` WRITE;
/*!40000 ALTER TABLE `article_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_email_log`
--

DROP TABLE IF EXISTS `article_email_log`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_email_log` (
  `log_id` bigint(20) NOT NULL auto_increment,
  `article_id` bigint(20) NOT NULL,
  `sender_id` bigint(20) NOT NULL,
  `date_sent` datetime NOT NULL,
  `ip_address` varchar(15) default NULL,
  `event_type` bigint(20) default NULL,
  `assoc_type` bigint(20) default NULL,
  `assoc_id` bigint(20) default NULL,
  `from_address` varchar(255) default NULL,
  `recipients` text,
  `cc_recipients` text,
  `bcc_recipients` text,
  `subject` varchar(255) default NULL,
  `body` text,
  PRIMARY KEY  (`log_id`),
  KEY `article_email_log_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_email_log`
--

LOCK TABLES `article_email_log` WRITE;
/*!40000 ALTER TABLE `article_email_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_email_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_event_log`
--

DROP TABLE IF EXISTS `article_event_log`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_event_log` (
  `log_id` bigint(20) NOT NULL auto_increment,
  `article_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_logged` datetime NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `log_level` varchar(1) default NULL,
  `event_type` bigint(20) default NULL,
  `assoc_type` bigint(20) default NULL,
  `assoc_id` bigint(20) default NULL,
  `message` text,
  PRIMARY KEY  (`log_id`),
  KEY `article_event_log_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_event_log`
--

LOCK TABLES `article_event_log` WRITE;
/*!40000 ALTER TABLE `article_event_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_event_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_files`
--

DROP TABLE IF EXISTS `article_files`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_files` (
  `file_id` bigint(20) NOT NULL auto_increment,
  `revision` bigint(20) NOT NULL,
  `source_file_id` bigint(20) default NULL,
  `source_revision` bigint(20) default NULL,
  `article_id` bigint(20) NOT NULL,
  `file_name` varchar(90) NOT NULL,
  `file_type` varchar(255) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `original_file_name` varchar(127) default NULL,
  `type` varchar(40) NOT NULL,
  `viewable` tinyint(4) default NULL,
  `date_uploaded` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `round` tinyint(4) NOT NULL,
  `assoc_id` bigint(20) default NULL,
  PRIMARY KEY  (`file_id`,`revision`),
  KEY `article_files_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_files`
--

LOCK TABLES `article_files` WRITE;
/*!40000 ALTER TABLE `article_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_galleys`
--

DROP TABLE IF EXISTS `article_galleys`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_galleys` (
  `galley_id` bigint(20) NOT NULL auto_increment,
  `public_galley_id` varchar(255) default NULL,
  `locale` varchar(5) default NULL,
  `article_id` bigint(20) NOT NULL,
  `file_id` bigint(20) NOT NULL,
  `label` varchar(32) default NULL,
  `html_galley` tinyint(4) NOT NULL default '0',
  `style_file_id` bigint(20) default NULL,
  `seq` double NOT NULL default '0',
  `views` int(11) NOT NULL default '0',
  PRIMARY KEY  (`galley_id`),
  UNIQUE KEY `article_galleys_public_id` (`public_galley_id`,`article_id`),
  KEY `article_galleys_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_galleys`
--

LOCK TABLES `article_galleys` WRITE;
/*!40000 ALTER TABLE `article_galleys` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_galleys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_html_galley_images`
--

DROP TABLE IF EXISTS `article_html_galley_images`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_html_galley_images` (
  `galley_id` bigint(20) NOT NULL,
  `file_id` bigint(20) NOT NULL,
  UNIQUE KEY `article_html_galley_images_pkey` (`galley_id`,`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_html_galley_images`
--

LOCK TABLES `article_html_galley_images` WRITE;
/*!40000 ALTER TABLE `article_html_galley_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_html_galley_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_notes`
--

DROP TABLE IF EXISTS `article_notes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_notes` (
  `note_id` bigint(20) NOT NULL auto_increment,
  `article_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `note` text,
  `file_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`note_id`),
  KEY `article_notes_article_id` (`article_id`),
  KEY `article_notes_user_id` (`user_id`),
  KEY `article_notes_file_id` (`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_notes`
--

LOCK TABLES `article_notes` WRITE;
/*!40000 ALTER TABLE `article_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_search_keyword_list`
--

DROP TABLE IF EXISTS `article_search_keyword_list`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_search_keyword_list` (
  `keyword_id` bigint(20) NOT NULL auto_increment,
  `keyword_text` varchar(60) NOT NULL,
  PRIMARY KEY  (`keyword_id`),
  UNIQUE KEY `article_search_keyword_text` (`keyword_text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_search_keyword_list`
--

LOCK TABLES `article_search_keyword_list` WRITE;
/*!40000 ALTER TABLE `article_search_keyword_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_search_keyword_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_search_object_keywords`
--

DROP TABLE IF EXISTS `article_search_object_keywords`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_search_object_keywords` (
  `object_id` bigint(20) NOT NULL,
  `keyword_id` bigint(20) NOT NULL,
  `pos` int(11) NOT NULL,
  UNIQUE KEY `article_search_object_keywords_pkey` (`object_id`,`pos`),
  KEY `article_search_object_keywords_keyword_id` (`keyword_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_search_object_keywords`
--

LOCK TABLES `article_search_object_keywords` WRITE;
/*!40000 ALTER TABLE `article_search_object_keywords` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_search_object_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_search_objects`
--

DROP TABLE IF EXISTS `article_search_objects`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_search_objects` (
  `object_id` bigint(20) NOT NULL auto_increment,
  `article_id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL,
  `assoc_id` bigint(20) default NULL,
  PRIMARY KEY  (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_search_objects`
--

LOCK TABLES `article_search_objects` WRITE;
/*!40000 ALTER TABLE `article_search_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_search_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_settings`
--

DROP TABLE IF EXISTS `article_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_settings` (
  `article_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `article_settings_pkey` (`article_id`,`locale`,`setting_name`),
  KEY `article_settings_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_settings`
--

LOCK TABLES `article_settings` WRITE;
/*!40000 ALTER TABLE `article_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_supp_file_settings`
--

DROP TABLE IF EXISTS `article_supp_file_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_supp_file_settings` (
  `supp_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `article_supp_file_settings_pkey` (`supp_id`,`locale`,`setting_name`),
  KEY `article_supp_file_settings_supp_id` (`supp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_supp_file_settings`
--

LOCK TABLES `article_supp_file_settings` WRITE;
/*!40000 ALTER TABLE `article_supp_file_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_supp_file_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_supplementary_files`
--

DROP TABLE IF EXISTS `article_supplementary_files`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_supplementary_files` (
  `supp_id` bigint(20) NOT NULL auto_increment,
  `file_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `type` varchar(255) default NULL,
  `language` varchar(10) default NULL,
  `public_supp_file_id` varchar(255) default NULL,
  `date_created` date default NULL,
  `show_reviewers` tinyint(4) default '0',
  `date_submitted` datetime NOT NULL,
  `seq` double NOT NULL default '0',
  PRIMARY KEY  (`supp_id`),
  KEY `article_supplementary_files_file_id` (`file_id`),
  KEY `article_supplementary_files_article_id` (`article_id`),
  KEY `supp_public_supp_file_id` (`public_supp_file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_supplementary_files`
--

LOCK TABLES `article_supplementary_files` WRITE;
/*!40000 ALTER TABLE `article_supplementary_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_supplementary_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_xml_galleys`
--

DROP TABLE IF EXISTS `article_xml_galleys`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `article_xml_galleys` (
  `xml_galley_id` bigint(20) NOT NULL auto_increment,
  `galley_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `label` varchar(32) NOT NULL,
  `galley_type` varchar(255) NOT NULL,
  `views` int(11) NOT NULL default '0',
  PRIMARY KEY  (`xml_galley_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `article_xml_galleys`
--

LOCK TABLES `article_xml_galleys` WRITE;
/*!40000 ALTER TABLE `article_xml_galleys` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_xml_galleys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `articles` (
  `article_id` bigint(20) NOT NULL auto_increment,
  `locale` varchar(5) default NULL,
  `user_id` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `section_id` bigint(20) default NULL,
  `language` varchar(10) default 'en',
  `comments_to_ed` text,
  `citations` text,
  `date_submitted` datetime default NULL,
  `last_modified` datetime default NULL,
  `date_status_modified` datetime default NULL,
  `status` tinyint(4) NOT NULL default '1',
  `submission_progress` tinyint(4) NOT NULL default '1',
  `current_round` tinyint(4) NOT NULL default '1',
  `submission_file_id` bigint(20) default NULL,
  `revised_file_id` bigint(20) default NULL,
  `review_file_id` bigint(20) default NULL,
  `editor_file_id` bigint(20) default NULL,
  `pages` varchar(255) default NULL,
  `doi` varchar(255) default NULL,
  `fast_tracked` tinyint(4) NOT NULL default '0',
  `hide_author` tinyint(4) NOT NULL default '0',
  `comments_status` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`article_id`),
  KEY `articles_user_id` (`user_id`),
  KEY `articles_journal_id` (`journal_id`),
  KEY `articles_section_id` (`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_sources`
--

DROP TABLE IF EXISTS `auth_sources`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `auth_sources` (
  `auth_id` bigint(20) NOT NULL auto_increment,
  `title` varchar(60) NOT NULL,
  `plugin` varchar(32) NOT NULL,
  `auth_default` tinyint(4) NOT NULL default '0',
  `settings` text,
  PRIMARY KEY  (`auth_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `auth_sources`
--

LOCK TABLES `auth_sources` WRITE;
/*!40000 ALTER TABLE `auth_sources` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author_settings`
--

DROP TABLE IF EXISTS `author_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `author_settings` (
  `author_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `author_settings_pkey` (`author_id`,`locale`,`setting_name`),
  KEY `author_settings_author_id` (`author_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `author_settings`
--

LOCK TABLES `author_settings` WRITE;
/*!40000 ALTER TABLE `author_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `author_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `authors` (
  `author_id` bigint(20) NOT NULL auto_increment,
  `submission_id` bigint(20) NOT NULL,
  `primary_contact` tinyint(4) NOT NULL default '0',
  `seq` double NOT NULL default '0',
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) default NULL,
  `last_name` varchar(90) NOT NULL,
  `country` varchar(90) default NULL,
  `email` varchar(90) NOT NULL,
  `url` varchar(255) default NULL,
  `user_group_id` bigint(20) default NULL,
  PRIMARY KEY  (`author_id`),
  KEY `authors_submission_id` (`submission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_for_review`
--

DROP TABLE IF EXISTS `books_for_review`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `books_for_review` (
  `book_id` bigint(20) NOT NULL auto_increment,
  `journal_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `author_type` smallint(6) NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `year` smallint(6) NOT NULL,
  `language` varchar(10) NOT NULL default 'en',
  `copy` tinyint(4) NOT NULL default '0',
  `url` varchar(255) default NULL,
  `edition` tinyint(4) default NULL,
  `pages` smallint(6) default NULL,
  `isbn` varchar(30) default NULL,
  `date_created` datetime NOT NULL,
  `date_requested` datetime default NULL,
  `date_assigned` datetime default NULL,
  `date_mailed` datetime default NULL,
  `date_due` datetime default NULL,
  `date_submitted` datetime default NULL,
  `user_id` bigint(20) default NULL,
  `editor_id` bigint(20) default NULL,
  `article_id` bigint(20) default NULL,
  `notes` text,
  PRIMARY KEY  (`book_id`),
  KEY `bfr_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `books_for_review`
--

LOCK TABLES `books_for_review` WRITE;
/*!40000 ALTER TABLE `books_for_review` DISABLE KEYS */;
/*!40000 ALTER TABLE `books_for_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_for_review_authors`
--

DROP TABLE IF EXISTS `books_for_review_authors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `books_for_review_authors` (
  `author_id` bigint(20) NOT NULL auto_increment,
  `book_id` bigint(20) NOT NULL,
  `seq` double NOT NULL default '0',
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) default NULL,
  `last_name` varchar(90) NOT NULL,
  PRIMARY KEY  (`author_id`),
  KEY `bfr_book_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `books_for_review_authors`
--

LOCK TABLES `books_for_review_authors` WRITE;
/*!40000 ALTER TABLE `books_for_review_authors` DISABLE KEYS */;
/*!40000 ALTER TABLE `books_for_review_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_for_review_settings`
--

DROP TABLE IF EXISTS `books_for_review_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `books_for_review_settings` (
  `book_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `bfr_settings_pkey` (`book_id`,`locale`,`setting_name`),
  KEY `bfr_settings_book_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `books_for_review_settings`
--

LOCK TABLES `books_for_review_settings` WRITE;
/*!40000 ALTER TABLE `books_for_review_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `books_for_review_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `captchas`
--

DROP TABLE IF EXISTS `captchas`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `captchas` (
  `captcha_id` bigint(20) NOT NULL auto_increment,
  `session_id` varchar(40) NOT NULL,
  `value` varchar(20) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY  (`captcha_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `captchas`
--

LOCK TABLES `captchas` WRITE;
/*!40000 ALTER TABLE `captchas` DISABLE KEYS */;
/*!40000 ALTER TABLE `captchas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citation_settings`
--

DROP TABLE IF EXISTS `citation_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `citation_settings` (
  `citation_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `citation_settings_pkey` (`citation_id`,`locale`,`setting_name`),
  KEY `citation_settings_citation_id` (`citation_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `citation_settings`
--

LOCK TABLES `citation_settings` WRITE;
/*!40000 ALTER TABLE `citation_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `citation_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations`
--

DROP TABLE IF EXISTS `citations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `citations` (
  `citation_id` bigint(20) NOT NULL auto_increment,
  `assoc_type` bigint(20) NOT NULL default '0',
  `assoc_id` bigint(20) NOT NULL default '0',
  `citation_state` bigint(20) NOT NULL,
  `raw_citation` text,
  `seq` bigint(20) NOT NULL default '0',
  `lock_id` varchar(23) default NULL,
  PRIMARY KEY  (`citation_id`),
  UNIQUE KEY `citations_assoc_seq` (`assoc_type`,`assoc_id`,`seq`),
  KEY `citations_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `citations`
--

LOCK TABLES `citations` WRITE;
/*!40000 ALTER TABLE `citations` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `comments` (
  `comment_id` bigint(20) NOT NULL auto_increment,
  `submission_id` bigint(20) NOT NULL,
  `parent_comment_id` bigint(20) default NULL,
  `num_children` int(11) NOT NULL default '0',
  `user_id` bigint(20) default NULL,
  `poster_ip` varchar(15) NOT NULL,
  `poster_name` varchar(90) default NULL,
  `poster_email` varchar(90) default NULL,
  `title` varchar(255) NOT NULL,
  `body` text,
  `date_posted` datetime default NULL,
  `date_modified` datetime default NULL,
  PRIMARY KEY  (`comment_id`),
  KEY `comments_submission_id` (`submission_id`),
  KEY `comments_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `completed_payments`
--

DROP TABLE IF EXISTS `completed_payments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `completed_payments` (
  `completed_payment_id` bigint(20) NOT NULL auto_increment,
  `timestamp` datetime NOT NULL,
  `payment_type` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) default NULL,
  `assoc_id` bigint(20) default NULL,
  `amount` double NOT NULL,
  `currency_code_alpha` varchar(3) default NULL,
  `payment_method_plugin_name` varchar(80) default NULL,
  PRIMARY KEY  (`completed_payment_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `completed_payments`
--

LOCK TABLES `completed_payments` WRITE;
/*!40000 ALTER TABLE `completed_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `completed_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controlled_vocab_entries`
--

DROP TABLE IF EXISTS `controlled_vocab_entries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `controlled_vocab_entries` (
  `controlled_vocab_entry_id` bigint(20) NOT NULL auto_increment,
  `controlled_vocab_id` bigint(20) NOT NULL,
  `seq` double default NULL,
  PRIMARY KEY  (`controlled_vocab_entry_id`),
  KEY `controlled_vocab_entries_cv_id` (`controlled_vocab_id`,`seq`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `controlled_vocab_entries`
--

LOCK TABLES `controlled_vocab_entries` WRITE;
/*!40000 ALTER TABLE `controlled_vocab_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `controlled_vocab_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controlled_vocab_entry_settings`
--

DROP TABLE IF EXISTS `controlled_vocab_entry_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `controlled_vocab_entry_settings` (
  `controlled_vocab_entry_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `c_v_e_s_pkey` (`controlled_vocab_entry_id`,`locale`,`setting_name`),
  KEY `c_v_e_s_entry_id` (`controlled_vocab_entry_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `controlled_vocab_entry_settings`
--

LOCK TABLES `controlled_vocab_entry_settings` WRITE;
/*!40000 ALTER TABLE `controlled_vocab_entry_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `controlled_vocab_entry_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controlled_vocabs`
--

DROP TABLE IF EXISTS `controlled_vocabs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `controlled_vocabs` (
  `controlled_vocab_id` bigint(20) NOT NULL auto_increment,
  `symbolic` varchar(64) NOT NULL,
  `assoc_type` bigint(20) NOT NULL default '0',
  `assoc_id` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`controlled_vocab_id`),
  UNIQUE KEY `controlled_vocab_symbolic` (`symbolic`,`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `controlled_vocabs`
--

LOCK TABLES `controlled_vocabs` WRITE;
/*!40000 ALTER TABLE `controlled_vocabs` DISABLE KEYS */;
/*!40000 ALTER TABLE `controlled_vocabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `counter_monthly_log`
--

DROP TABLE IF EXISTS `counter_monthly_log`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `counter_monthly_log` (
  `year` bigint(20) NOT NULL,
  `month` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `count_html` bigint(20) NOT NULL default '0',
  `count_pdf` bigint(20) NOT NULL default '0',
  `count_other` bigint(20) NOT NULL default '0',
  UNIQUE KEY `counter_monthly_log_key` (`year`,`month`,`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `counter_monthly_log`
--

LOCK TABLES `counter_monthly_log` WRITE;
/*!40000 ALTER TABLE `counter_monthly_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `counter_monthly_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_issue_orders`
--

DROP TABLE IF EXISTS `custom_issue_orders`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `custom_issue_orders` (
  `issue_id` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `seq` double NOT NULL default '0',
  UNIQUE KEY `custom_issue_orders_pkey` (`issue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `custom_issue_orders`
--

LOCK TABLES `custom_issue_orders` WRITE;
/*!40000 ALTER TABLE `custom_issue_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_issue_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_section_orders`
--

DROP TABLE IF EXISTS `custom_section_orders`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `custom_section_orders` (
  `issue_id` bigint(20) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `seq` double NOT NULL default '0',
  UNIQUE KEY `custom_section_orders_pkey` (`issue_id`,`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `custom_section_orders`
--

LOCK TABLES `custom_section_orders` WRITE;
/*!40000 ALTER TABLE `custom_section_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_section_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `edit_assignments`
--

DROP TABLE IF EXISTS `edit_assignments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `edit_assignments` (
  `edit_id` bigint(20) NOT NULL auto_increment,
  `article_id` bigint(20) NOT NULL,
  `editor_id` bigint(20) NOT NULL,
  `can_edit` tinyint(4) NOT NULL default '1',
  `can_review` tinyint(4) NOT NULL default '1',
  `date_assigned` datetime default NULL,
  `date_notified` datetime default NULL,
  `date_underway` datetime default NULL,
  PRIMARY KEY  (`edit_id`),
  KEY `edit_assignments_article_id` (`article_id`),
  KEY `edit_assignments_editor_id` (`editor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `edit_assignments`
--

LOCK TABLES `edit_assignments` WRITE;
/*!40000 ALTER TABLE `edit_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `edit_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `edit_decisions`
--

DROP TABLE IF EXISTS `edit_decisions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `edit_decisions` (
  `edit_decision_id` bigint(20) NOT NULL auto_increment,
  `article_id` bigint(20) NOT NULL,
  `round` tinyint(4) NOT NULL,
  `editor_id` bigint(20) NOT NULL,
  `decision` tinyint(4) NOT NULL,
  `date_decided` datetime NOT NULL,
  PRIMARY KEY  (`edit_decision_id`),
  KEY `edit_decisions_article_id` (`article_id`),
  KEY `edit_decisions_editor_id` (`editor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `edit_decisions`
--

LOCK TABLES `edit_decisions` WRITE;
/*!40000 ALTER TABLE `edit_decisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `edit_decisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_templates`
--

DROP TABLE IF EXISTS `email_templates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `email_templates` (
  `email_id` bigint(20) NOT NULL auto_increment,
  `email_key` varchar(30) NOT NULL,
  `assoc_type` bigint(20) default '0',
  `assoc_id` bigint(20) default '0',
  `enabled` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`email_id`),
  UNIQUE KEY `email_templates_email_key` (`email_key`,`assoc_type`,`assoc_id`),
  KEY `email_templates_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `email_templates`
--

LOCK TABLES `email_templates` WRITE;
/*!40000 ALTER TABLE `email_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_templates_data`
--

DROP TABLE IF EXISTS `email_templates_data`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `email_templates_data` (
  `email_key` varchar(30) NOT NULL,
  `locale` varchar(5) NOT NULL default 'en_US',
  `assoc_type` bigint(20) default '0',
  `assoc_id` bigint(20) default '0',
  `subject` varchar(120) NOT NULL,
  `body` text,
  UNIQUE KEY `email_templates_data_pkey` (`email_key`,`locale`,`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `email_templates_data`
--

LOCK TABLES `email_templates_data` WRITE;
/*!40000 ALTER TABLE `email_templates_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_templates_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_templates_default`
--

DROP TABLE IF EXISTS `email_templates_default`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `email_templates_default` (
  `email_id` bigint(20) NOT NULL auto_increment,
  `email_key` varchar(30) NOT NULL,
  `can_disable` tinyint(4) NOT NULL default '1',
  `can_edit` tinyint(4) NOT NULL default '1',
  `from_role_id` bigint(20) default NULL,
  `to_role_id` bigint(20) default NULL,
  PRIMARY KEY  (`email_id`),
  KEY `email_templates_default_email_key` (`email_key`)
) ENGINE=MyISAM AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `email_templates_default`
--

LOCK TABLES `email_templates_default` WRITE;
/*!40000 ALTER TABLE `email_templates_default` DISABLE KEYS */;
INSERT INTO `email_templates_default` VALUES (1,'NOTIFICATION',0,1,NULL,NULL),(2,'NOTIFICATION_MAILLIST',0,1,NULL,NULL),(3,'NOTIFICATION_MAILLIST_WELCOME',0,1,NULL,NULL),(4,'NOTIFICATION_MAILLIST_PASSWORD',0,1,NULL,NULL),(5,'PASSWORD_RESET_CONFIRM',0,1,NULL,NULL),(6,'PASSWORD_RESET',0,1,NULL,NULL),(7,'USER_REGISTER',0,1,NULL,NULL),(8,'USER_VALIDATE',0,1,NULL,NULL),(9,'REVIEWER_REGISTER',0,1,NULL,NULL),(10,'PUBLISH_NOTIFY',0,1,NULL,NULL),(11,'LOCKSS_EXISTING_ARCHIVE',0,1,NULL,NULL),(12,'LOCKSS_NEW_ARCHIVE',0,1,NULL,NULL),(13,'SUBMISSION_ACK',1,1,NULL,65536),(14,'SUBMISSION_UNSUITABLE',1,1,512,65536),(15,'SUBMISSION_COMMENT',0,1,NULL,NULL),(16,'SUBMISSION_DECISION_REVIEWERS',0,1,512,4096),(17,'EDITOR_ASSIGN',1,1,256,512),(18,'REVIEW_CANCEL',1,1,512,4096),(19,'REVIEW_REQUEST',1,1,512,4096),(20,'REVIEW_REQUEST_ONECLICK',1,1,512,4096),(21,'REVIEW_REQUEST_ATTACHED',0,1,512,4096),(22,'REVIEW_CONFIRM',1,1,4096,512),(23,'REVIEW_DECLINE',1,1,4096,512),(24,'REVIEW_COMPLETE',1,1,4096,512),(25,'REVIEW_ACK',1,1,512,4096),(26,'REVIEW_REMIND',0,1,512,4096),(27,'REVIEW_REMIND_AUTO',0,1,NULL,4096),(28,'REVIEW_REMIND_ONECLICK',0,1,512,4096),(29,'REVIEW_REMIND_AUTO_ONECLICK',0,1,NULL,4096),(30,'EDITOR_DECISION_ACCEPT',0,1,512,65536),(31,'EDITOR_DECISION_REVISIONS',0,1,512,65536),(32,'EDITOR_DECISION_RESUBMIT',0,1,512,65536),(33,'EDITOR_DECISION_DECLINE',0,1,512,65536),(34,'COPYEDIT_REQUEST',1,1,512,8192),(35,'COPYEDIT_COMPLETE',1,1,8192,65536),(36,'COPYEDIT_ACK',1,1,512,8192),(37,'COPYEDIT_AUTHOR_REQUEST',1,1,512,65536),(38,'COPYEDIT_AUTHOR_COMPLETE',1,1,65536,512),(39,'COPYEDIT_AUTHOR_ACK',1,1,512,65536),(40,'COPYEDIT_FINAL_REQUEST',1,1,512,8192),(41,'COPYEDIT_FINAL_COMPLETE',1,1,8192,512),(42,'COPYEDIT_FINAL_ACK',1,1,512,8192),(43,'LAYOUT_REQUEST',1,1,512,768),(44,'LAYOUT_COMPLETE',1,1,768,512),(45,'LAYOUT_ACK',1,1,512,768),(46,'PROOFREAD_AUTHOR_REQUEST',1,1,512,65536),(47,'PROOFREAD_AUTHOR_COMPLETE',1,1,65536,512),(48,'PROOFREAD_AUTHOR_ACK',1,1,512,65536),(49,'PROOFREAD_REQUEST',1,1,512,12288),(50,'PROOFREAD_COMPLETE',1,1,12288,512),(51,'PROOFREAD_ACK',1,1,512,12288),(52,'PROOFREAD_LAYOUT_REQUEST',1,1,512,768),(53,'PROOFREAD_LAYOUT_COMPLETE',1,1,768,512),(54,'PROOFREAD_LAYOUT_ACK',1,1,512,768),(55,'EMAIL_LINK',0,1,1048576,NULL),(56,'SUBSCRIPTION_NOTIFY',0,1,NULL,1048576),(57,'OPEN_ACCESS_NOTIFY',0,1,NULL,1048576),(58,'SUBSCRIPTION_BEFORE_EXPIRY',0,1,NULL,1048576),(59,'SUBSCRIPTION_AFTER_EXPIRY',0,1,NULL,1048576),(60,'SUBSCRIPTION_AFTER_EXPIRY_LAST',0,1,NULL,1048576),(61,'SUBSCRIPTION_PURCHASE_INDL',0,1,NULL,2097152),(62,'SUBSCRIPTION_PURCHASE_INSTL',0,1,NULL,2097152),(63,'SUBSCRIPTION_RENEW_INDL',0,1,NULL,2097152),(64,'SUBSCRIPTION_RENEW_INSTL',0,1,NULL,2097152),(65,'CITATION_EDITOR_AUTHOR_QUERY',0,1,NULL,NULL),(66,'BFR_REVIEW_REMINDER',0,1,256,65536),(67,'BFR_REVIEW_REMINDER_LATE',0,1,256,65536),(68,'BFR_BOOK_ASSIGNED',0,1,256,65536),(69,'BFR_BOOK_DENIED',0,1,256,65536),(70,'BFR_BOOK_REQUESTED',0,1,65536,256),(71,'BFR_BOOK_MAILED',0,1,256,65536),(72,'BFR_REVIEWER_REMOVED',0,1,256,65536),(73,'THESIS_ABSTRACT_CONFIRM',0,1,NULL,NULL),(74,'SWORD_DEPOSIT_NOTIFICATION',0,1,NULL,NULL),(75,'MANUAL_PAYMENT_NOTIFICATION',0,1,NULL,NULL),(76,'PAYPAL_INVESTIGATE_PAYMENT',0,1,NULL,NULL);
/*!40000 ALTER TABLE `email_templates_default` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_templates_default_data`
--

DROP TABLE IF EXISTS `email_templates_default_data`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `email_templates_default_data` (
  `email_key` varchar(30) NOT NULL,
  `locale` varchar(5) NOT NULL default 'en_US',
  `subject` varchar(120) NOT NULL,
  `body` text,
  `description` text,
  UNIQUE KEY `email_templates_default_data_pkey` (`email_key`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `email_templates_default_data`
--

LOCK TABLES `email_templates_default_data` WRITE;
/*!40000 ALTER TABLE `email_templates_default_data` DISABLE KEYS */;
INSERT INTO `email_templates_default_data` VALUES ('NOTIFICATION','en_US','New notification from {$siteTitle}','You have a new notification from {$siteTitle}:\n\n{$notificationContents}\n\nLink: {$url}\n\n{$principalContactSignature}','The email is sent to registered users that have selected to have this type of notification emailed to them.'),('NOTIFICATION_MAILLIST','en_US','New notification from {$siteTitle}','You have a new notification from {$siteTitle}:\n--\n{$notificationContents}\n\nLink: {$url}\n--\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\n{$principalContactSignature}','This email is sent to unregistered users on the notification mailing list.'),('NOTIFICATION_MAILLIST_WELCOME','en_US','Welcome to the the {$siteTitle} mailing list!','You have signed up to receive notifications from {$siteTitle}.\n			\nPlease click on this link to confirm your request and add your email address to the mailing list: {$confirmLink}\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\nYour password for disabling notification emails is: {$password}\n\n{$principalContactSignature}','This email is sent to an unregistered user who just registered with the notification mailing list.'),('NOTIFICATION_MAILLIST_PASSWORD','en_US','Your notification mailing list information for {$siteTitle}','Your new password for disabling notification emails is: {$password}\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\n{$principalContactSignature}','This email is sent to an unregistered user on the notification mailing list when they indicate that they have forgotten their password or are unable to login. It provides a URL they can follow to reset their password.'),('PASSWORD_RESET_CONFIRM','en_US','Password Reset Confirmation','We have received a request to reset your password for the {$siteTitle} web site.\n\nIf you did not make this request, please ignore this email and your password will not be changed. If you wish to reset your password, click on the below URL.\n\nReset my password: {$url}\n\n{$principalContactSignature}','This email is sent to a registered user when they indicate that they have forgotten their password or are unable to login. It provides a URL they can follow to reset their password.'),('PASSWORD_RESET','en_US','Password Reset','Your password has been successfully reset for use with the {$siteTitle} web site. Please retain this username and password, as it is necessary for all work with the journal.\n\nYour username: {$username}\nYour new password: {$password}\n\n{$principalContactSignature}','This email is sent to a registered user when they have successfully reset their password following the process described in the PASSWORD_RESET_CONFIRM email.'),('USER_REGISTER','en_US','Journal Registration','{$userFullName}\n\nYou have now been registered as a user with {$journalName}. We have included your username and password in this email, which are needed for all work with this journal through its website. At any point, you can ask to be removed from the journal\'s list of users by contacting me.\n\nUsername: {$username}\nPassword: {$password}\n\nThank you,\n{$principalContactSignature}','This email is sent to a newly registered user to welcome them to the system and provide them with a record of their username and password.'),('USER_VALIDATE','en_US','Validate Your Account','{$userFullName}\n\nYou have created an account with {$journalName}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:\n\n{$activateUrl}\n\nThank you,\n{$principalContactSignature}','This email is sent to a newly registered user to welcome them to the system and provide them with a record of their username and password.'),('REVIEWER_REGISTER','en_US','Registration as Reviewer with {$journalName}','In light of your expertise, we have taken the liberty of registering your name in the reviewer database for {$journalName}. This does not entail any form of commitment on your part, but simply enables us to approach you with a submission to possibly review. On being invited to review, you will have an opportunity to see the title and abstract of the paper in question, and you\'ll always be in a position to accept or decline the invitation. You can also ask at any point to have your name removed from this reviewer list.\n\nWe are providing you with a username and password, which is used in all interactions with the journal through its website. You may wish, for example, to update your profile, including your reviewing interests.\n\nUsername: {$username}\nPassword: {$password}\n\nThank you,\n{$principalContactSignature}','This email is sent to a newly registered reviewer to welcome them to the system and provide them with a record of their username and password.'),('PUBLISH_NOTIFY','en_US','New Issue Published','Readers:\n\n{$journalName} has just published its latest issue at {$journalUrl}. We invite you to review the Table of Contents here and then visit our web site to review articles and items of interest.\n\nThanks for the continuing interest in our work,\n{$editorialContactSignature}','This email is sent to registered readers via the \"Notify Users\" link in the Editor\'s User Home. It notifies readers of a new issue and invites them to visit the journal at a supplied URL.'),('LOCKSS_EXISTING_ARCHIVE','en_US','Archiving Request for {$journalName}','Dear [University Librarian]\n\n{$journalName} <{$journalUrl}>, is a journal for which a member of your faculty, [name of member], serves as a [title of position]. The journal is seeking to establish a LOCKSS (Lots of Copies Keep Stuff Safe) compliant archive with this and other university libraries.\n\n[Brief description of journal]\n\nThe URL to the LOCKSS Publisher Manifest for our journal is: {$journalUrl}/gateway/lockss\n\nWe understand that you are already participating in LOCKSS. If we can provide any additional metadata for purposes of registering our journal with your version of LOCKSS, we would be happy to provide it.\n\nThank you,\n{$principalContactSignature}','This email requests the keeper of a LOCKSS archive to consider including this journal in their archive. It provides the URL to the journal\'s LOCKSS Publisher Manifest.'),('LOCKSS_NEW_ARCHIVE','en_US','Archiving Request for {$journalName}','Dear [University Librarian]\n\n{$journalName} <{$journalUrl}>, is a journal for which a member of your faculty, [name of member] serves as a [title of position]. The journal is seeking to establish a LOCKSS (Lots of Copies Keep Stuff Safe) compliant archive with this and other university libraries.\n\n[Brief description of journal]\n\nThe LOCKSS Program <http://lockss.org/>, an international library/publisher initiative, is a working example of a distributed preservation and archiving repository, additional details are below. The software, which runs on an ordinary personal computer is free; the system is easily brought on-line; very little ongoing maintenance is required.\n\nTo assist in the archiving of our journal, we invite you to become a member of the LOCKSS community, to help collect and preserve titles produced by your faculty and by other scholars worldwide. To do so, please have someone on your staff visit the LOCKSS site for information on how this system operates. I look forward to hearing from you on the feasibility of providing this archiving support for this journal.\n\nThank you,\n{$principalContactSignature}','This email encourages the recipient to participate in the LOCKSS initiative and include this journal in the archive. It provides information about the LOCKSS initiative and ways to become involved.'),('SUBMISSION_ACK','en_US','Submission Acknowledgement','{$authorName}:\n\nThank you for submitting the manuscript, \"{$articleTitle}\" to {$journalName}. With the online journal management system that we are using, you will be able to track its progress through the editorial process by logging in to the journal web site:\n\nManuscript URL: {$submissionUrl}\nUsername: {$authorUsername}\n\nIf you have any questions, please contact me. Thank you for considering this journal as a venue for your work.\n\n{$editorialContactSignature}','This email, when enabled, is automatically sent to an author when he or she completes the process of submitting a manuscript to the journal. It provides information about tracking the submission through the process and thanks the author for the submission.'),('SUBMISSION_UNSUITABLE','en_US','Unsuitable Submission','{$authorName}:\n\nAn initial review of \"{$articleTitle}\" has made it clear that this submission does not fit within the scope and focus of {$journalName}. I recommend that you consult the description of this journal under About, as well as its current contents, to learn more about the work that we publish. You might also consider submitting this manuscript to another, more suitable journal.\n\n{$editorialContactSignature}',''),('SUBMISSION_COMMENT','en_US','Submission Comment','{$name}:\n\n{$commentName} has added a comment to the submission, \"{$articleTitle}\" in {$journalName}:\n\n{$comments}','This email notifies the various people involved in a submission\'s editing process that a new comment has been posted.'),('SUBMISSION_DECISION_REVIEWERS','en_US','Decision on \"{$articleTitle}\"','As one of the reviewers for the submission, \"{$articleTitle},\" to {$journalName}, I am sending you the reviews and editorial decision sent to the author of this piece. Thank you again for your important contribution to this process.\n \n{$editorialContactSignature}\n\n{$comments}','This email notifies the reviewers of a submission that the review process has been completed. It includes information about the article and the decision reached, and thanks the reviewers for their contributions.'),('EDITOR_ASSIGN','en_US','Editorial Assignment','{$editorialContactName}:\n\nThe submission, \"{$articleTitle},\" to {$journalName} has been assigned to you to see through the editorial process in your role as Section Editor.  \n\nSubmission URL: {$submissionUrl}\nUsername: {$editorUsername}\n\nThank you,\n{$editorialContactSignature}','This email notifies a Section Editor that the Editor has assigned them the task of overseeing a submission through the editing process. It provides information about the submission and how to access the journal site.'),('REVIEW_REQUEST','en_US','Article Review Request','{$reviewerName}:\n\nI believe that you would serve as an excellent reviewer of the manuscript, \"{$articleTitle},\" which has been submitted to {$journalName}. The submission\'s abstract is inserted below, and I hope that you will consider undertaking this important task for us.\n\nPlease log into the journal web site by {$weekLaterDate} to indicate whether you will undertake the review or not, as well as to access the submission and to record your review and recommendation. The web site is {$journalUrl}\n\nThe review itself is due {$reviewDueDate}.\n\nIf you do not have your username and password for the journal\'s web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\n\n\"{$articleTitle}\"\n\n{$abstractTermIfEnabled}\n{$articleAbstract}','This email from the Section Editor to a Reviewer requests that the reviewer accept or decline the task of reviewing a submission. It provides information about the submission such as the title and abstract, a review due date, and how to access the submission itself. This message is used when the Standard Review Process is selected in Journal Setup, Step 2. (Otherwise see REVIEW_REQUEST_ATTACHED.)'),('REVIEW_REQUEST_ONECLICK','en_US','Article Review Request','{$reviewerName}:\n\nI believe that you would serve as an excellent reviewer of the manuscript, \"{$articleTitle},\" which has been submitted to {$journalName}. The submission\'s abstract is inserted below, and I hope that you will consider undertaking this important task for us.\n\nPlease log into the journal web site by {$weekLaterDate} to indicate whether you will undertake the review or not, as well as to access the submission and to record your review and recommendation.\n\nThe review itself is due {$reviewDueDate}.\n\nSubmission URL: {$submissionReviewUrl}\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\n\n\"{$articleTitle}\"\n\n{$abstractTermIfEnabled}\n{$articleAbstract}','This email from the Section Editor to a Reviewer requests that the reviewer accept or decline the task of reviewing a submission. It provides information about the submission such as the title and abstract, a review due date, and how to access the submission itself. This message is used when the Standard Review Process is selected in Journal Setup, Step 2, and one-click reviewer access is enabled.'),('REVIEW_REQUEST_ATTACHED','en_US','Article Review Request','{$reviewerName}:\n\nI believe that you would serve as an excellent reviewer of the manuscript, \"{$articleTitle},\" and I am asking that you consider undertaking this important task for us. The Review Guidelines for this journal are appended below, and the submission is attached to this email. Your review of the submission, along with your recommendation, should be emailed to me by {$reviewDueDate}.\n\nPlease indicate in a return email by {$weekLaterDate} whether you are able and willing to do the review.\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\nReview Guidelines\n\n{$reviewGuidelines}\n','This email is sent by the Section Editor to a Reviewer to request that they accept or decline the task of reviewing a submission. It includes the submission as an attachment. This message is used when the Email-Attachment Review Process is selected in Journal Setup, Step 2. (Otherwise see REVIEW_REQUEST.)'),('REVIEW_CANCEL','en_US','Request for Review Cancelled','{$reviewerName}:\n\nWe have decided at this point to cancel our request for you to review the submission, \"{$articleTitle},\" for {$journalName}. We apologize for any inconvenience this may cause you and hope that we will be able to call on you to assist with this journal\'s review process in the future.\n\nIf you have any questions, please contact me.\n\n{$editorialContactSignature}','This email is sent by the Section Editor to a Reviewer who has a submission review in progress to notify them that the review has been cancelled.'),('REVIEW_CONFIRM','en_US','Able to Review','{$editorialContactName}:\n\nI am able and willing to review the submission, \"{$articleTitle},\" for {$journalName}. Thank you for thinking of me, and I plan to have the review completed by its due date, {$reviewDueDate}, if not before.\n\n{$reviewerName}','This email is sent by a Reviewer to the Section Editor in response to a review request to notify the Section Editor that the review request has been accepted and will be completed by the specified date.'),('REVIEW_DECLINE','en_US','Unable to Review','{$editorialContactName}:\n\nI am afraid that at this time I am unable to review the submission, \"{$articleTitle},\" for {$journalName}. Thank you for thinking of me, and another time feel free to call on me.\n\n{$reviewerName}','This email is sent by a Reviewer to the Section Editor in response to a review request to notify the Section Editor that the review request has been declined.'),('REVIEW_COMPLETE','en_US','Article Review Completed','{$editorialContactName}:\n\nI have now completed my review of \"{$articleTitle}\" for {$journalName}, and submitted my recommendation, \"{$recommendation}.\"\n\n{$reviewerName}','This email is sent by a Reviewer to the Section Editor to notify them that a review has been completed and the comments and recommendations have been recorded on the journal web site.'),('REVIEW_ACK','en_US','Article Review Acknowledgement','{$reviewerName}:\n\nThank you for completing the review of the submission, \"{$articleTitle},\" for {$journalName}. We appreciate your contribution to the quality of the work that we publish.\n\n{$editorialContactSignature}','This email is sent by a Section Editor to confirm receipt of a completed review and thank the reviewer for their contributions.'),('REVIEW_REMIND','en_US','Submission Review Reminder','{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, \"{$articleTitle},\" for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\n\nIf you do not have your username and password for the journal\'s web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}','This email is sent by a Section Editor to remind a reviewer that their review is due.'),('REVIEW_REMIND_ONECLICK','en_US','Submission Review Reminder','{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, \"{$articleTitle},\" for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}','This email is sent by a Section Editor to remind a reviewer that their review is due.'),('REVIEW_REMIND_AUTO','en_US','Automated Submission Review Reminder','{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, \"{$articleTitle},\" for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and this email has been automatically generated and sent with the passing of that date. We would still be pleased to receive it as soon as you are able to prepare it.\n\nIf you do not have your username and password for the journal\'s web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}','This email is automatically sent when a reviewer\'s due date elapses (see Review Options under Journal Setup, Step 2) and one-click reviewer access is disabled. Scheduled tasks must be enabled and configured (see the site configuration file).'),('REVIEW_REMIND_AUTO_ONECLICK','en_US','Automated Submission Review Reminder','{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, \"{$articleTitle},\" for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and this email has been automatically generated and sent with the passing of that date. We would still be pleased to receive it as soon as you are able to prepare it.\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}','This email is automatically sent when a reviewer\'s due date elapses (see Review Options under Journal Setup, Step 2) and one-click reviewer access is enabled. Scheduled tasks must be enabled and configured (see the site configuration file).'),('EDITOR_DECISION_ACCEPT','en_US','Editor Decision','{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, \"{$articleTitle}\".\n\nOur decision is to:\n\n{$editorialContactSignature}\n','This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),('EDITOR_DECISION_REVISIONS','en_US','Editor Decision','{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, \"{$articleTitle}\".\n\nOur decision is to:\n\n{$editorialContactSignature}\n','This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),('EDITOR_DECISION_RESUBMIT','en_US','Editor Decision','{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, \"{$articleTitle}\".\n\nOur decision is to:\n\n{$editorialContactSignature}\n','This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),('EDITOR_DECISION_DECLINE','en_US','Editor Decision','{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, \"{$articleTitle}\".\n\nOur decision is to:\n\n{$editorialContactSignature}\n','This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),('COPYEDIT_REQUEST','en_US','Copyediting Request','{$copyeditorName}:\n\nI would ask that you undertake the copyediting of \"{$articleTitle}\" for {$journalName} by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 1.\n3. Consult Copyediting Instructions posted on webpage.\n4. Open the downloaded file and copyedit, while adding Author Queries as needed. \n5. Save copyedited file, and upload to Step 1 of Copyediting.\n6. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$copyeditorUsername}\n\n{$editorialContactSignature}','This email is sent by a Section Editor to a submission\'s Copyeditor to request that they begin the copyediting process. It provides information about the submission and how to access it.'),('COPYEDIT_COMPLETE','en_US','Copyediting Completed','{$editorialContactName}:\n\nWe have now copyedited your submission \"{$articleTitle}\" for {$journalName}. To review the proposed changes and respond to Author Queries, please follow these steps:\n\n1. Log into the journal using URL below with your username and password (use Forgot link if needed).\n2. Click on the file at 1. Initial Copyedit File to download and open copyedited version. \n3. Review the copyediting, making changes using Track Changes in Word, and answer queries. \n4. Save file to desktop and upload it in 2. Author Copyedit.\n5. Click the email icon under COMPLETE and send email to the editor.\n\nThis is the last opportunity that you have to make substantial changes. You will be asked at a later stage to proofread the galleys, but at that point only minor typographical and layout errors can be corrected.\n\nManuscript URL: {$submissionEditingUrl}\nUsername: {$authorUsername}\n\nIf you are unable to undertake this work at this time or have any questions,\nplease contact me. Thank you for your contribution to this journal.\n\n{$copyeditorName}',''),('COPYEDIT_ACK','en_US','Copyediting Acknowledgement','{$copyeditorName}:\n\nThank you for copyediting the manuscript, \"{$articleTitle},\" for {$journalName}. It will make an important contribution to the quality of this journal.\n\n{$editorialContactSignature}','This email is sent by the Section Editor to a submission\'s Copyeditor to acknowledge that the Copyeditor has successfully completed the copyediting process and thank them for their contribution.'),('COPYEDIT_AUTHOR_REQUEST','en_US','Copyediting Review Request','{$authorName}:\n\nYour submission \"{$articleTitle}\" for {$journalName} has been through the first step of copyediting, and is available for you to review by following these steps.\n\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 1.\n3. Open the downloaded submission.\n4. Review the text, including copyediting proposals and Author Queries.\n5. Make any copyediting changes that would further improve the text.\n6. When completed, upload the file in Step 2.\n7. Click on METADATA to check indexing information for completeness and accuracy.\n8. Send the COMPLETE email to the editor and copyeditor.\n\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$authorUsername}\n\nThis is the last opportunity to make substantial copyediting changes to the submission. The proofreading stage, that follows the preparation of the galleys, is restricted to correcting typographical and layout errors.\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}','This email is sent by the Section Editor to a submission\'s Author to request that they proofread the work of the copyeditor. It provides access information for the manuscript and warns that this is the last opportunity the author has to make substantial changes.'),('COPYEDIT_AUTHOR_COMPLETE','en_US','Copyediting Review Completed','{$editorialContactName}:\n\nI have now reviewed the copyediting of the manuscript, \"{$articleTitle},\" for {$journalName}, and it is ready for the final round of copyediting and preparation for Layout.\n\nThank you for this contribution to my work,\n{$authorName}','This email is sent by the Author to the Section Editor to notify them that the Author\'s copyediting process has been completed.'),('COPYEDIT_AUTHOR_ACK','en_US','Copyediting Review Acknowledgement','{$authorName}:\n\nThank you for reviewing the copyediting of your manuscript, \"{$articleTitle},\" for {$journalName}. We look forward to publishing this work.\n\n{$editorialContactSignature}','This email is sent by the Section Editor to a submission\'s Author to confirm completion of the Author\'s copyediting process and thank them for their contribution.'),('COPYEDIT_FINAL_REQUEST','en_US','Copyediting Final Review','{$copyeditorName}:\n\nThe author and editor have now completed their copyediting review of \"{$articleTitle}\" for {$journalName}. A \"clean copy\" now needs to be prepared for Layout by going through the following steps.\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 2.\n3. Open the downloaded file and incorporate all copyedits and query responses.\n4. Save clean file, and upload to Step 3 of Copyediting.\n5. Click on METADATA to check indexing information (saving any corrections).\n6. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$copyeditorUsername}\n\n{$editorialContactSignature}','This email from the Section Editor to the Copyeditor requests that they perform a final round of copyediting on a submission before it enters the layout process.'),('COPYEDIT_FINAL_COMPLETE','en_US','Copyediting Final Review Completed','{$editorialContactName}:\n\nI have now prepared a clean, copyedited version of the manuscript, \"{$articleTitle},\" for {$journalName}. It is ready for Layout and the preparation of the galleys.\n\n{$copyeditorName}','This email from the Copyeditor to the Section Editor notifies them that the final round of copyediting has been completed and that the layout process may now begin.'),('COPYEDIT_FINAL_ACK','en_US','Copyediting Final Review Acknowledgement','{$copyeditorName}:\n\nThank you for completing the copyediting of the manuscript, \"{$articleTitle},\" for {$journalName}. This preparation of a \"clean copy\" for Layout is an important step in the editorial process.\n\n{$editorialContactSignature}','This email from the Section Editor to the Copyeditor acknowledges completion of the final round of copyediting and thanks them for their contribution.'),('LAYOUT_REQUEST','en_US','Request Galleys','{$layoutEditorName}:\n\nThe submission \"{$articleTitle}\" to {$journalName} now needs galleys laid out by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and use the Layout Version file to create the galleys according to the journal\'s standards.\n3. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionLayoutUrl}\nUsername: {$layoutEditorUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}','This email from the Section Editor to the Layout Editor notifies them that they have been assigned the task of performing layout editing on a submission. It provides information about the submission and how to access it.'),('LAYOUT_COMPLETE','en_US','Galleys Complete','{$editorialContactName}:\n\nGalleys have now been prepared for the manuscript, \"{$articleTitle},\" for {$journalName} and are ready for proofreading. \n\nIf you have any questions, please contact me.\n\n{$layoutEditorName}','This email from the Layout Editor to the Section Editor notifies them that the layout process has been completed.'),('LAYOUT_ACK','en_US','Layout Acknowledgement','{$layoutEditorName}:\n\nThank you for preparing the galleys for the manuscript, \"{$articleTitle},\" for {$journalName}. This is an important contribution to the publishing process.\n\n{$editorialContactSignature}','This email from the Section Editor to the Layout Editor acknowledges completion of the layout editing process and thanks the layout editor for their contribution.'),('PROOFREAD_AUTHOR_REQUEST','en_US','Proofreading Request (Author)','{$authorName}:\n\nYour submission \"{$articleTitle}\" to {$journalName} now needs to be proofread by folllowing these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and view PROOFING INSTRUCTIONS\n3. Click on VIEW PROOF in Layout and proof the galley in the one or more formats used.\n4. Enter corrections (typographical and format) in Proofreading Corrections.\n5. Save and email corrections to Layout Editor and Proofreader.\n6. Send the COMPLETE email to the editor.\n\nSubmission URL: {$submissionUrl}\nUsername: {$authorUsername}\n\n{$editorialContactSignature}','This email from the Section Editor to the Author notifies them that an article\'s galleys are ready for proofreading. It provides information about the article and how to access it.'),('PROOFREAD_AUTHOR_COMPLETE','en_US','Proofreading Completed (Author)','{$editorialContactName}:\n\nI have completed proofreading the galleys for my manuscript, \"{$articleTitle},\" for {$journalName}. The galleys are now ready to have any final corrections made by the Proofreader and Layout Editor.\n\n{$authorName}','This email from the Author to the Proofreader and Editor notifies them that the Author\'s round of proofreading is complete and that details can be found in the article comments.'),('PROOFREAD_AUTHOR_ACK','en_US','Proofreading Acknowledgement (Author)','{$authorName}:\n\nThank you for proofreading the galleys for your manuscript, \"{$articleTitle},\" in {$journalName}. We are looking forward to publishing your work shortly.\n\nIf you subscribe to our notification service, you will receive an email of the Table of Contents as soon as it is published. If you have any questions, please contact me.\n\n{$editorialContactSignature}','This email from the Section Editor to the Author acknowledges completion of the initial proofreading process and thanks them for their contribution.'),('PROOFREAD_REQUEST','en_US','Proofreading Request','{$proofreaderName}:\n\nThe submission \"{$articleTitle}\" to {$journalName} now needs to be proofread by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and view PROOFING INSTRUCTIONS.\n3. Click on VIEW PROOF in Layout and proof the galley in the one or more formats used.\n4. Enter corrections (typographical and format) in Proofreading Corrections.\n5. Save and email corrections to Layout Editor.\n6. Send the COMPLETE email to the editor.\n\nManuscript URL: {$submissionUrl}\nUsername: {$proofreaderUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}','This email from the Section Editor to the Proofreader requests that they perform proofreading of an article\'s galleys. It provides information about the article and how to access it.'),('PROOFREAD_COMPLETE','en_US','Proofreading Completed','{$editorialContactName}:\n\nI have completed proofreading the galleys for the manuscript, \"{$articleTitle},\" for {$journalName}. The galleys are now ready to have any final corrections made by the Layout Editor.\n\n{$proofreaderName}','This email from the Proofreader to the Section Editor notifies them that the Proofreader has completed the proofreading process.'),('PROOFREAD_ACK','en_US','Proofreading Acknowledgement','{$proofreaderName}:\n\nThank you for proofreading the galleys for the manuscript, \"{$articleTitle},\" for {$journalName}. This work makes an important contribution to the quality of this journal.\n\n{$editorialContactSignature}','This email from the Section Editor to the Proofreader confirms completion of the proofreader\'s proofreading process and thanks them for their contribution.'),('PROOFREAD_LAYOUT_REQUEST','en_US','Proofreading Request (Layout Editor)','{$layoutEditorName}:\n\nThe submission \"{$articleTitle}\" to {$journalName} has been proofread by the author and proofreader, and any corrections should now be made by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal consult Proofreading Corrections to create corrected galleys.\n3. Upload the revised galleys.\n4. Send the COMPLETE email in Proofreading Step 3 to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubnmission URL: {$submissionUrl}\nUsername: {$layoutEditorUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}','This email from the Section Editor to the Layout Editor notifies them that an article\'s galleys are ready for final proofreading. It provides information on the article and how to access it.'),('PROOFREAD_LAYOUT_COMPLETE','en_US','Proofreading Completed (Layout Editor)','{$editorialContactName}:\n\nThe galleys have now been corrected, following their proofreading, for the manuscript, \"{$articleTitle},\" for {$journalName}. This piece is now ready to publish.\n\n{$layoutEditorName}','This email from the Layout Editor to the Section Editor notifies them that the final stage of proofreading has been completed and the article is now ready to publish.'),('PROOFREAD_LAYOUT_ACK','en_US','Proofreading Acknowledgement (Layout Editor)','{$layoutEditorName}:\n\nThank you for completing the proofreading corrections for the galleys associated with the manuscript, \"{$articleTitle},\" for {$journalName}. This represents an important contribution to the work of this journal.\n\n{$editorialContactSignature}','This email from the Section Editor to the Layout Editor acknowledges completion of the final stage of proofreading and thanks them for their contribution.'),('EMAIL_LINK','en_US','Article of Possible Interest','Thought you might be interested in seeing \"{$articleTitle}\" by {$authorName} published in Vol {$volume}, No {$number} ({$year}) of {$journalName} at \"{$articleUrl}\".','This email template provides a registered reader with the opportunity to send information about an article to somebody who may be interested. It is available via the Reading Tools and must be enabled by the Journal Manager in the Reading Tools Administration page.'),('SUBSCRIPTION_NOTIFY','en_US','Subscription Notification','{$subscriberName}:\n\nYou have now been registered as a subscriber in our online journal management system for {$journalName}, with the following subscription:\n\n{$subscriptionType}\n\nTo access content that is available only to subscribers, simply log in to the system with your username, \"{$username}\".\n\nOnce you have logged in to the system you can change your profile details and password at any point.\n\nPlease note that if you have an institutional subscription, there is no need for users at your institution to log in, since requests for subscription content will be automatically authenticated by the system.\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}','This email notifies a registered reader that the Manager has created a subscription for them. It provides the journal\'s URL along with instructions for access.'),('OPEN_ACCESS_NOTIFY','en_US','Issue Now Open Access','Readers:\n\n{$journalName} has just made available in an open access format the following issue. We invite you to review the Table of Contents here and then visit our web site ({$journalUrl}) to review articles and items of interest.\n\nThanks for the continuing interest in our work,\n{$editorialContactSignature}','This email is sent to registered readers who have requested to receive a notification email when an issue becomes open access.'),('SUBSCRIPTION_BEFORE_EXPIRY','en_US','Notice of Subscription Expiry','{$subscriberName}:\n\nYour {$journalName} subscription is about to expire.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo ensure the continuity of your access to this journal, please go to the journal website and renew your subscription. You are able to log in to the system with your username, \"{$username}\".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}','This email notifies a subscriber that their subscription will soon expire. It provides the journal\'s URL along with instructions for access.'),('SUBSCRIPTION_AFTER_EXPIRY','en_US','Subscription Expired','{$subscriberName}:\n\nYour {$journalName} subscription has expired.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, \"{$username}\".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}','This email notifies a subscriber that their subscription has expired. It provides the journal\'s URL along with instructions for access.'),('SUBSCRIPTION_AFTER_EXPIRY_LAST','en_US','Subscription Expired - Final Reminder','{$subscriberName}:\n\nYour {$journalName} subscription has expired.\nPlease note that this is the final reminder that will be emailed to you.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, \"{$username}\".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}','This email notifies a subscriber that their subscription has expired. It provides the journal\'s URL along with instructions for access.'),('SUBSCRIPTION_PURCHASE_INDL','en_US','Subscription Purchase: Individual','An individual subscription has been purchased online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nUser:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n','This email notifies the Subscription Manager that an individual subscription has been purchased online. It provides summary information about the subscription and a quick access link to the purchased subscription.'),('SUBSCRIPTION_PURCHASE_INSTL','en_US','Subscription Purchase: Institutional','An institutional subscription has been purchased online for {$journalName} with the following details. To activate this subscription, please use the provided Subscription URL and set the subscription status to \'Active\'.\n\nSubscription Type:\n{$subscriptionType}\n\nInstitution:\n{$institutionName}\n{$institutionMailingAddress}\n\nDomain (if provided):\n{$domain}\n\nIP Ranges (if provided):\n{$ipRanges}\n\nContact Person:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n','This email notifies the Subscription Manager that an institutional subscription has been purchased online. It provides summary information about the subscription and a quick access link to the purchased subscription.'),('SUBSCRIPTION_RENEW_INDL','en_US','Subscription Renewal: Individual','An individual subscription has been renewed online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nUser:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n','This email notifies the Subscription Manager that an individual subscription has been renewed online. It provides summary information about the subscription and a quick access link to the renewed subscription.'),('SUBSCRIPTION_RENEW_INSTL','en_US','Subscription Renewal: Institutional','An institutional subscription has been renewed online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nInstitution:\n{$institutionName}\n{$institutionMailingAddress}\n\nDomain (if provided):\n{$domain}\n\nIP Ranges (if provided):\n{$ipRanges}\n\nContact Person:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n','This email notifies the Subscription Manager that an institutional subscription has been renewed online. It provides summary information about the subscription and a quick access link to the renewed subscription.'),('CITATION_EDITOR_AUTHOR_QUERY','en_US','Citation Editing','{$authorFirstName},\n\nCould you please verify or provide us with the proper citation for the following reference from your article, {$articleTitle}:\n\n{$rawCitation}\n\nThanks!\n\n{$userFirstName}\nCopy-Editor, {$journalName}\n','This email allows copyeditors to request additional information about references from authors.'),('PASSWORD_RESET_CONFIRM','es_ES','Confirmación de cambio de contraseña','Hemos recibido una petición para cambiar su contraseña en {$siteTitle}.\n\nSi no hizo usted esta petición ignore este correo-e y su contraseña no cambiará. Si desea cambiar su contraseña pinche en el enlace que le mostramos a continuación.\n\nCambiar mi contraseña: {$url}\n\n{$principalContactSignature}','Este correo se envía a un/a usuario/a registrado/a cuando indican que han olvidado su contraseña o que no se pueden identificar. Proporciona una URL para que cambien su contraseña.'),('PASSWORD_RESET','es_ES','Cambio de contraseña','Su contraseña en {$siteTitle} se ha cambiado sin problema. Por favor, guarde en lugar seguro su nombre de usuaria/o y contraseña, ya que son necesarios para trabajar con la revista.\n\nNombre de usuaria/o: {$username}\nNueva contraseña: {$password}\n\n{$principalContactSignature}','Este correo se envía a un/a usuario/a registrado/a una vez han cambiado su contraseña siguiendo el procedimiento descrito en el correo-e PASSWORD_RESET_CONFIRM.'),('USER_REGISTER','es_ES','Nuevo registro de usuaria/o','Gracias por registrarse como usuaria/o en {$journalName}. Por favor, guarde en lugar seguro su nombre de usuaria/o y contraseña, ya que son necesarios para trabajar con la revista.\n\nNombre de usuario/a: {$username}\nContraseña: {$password}\n\nGracias,\n{$principalContactSignature}','Este correo se envía a un/a usuario/a que se acaba de registrar para darle la bienvenida al sistema y proporcionarle sus datos de acceso.'),('PUBLISH_NOTIFY','es_ES','Nuevo número publicado','Estimados/as lectores/as:\n\n{$journalName} acaba de publicar su último número en {$journalUrl}. A continuación le mostramos la tabla de contenidos, después puede visitar nuestro sitio web para consultar los artículos que sean de su interés.\n\nGracias por mantener el interés en nuestro trabajo,\n{$editorialContactSignature}','Este correo se envía a lectores/as registrados/as a través del enlace \"Notificar a usuarios/as\" en la home de editores/as. Notifica a los/as lectores/as de la aparición de un nuevo número y les invita a visitar la revista en la URL proporcionada.'),('SUBSCRIPTION_NOTIFY','es_ES','Notificación de suscripción','{$subscriberName}:\n\nAcaba de registrarse como suscriptor/a en nuestro sistema de gestión de revistas online para la revista {$journalName}, a continuación le mostramos los datos de su suscripción:\n\n{$subscriptionType}\n\nPara acceder al contenido exclusivo para suscriptores/as, simplemente tiene que identificarse con su nombre de usuaria/o, \"{$username}\".\n\nUna vez se haya identificado en el sistema puede cambiar los detalles de su perfil y su contraseña en cualquier momento.\n\nTenga en cuenta que si se trata de una suscripción institucional no es necesario que los/as usuarios/as de su institución se identifiquen, ya que las peticiones de contenido bajo suscripción serán autentificadas automáticamente por el sistema.\n\nSi tiene cualquier pregunta no dude en contactar con nosotros/as.\n\n{$subscriptionContactSignature}','Este correo notifica a un/a lector/a registrado/a que el/la Gestor/a les ha creado una suscripción. Proporciona la URL de la revista junto con instrucciones para acceder a ella.'),('OPEN_ACCESS_NOTIFY','es_ES','Ahora el Número es Acceso Libre','Lectores:\n\n	{$journalName} acaba de hacer disponible de forma acceso libre el siguiente número. Los invitamos a revisar la Tabla de Contenido aquí y después visite nuestra página Web  ({$journalUrl}) para consultar los artículos que sean de su interés.\n	\n	Gracias por mantener el interés en nuestro trabajo,\n	{$editorialContactSignature}','Este correo se envía a los lectores registrados que han pedido recibir notificaciones por email cuando un Número se cambia a Acceso Libre.'),('SUBSCRIPTION_BEFORE_EXPIRY','es_ES','Notificación de Expiración de Subscripción','{$subscriberName}:\n\n	Su subscripción a {$journalName} está a punto de expirar.\n\n	{$subscriptionType}\n	Fecha de Expiro: {$expiryDate}\n\n	Para asegurarse de que continúe a tener acceso a esta revista, por favor vaya a la pagina web de la revista y renueve su subscripción.  Puede usted entrar al sistema con su nombre de usuario, \"{$username}\".\n\n	Si tiene alguna pregunta, por favor no tema en contactarme.\n\n	{$subscriptionContactSignature}','Este correo notifica a un subscripto que su subscripción va a expirar pronto.  Les provee con el URL de la revista e instrucciones para accederla.'),('SUBSCRIPTION_AFTER_EXPIRY','es_ES','Subscripción Expirada','{$subscriberName}:\n\n	Su subscripción a {$journalName} ha expirado.\n\n	{$subscriptionType}\n	Fecha de Expiro: {$expiryDate}\n\n	Para renovar su subscripción, por favor vaya a la pagina web de la revista.  Puede usted entrar al sistema con su nombre de usuario, \"{$username}\".\n\n	If you have any questions, please feel free to contact me.\n\n	{$subscriptionContactSignature}','Este correo notifica a un subscripto que su subscripción ha expirado.  Les provee con el URL de la revista e instrucciones para accederla.'),('SUBSCRIPTION_AFTER_EXPIRY_LAST','es_ES','Subscripción Expirada - Último Recuerdo','{$subscriberName}:\n\n	Su subscripción a {$journalName} ha expirado.\n	Por favor note que este es el ultimo correo que recibirá para recordarle.\n\n	{$subscriptionType}\n	Fecha de Expiro: {$expiryDate}\n\n	Para renovar su subscripción, por favor vaya a la pagina web de la revista.  Puede usted entrar al sistema con su nombre de usuario, \"{$username}\".\n\n	If you have any questions, please feel free to contact me.\n\n	{$subscriptionContactSignature}','Este correo notifica a un subscripto que su subscripción ha expirado.  Les provee con el URL de la revista e instrucciones para accederla.'),('LOCKSS_EXISTING_ARCHIVE','es_ES','Petición de Archivado para {$journalName}','Estimado/a [Bibliotecaria/o Universitaria/o]\n\n{$journalName} <{$journalUrl}>, es una revista en la que un miembro de su Facultad/Universidad, [nombre de la persona], colabora como [cargo que desempeña]. La revista está intentando crear un archivo LOCKSS (Lots of Copies Keep Stuff Safe) con esta y otras bibliotecas universitarias.\n\n[Breve descripción de la revista]\n\nLa URL para el Manifiesto Editorial LOCKSS para nuestra revista es: {$journalUrl}/gateway/lockss\n\nEntendemos que ya está participando en LOCKSS. Si podemos proporcionarle metadatos adicionales para registrar nuestra revista con su versión de LOCKSS, estaremos encantados/as de hacerlo.\n\nGracias,\n{$principalContactSignature}','Este correo solicita al / a la administrador/a de un archivo LOCKSS que tenga en cuenta esta revista para incluirla en su archivo. Proporciona la URL del Manifiesto Editorial LOCKSS de la revista.'),('LOCKSS_NEW_ARCHIVE','es_ES','Petición de archivo para {$journalName}','Estimado/a [Bibliotecario/a Universitario/a]\n\n{$journalName} <{$journalUrl}>, es una revista en la que un miembro de su Facultad/Universidad, [nombre de la persona], colabora como [cargo que desempeña]. La revista está intentando crear un archivo LOCKSS (Lots of Copies Keep Stuff Safe) con esta y otras bibliotecas universitarias.\n\n[Breve descripción de la revista]\n\nEl programa LOCKSS <http://lockss.org/>, una iniciativa internacional de bibliotecas y editoriales, es un ejemplo vivo de un repositorio de preservación y archivo distribuido, a continuación le mostramos más detalles. El software, que funciona en ordenadores personales normales es gratuito; el sistema se conecta fácilmente; necesitando muy poco mantenimiento.\n\nPara contribuir al archivado de nuestra revista, le invitamos a convertirse en miembro de la comunidad LOCKSS, y así ayudar a recopilar y preservar títulos producidos en nuestra facultad y por otras entidades académicas de todo el mundo. Para hacerlo le rogamos que alguna persona de su biblioteca visite el sitio de LOCKSS para saber cómo funciona este sistema. Espero recibir pronto noticias suyas en el sentido de que proporcionará el apoyo para poder archivar esta revista.\n\nGracias,\n{$principalContactSignature}','Este correo solicita al / a la destinatario/a participar en la iniciativa LOCKSS e incluir esta revista en el archivo. Le proporciona información sobre la iniciativa LOCKSS y cómo participar.'),('SUBMISSION_ACK','es_ES','Envío recibido','{$authorName}:\n\nGracias por enviarnos su manuscrito \"{$articleTitle}\" a {$journalName}. Gracias al sistema de gestión de revistas online que usamos podrá seguir su progreso a través del proceso editorial identificándose en el sitio web de la revista:\n\nURL del manuscrito: {$submissionUrl}\nNombre de usuaria/o: {$authorUsername}\n\nSi tiene cualquier pregunta no dude en contactar con nosotros/as. Gracias por tener en cuenta esta revista para difundir su trabajo.\n\n{$editorialContactSignature}','Este correo, cuando está activado, se envía automáticamente a un/a autor/a when cuando completa el proceso de envío de un manuscrito a la revista. Proporciona información para hacer el seguimiento del envío a través del proceso y agradece la contribución.'),('SUBMISSION_UNSUITABLE','es_ES','Envío rechazado','{$authorName}:\n\nTras una revisión inicial de \"{$articleTitle}\" se ha decidido que este envío no entra dentro del ámbito de {$journalName}. Le recomiendo que consulte la descripción de esta revista en Acerca de, así como los artículos publicados, para conocer el tipo de trabajos que publicamos. También puede considerar enviar este manuscrito a otra revista más adecuada.\n\n{$editorialContactSignature}',''),('SUBMISSION_COMMENT','es_ES','Comentario a envío','{$name}:\n\n{$commentName} ha añadido un comentario a su envío, \"{$articleTitle}\" en {$journalName}:\n\n{$comments}','Este correo notifica a las diferentes personas relacionadas con el proceso de edición de un envío de que se ha enviado un nuevo comentario.'),('SUBMISSION_DECISION_REVIEWERS','es_ES','Decisión sobre\"{$articleTitle}\"','Como uno/a de los/as revisores/as de su envío, \"{$articleTitle},\" a {$journalName}, le envío las revisiones y la decisión editorial enviadas al / a la autor/a de este trabajo. Gracias una vez más por su importante contribución a este proceso.\n \n{$editorialContactSignature}\n\n{$comments}','Este correo notifica a los/as revisores/as de un envío de que el proceso de revisión ha finalizado. Incluye información sobre el artículo y la decisión tomada, y agradece a los/as revisores/as su contribución.'),('EDITOR_ASSIGN','es_ES','Asignación editorial','{$editorialContactName}:\n\nSe le ha asignado el envío, \"{$articleTitle},\" a {$journalName} para que lo revise en el proceso editorial como Editor/a de Sección.\n\nURL del envío: {$submissionUrl}\nUsuario/a: {$editorUsername}\n\nGracias,\n{$editorialContactSignature}','Este correo notifica al / a la Editor/a de Sección de que les ha asignado la tarea de supervisar un envío a través del proceso editorial. Proporciona información sobre el envío y cómo acceder a la revista.'),('REVIEW_REQUEST','es_ES','Solicitud de revisión de artículo','{$reviewerName}:\n\nTengo el convencimiento de que sería un/a excelente revisor/a del manuscrito, \"{$articleTitle},\" que ha sido enviado a {$journalName}. A continuación encontrará un extracto del envío, con la esperanza de que aceptará llevar a cabo esta importante tarea para nosotros.\n\nPor favor, identifíquese en la revista antes de {$weekLaterDate} para decirnos si hará o no la revisión, así como para tener acceso al envío y para registrar su revisión y recomendación. La dirección es {$journalUrl}\n\nLa revisión propiamente dicha debe estar lista para el {$reviewDueDate}.\n\nSi ha perdido su nombre de usuaria/o y contraseña puede pinchar en el siguiente enlace para cambiar su contraseña (le llegará por correo-e junto con su nombre de usuaria/o). {$passwordResetUrl}\n\nURL del envío: {$submissionReviewUrl}\n\nGracias por tener en cuenta nuestra solicitud.\n\n{$editorialContactSignature}\n\n\n\n\"{$articleTitle}\"\n\nResumen\n{$articleAbstract}','Este correo del / de la Editor/a de Sección a un/a revisor/a le solicita que acepte o rechace la revisión de un envío. Proporciona información sobre el envío como el título y el resumen, el plazo de revisión, y cómo acceder al envío propiamente dicho. Este mensaje se usa cuando se selecciona el Proceso de Envío Estándar en la configuración de la revista, paso 2. (En caso de haber seleccionado otra opción, REVIEW_REQUEST_ATTACHED.)'),('REVIEW_REQUEST_ONECLICK','es_ES','Petición de Revisión de Artículo','{$reviewerName}:\n				\nTengo el convencimiento de que sería un/a excelente revisor/a del manuscrito, \"{$articleTitle},\" que ha sido enviado a {$journalName}. A continuación encontrará un extracto del envío, con la esperanza de que aceptará llevar a cabo esta importante tarea para nosotros.\n\nPor favor, identifíquese en la revista antes de {$weekLaterDate} para decirnos si hará o no la revisión, así como para tener acceso al envío y para registrar su revisión y recomendación. La dirección es {$journalUrl}\n\nLa revisión propiamente dicha debe estar lista para el {$reviewDueDate}.\n\nSi ha perdido su nombre de usuaria/o y contraseña puede pinchar en el siguiente enlace para cambiar su contraseña (le llegará por correo-e junto con su nombre de usuaria/o). {$passwordResetUrl}\n\nURL del envío: {$submissionReviewUrl}\n\nGracias por tener en cuenta nuestra solicitud.\n\n{$editorialContactSignature}\n\n\n\n\"{$articleTitle}\"\n\nResumen\n{$articleAbstract}','Este correo del / de la Editor/a de Sección a un/a revisor/a le solicita que acepte o rechace la revisión de un envío. Proporciona información sobre el envío como el título y el resumen, el plazo de revisión, y cómo acceder al envío propiamente dicho. Este mensaje se usa cuando se selecciona el Proceso de Envío Estándar en la configuración de la revista, paso 2, y está activado el acceso a la revisión en un click.'),('REVIEW_REQUEST_ATTACHED','es_ES','Petición de revisión de artículo','{$reviewerName}:\n\nTengo el convencimiento de que sería un/a excelente revisor/a del manuscrito, \"{$articleTitle},\" que ha sido enviado a {$journalName}. A continuación encontrará un extracto del envío, con la esperanza de que aceptará llevar a cabo esta importante tarea para nosotros. A continuación le mostramos las Normas de Revisión de esta revista y adjunto a este correo-e recibirá el envío. Debería enviarme por correo-e su revisión del envío, así como su recomendación antes del {$reviewDueDate}.\n\nLe ruego me conteste a este correo-e antes del {$weekLaterDate} y me comunique si puede y quiere hacer la revisión.\n\nGracias por tener en cuenta esta solicitud.\n\n{$editorialContactSignature}\n\n\nNormas de Revisión\n\n{$reviewGuidelines}\n','Este correo del / de la Editor/a de Sección a un/a revisor/a le solicita que acepte o rechace la revisión de un envío. Contiene el envío propiamente dicho como adjunto. Este correo se usa cuando es seleccionado Proceso de Revisión mediante Adjuntos en Correo-e en la configuración de la revista, paso 2.'),('REVIEW_CANCEL','es_ES','Petición de revisión cancelada','{$reviewerName}:\n\nHemos decidido cancelar nuestra petición para que revisara el envío \"{$articleTitle},\" para {$journalName}. Lamentamos las molestias que hayamos podido causarle y esperamos poder volver a contactar con usted en el futuro para que nos ayude en el proceso de revisión.\n\nSi tiene cualquier pregunta, no dude en contactar con nosotros/as.\n\n{$editorialContactSignature}','Este correo del / de la Editor/a de Sección a un/a Revisor/a que tiene la revisión de un envío en progreso para notificarles que la revisión se ha cancelado.'),('REVIEW_CONFIRM','es_ES','Acepto la revisión','{$editorialContactName}:\n\nTengo la capacidad y deseo revisar el envío, \"{$articleTitle},\" para {$journalName}. Gracias por acordarse de mi, es mi intención tener la revisión completa en el plazo indicado: {$reviewDueDate}, a ser posible antes.\n\n{$reviewerName}','Este correo es enviado por un/a revisor/a al / a la Editor/a de Sección en respuesta a una petición de revisión para notificarle que ha aceptado la petición y que será completada antes de la fecha especificada.'),('REVIEW_DECLINE','es_ES','Rechazo la revisión','{$editorialContactName}:\n\nMe temo que en este momento no voy a poder revisar el envío \"{$articleTitle},\" para {$journalName}. Gracias por pensar en mi, espero que vuelvan a contar conmigo en futuras ocasiones.\n\n{$reviewerName}','Este correo es enviado por un/a revisor/a al / a la Editor/a de Sección en respuesta a una petición de revisión para notificarle que rechaza la petición de revisión.'),('REVIEW_COMPLETE','es_ES','Revisión de artículo completada','{$editorialContactName}:\n\nYa he finalizado la revisión del envío \"{$articleTitle},\" para {$journalName}. En el sitio web he registrado mis comentarios y recomendación. Me alegro de poder colaborar con la revista, si tienen cualquier pregunta no duden en ponerse en contacto conmigo.\n\n{$reviewerName}','Este correo enviado por un/a revisor/a al / al a Editor/a de Sección para notificarle que a ha finalizado una revisión y se han registrado los comentarios y recomendaciones en el sitio de la revista.'),('REVIEW_ACK','es_ES','Acuse de recibo de revisión de artículo','{$reviewerName}:\n\nGracias por completar la revisión del envío \"{$articleTitle},\" para {$journalName}. Apreciamos su contribución a la calidad de los trabajos que publicamos.\n\n{$editorialContactSignature}','Este correo enviado por el/la Editor/a de Sección para confirmar la recepción de una revisión completada y agradecer al / a la revisor/a su contribución.'),('REVIEW_REMIND','es_ES','Recordatorio de envío de revisión','{$reviewerName}:\n\nLe recordamos nuestra petición de revisión del envío \"{$articleTitle},\" para {$journalName}. Esperábamos su revisión antes del {$reviewDueDate}, esperamos nos la mande en cuanto la tenga lista.\n\nSi ha perdido su nombre de usuaria/o y contraseña para la revista puede pinchar en el siguiente enlace para cambiar su contraseña (se la enviaremos por correo-e junto con su nombre de usuaria/o). {$passwordResetUrl}\n\nURL del envío: {$submissionReviewUrl}\n\nLe rogamos nos confirme su disponibilidad para completar esta contribución vital para el trabajo de la revista. Esperamos tener noticias suyas a la mayor brevedad.\n\n{$editorialContactSignature}','Este correo es enviado por el/la Editor/a de Sección para recordar a un/a revisor/a que ya debe entregar su revisión.'),('REVIEW_REMIND_ONECLICK','es_ES','Recordatorio de envío de revisión','{$reviewerName}:\n\nLe recordamos nuestra petición de revisión del envío \"{$articleTitle},\" para {$journalName}. Esperábamos su revisión antes del {$reviewDueDate}, esperamos nos la mande en cuanto la tenga lista.\n\nURL del envío: {$submissionReviewUrl}\n\nLe rogamos nos confirme su disponibilidad para completar esta contribución vital para el trabajo de la revista. Esperamos tener noticias suyas a la mayor brevedad.\n\n{$editorialContactSignature}','Este correo es enviado por el/la Editor/a de Sección para recordar a un/a revisor/a que ya debe entregar su revisión.'),('REVIEW_REMIND_AUTO','es_ES','Recordatorio automático de revisión de envío','{$reviewerName}:\n\nLe recordamos nuestra petición de revisión del envío \"{$articleTitle},\" para {$journalName}. Esperábamos su revisión antes del {$reviewDueDate}, y se ha generado automáticamente este correo-e al haberse superado dicha fecha. Aún estaríamos encantados de recibirla una vez la tenga lista.\n\nSi ha perdido su nombre de usuaria/o y contraseña para la revista puede pinchar en el siguiente enlace para cambiar su contraseña (se la enviaremos por correo-e junto con su nombre de usuaria/o). {$passwordResetUrl}\n\nURL del envío: {$submissionReviewUrl}\n\nLe rogamos nos confirme su disponibilidad para completar esta contribución vital para el trabajo de la revista. Esperamos tener noticias suyas a la mayor brevedad.\n\n{$editorialContactSignature}','Este correo es enviado automáticamente cuando se supera la fecha de entrega de un/a revisor/a (véase Opciones de Revisión en Configuración de la revista, paso 2). Las tareas planificadas deben estar activadas y configuradas (ver fichero de configuración del sitio).'),('REVIEW_REMIND_AUTO_ONECLICK','es_ES','Recordatorio automático de revisión de envío','{$reviewerName}:\n				\nLe recordamos nuestra petición de revisión del envío \"{$articleTitle},\" para {$journalName}. Esperábamos su revisión antes del {$reviewDueDate}, y se ha generado automáticamente este correo-e al haberse superado dicha fecha. Aún estaríamos encantados de recibirla una vez la tenga lista.\n\nURL del envío: {$submissionReviewUrl}\n\nLe rogamos nos confirme su disponibilidad para completar esta contribución vital para el trabajo de la revista. Esperamos tener noticias suyas a la mayor brevedad.\n				\n{$editorialContactSignature}','This email is automatically sent when a reviewer\'s due date elapses (see Review Options under Journal Setup, Step 2) and one-click reviewer access is enabled. Scheduled tasks must be enabled and configured (see the site configuration file).'),('COPYEDIT_REQUEST','es_ES','Petición de corrección','{$copyeditorName}:\n\nMe gustaría pedirle que llevara a cabo la corrección del manuscrito \"{$articleTitle},\" para {$journalName}. En el sitio web de la revista puede encontrar el envío, así como las instrucciones de corrección.\n\nURL del manuscrito: {$submissionCopyeditingUrl}\nNombre de usuaria/o: {$copyeditorUsername}\n\nSi no puede llevar a cabo este trabajo en este momento o tiene cualquier pregunta, póngase en contacto con nosotros/as. Gracias por aceptar llevar a cabo este importante trabajo para la revista.\n\n{$editorialContactSignature}','Este correo es enviado por un/a Editor/a de Sección a un/a corrector/a de un envío para pedirles que comiencen un proceso de corrección. Le proporciona información sobre en el envío y cómo acceder a él.'),('COPYEDIT_COMPLETE','es_ES','Corrección completada','{$editorialContactName}:\n\nAcabo de finalizar la primera ronda de corrección del manuscrito \"{$articleTitle},\" para {$journalName}. Ya está preparado para que el/la autor/a y el/la editor/a revisen los cambios y consultas. \n\nGracias,\n{$copyeditorName}',''),('COPYEDIT_ACK','es_ES','Acuse de recibo de corrección','{$copyeditorName}:\n\nGracias por corregir el manuscrito {$articleTitle},\" para {$journalName}. Supondrá una importante contribución a la calidad de la revista.\n\n{$editorialContactSignature}','Este correo es enviado por el/la Editor/a de Sección al / a la corrector/a de un envío para comunicarle que ha recibido la corrección y agradecerle su contribución.'),('COPYEDIT_AUTHOR_REQUEST','es_ES','Petición de revisión de corrección','{$authorName}:\n\nAcabamos de finalizar una corrección inicial de su manuscrito \"{$articleTitle},\" para {$journalName}. Por favor, identifíquese en el sitio de la revista y responda a las consultas al / a la autor/a que el/la corrector/a haya insertado en el manuscrito y revise los cambios de corrección propuestos. \n\nEsta es la última oportunidad que tendrá para hacer cambios sustanciales. Se le pedirá que revise las galeradas, pero en esa fase tan solo podrá corregir pequeños errores tipográficos y de maquetación.\n\nURL del manuscrito: {$submissionCopyeditingUrl}\nNombre de usuaria/o: {$authorUsername}\n \nSi no puede llevar a cabo este trabajo en este momento o tiene cualquier pregunta, póngase en contacto con nosotros/as. Gracias por su contribución a la revista.\n\n{$editorialContactSignature}','Este correo es enviado por el/la Editor/a de Sección al / a la autor/a de un envío para pedirle que revise el trabajo del / de la corrector/a. Proporciona información de acceso al manuscrito y le avisa de que es la última oportunidad que tiene el/la autor/a para hacer cambios substanciales.'),('COPYEDIT_AUTHOR_COMPLETE','es_ES','Revisión de corrección completada','{$editorialContactName}:\n\nAcabo de revisar la corrección del manuscrito \"{$articleTitle},\" para {$journalName}, y ya está listo para la ronda final de corrección y preparación para la maquetación.\n\nGracias por su contribución a mi trabajo,\n{$authorName}','Este correo es enviado por el/la autor/a al / a la Editor/a de Sección para comunicarle que el proceso de corrección del / de la autor/a se ha completado.'),('COPYEDIT_AUTHOR_ACK','es_ES','Acuse de recibo de revisión de corrección','{$authorName}:\n\nGracias por revisar la corrección de su manuscrito \"{$articleTitle},\" para {$journalName}. Esperamos poder publicar su trabajo lo antes posible.\n\n{$editorialContactSignature}','Este correo es enviado por el / la Editor/a de Sección al / a la autor/a de un envío para confirmar que el proceso de corrección por parte del / de la autor/a se ha completado y agradecerle su contribución.'),('COPYEDIT_FINAL_REQUEST','es_ES','Revisión final de corrección','{$copyeditorName}:\n\nEl/la autor/a y el/la editor/a han completado su revisión de la corrección del manuscrito \"{$articleTitle},\" para {$journalName}. Ya se puede preparar para maquetación la \"copia limpia\" final.\n\nURL del manuscrito: {$submissionCopyeditingUrl}\nNombre de usuaria/o: {$copyeditorUsername}\n\nGracias en el nombre de la revista,\n\n{$editorialContactSignature}','Este correo enviado por el/la Editor/a de Sección al / a la corrector/a le pide que haga una ronda final de corrección de un envío antes de que pase a maquetación.'),('COPYEDIT_FINAL_COMPLETE','es_ES','Revisión de corrección final completada','{$editorialContactName}:\n\nAcabo de preparar una versión limpia y corregida del manuscrito \"{$articleTitle},\" para {$journalName}. Está listo para su maquetación y la preparación de las galeradas.\n\n{$copyeditorName}','Este correo es enviado del / de la corrector/a al / a la Editor/a de Sección para notificarle que la ronda final de corrección ha finalizado y que ya puede comenzar el proceso de maquetación.'),('COPYEDIT_FINAL_ACK','es_ES','Acuse de recibo de revisión final corregida','{$copyeditorName}:\n\nGracias por completar la revisión del manuscrito \"{$articleTitle},\" para {$journalName}. La preparación de una \"copia limpia\" para maquetación es un paso importante en el proceso editorial.\n\n{$editorialContactSignature}','Este correo es enviado por el/la Editor/a de Sección al / a la corrector/a agradeciéndole que haya completado la ronda final de corrección y agradeciéndoles su contribución.'),('LAYOUT_REQUEST','es_ES','Solicitud de galeradas','{$layoutEditorName}:\n\nLe solicito que prepare las galeradas del manuscrito \"{$articleTitle},\" para {$journalName}.\n\nURL del manuscrito: {$submissionLayoutUrl}\nNombre de usuaria/o: {$layoutEditorUsername}\n\nSi no puede llevar a cabo este trabajo en este momento o tiene cualquier pregunta, póngase en contacto con nosotros/as. Gracias por su contribución a la revista.\n\n{$editorialContactSignature}','Este correo es enviado por el/ la Editor/a de Sección al / a la Editor/a de Maquetación notificándole que se les ha asignado la tarea de editar la maquetación de un envío. Le proporciona información sobre el envío y cómo acceder a él.'),('LAYOUT_COMPLETE','es_ES','Galeradas completadas','{$editorialContactName}:\n\nYa han sido preparadas las galeradas para el manuscrito \"{$articleTitle},\" para {$journalName} y están listas para corregir. \n\nSi tiene cualquier pregunta, no dude en contactar con nosotros/as.\n\n{$layoutEditorName}','Este correo es enviado por el/la Editor/a de Maquetación al / a la Editor/a de Sección notificándole que el proceso de maquetación ha finalizado.'),('LAYOUT_ACK','es_ES','Acuse de recibo de maquetación','{$layoutEditorName}:\n\nGracias por prepara las galeradas para el manuscrito \"{$articleTitle},\" para {$journalName}. Esta es una importante contribución al proceso de publicación.\n\n{$editorialContactSignature}','Este correo es enviado por el/la Editor/a de Sección al / a la Editor/a de Maquetación para informarle de que se ha completado el proceso de edición de la maquetación y agradece al / a la editor/a de maquetación su contribución.'),('PROOFREAD_AUTHOR_REQUEST','es_ES','Petición de correccción de pruebas (autor/a)','{$authorName}:\n\nLe rogamos que se encargue de la corrección de las galeradas de su manuscrito \"{$articleTitle},\" para {$journalName}. Para ver las galeradas, identifíquese en la revista a través del enlace que le mostramos a continuación. Pinche en la opción VER PRUEBA para leer lo que será la versión publicada y buscar sólo errores tipográficos y de maquetación sólo. Registre estos errores en la caja de Correcciones de Pruebas, siguiendo las instrucciones proporcionadas.\n\nURL del manuscrito: {$submissionUrl}\nNombre de usuaria/o: {$authorUsername}\n\nSi no puede llevar a cabo esta tarea en este momento o tiene cualquier pregunta, póngase en contacto con nosotros/as. Gracias por su contribución a esta revista.\n\n{$editorialContactSignature}','Este correo es enviado por el / la Editor/a de Sección al / a la autor/a notificándole que tiene a su disposición una galerada del artíuclo para su corrección. Le proporciona información sobre el artículo y cómo acceder a él.'),('PROOFREAD_AUTHOR_COMPLETE','es_ES','Corrección de pruebas completada (autor/a)','{$editorialContactName}:\n\nHe completado la corrección de las pruebas de las galeradas para mi manuscrito \"{$articleTitle},\" para {$journalName}. Las galeradas ya están listas para cualquier corrección final que hagan el/la corrector/a y el/la editor/a de maquetación.\n\n{$authorName}','Este correo enviado por el/la autor/a al / a la Corrector y Editor/a de Sección les notifica que la ronda de corrección del / de la autor/a ha finalizado y de que los detalles los encontrarán en los comentarios del artículo.'),('PROOFREAD_AUTHOR_ACK','es_ES','Acuse de recibo de corrección de pruebas (autor/a)','{$authorName}:\n\nGracias por corregir las pruebas de las galeradas de su manuscrito \"{$articleTitle},\" en {$journalName}. Esperamos poder publicar su trabajo a la mayor brevedad posible.\n\nSi se ha suscrito a nuestro servicio de notificación recibirá un correo-e con la Tabla de Contenidos una vez se haya publicado. Si tiene cualquier pregunta, póngase en contacto con nosotros/as.\n\n{$editorialContactSignature}','Este correo enviado por el/la Editor/a de Sección al / a la autor/a comunica la finalización del proceso inicial de corrección y les agradece su contribución.'),('PROOFREAD_REQUEST','es_ES','Petición de corrección de pruebas','{$proofreaderName}:\n\nLe rogaría que corrigiera las pruebas de las galeradas de su manuscrito \"{$articleTitle},\" para {$journalName}. \n\nURL del manuscrito: {$submissionUrl}\nNombre de usuaria/o: {$proofreaderUsername}\n\nSi no puede llevar a cabo esta tarea en este momento o tiene cualquier pregunta, póngase en contacto con nosotros/as. Gracias por su contribución a esta revista.\n\n{$editorialContactSignature}','Este correo enviado por el/la Editor/a de Sección al / a la corrector/a solicita que se lleve a cabo la corrección de las galeradas de un artículo. Proporciona información sobre el artículo y cómo acceder a él.'),('PROOFREAD_COMPLETE','es_ES','Corrección de pruebas completada','{$editorialContactName}:\n\nHe finalizado la corrección de pruebas de las galeradas del manuscrito \"{$articleTitle},\" para {$journalName}. Las galeradas ya están listas para cualquier corrección final por parte del / de la Editor/a de Maquetación.\n\n{$proofreaderName}','Este correo enviado del / de la Corrector/a al / a la Editor/a de Sección le notifica de que el / la corrector/a ha completado el proceso de corrección.'),('PROOFREAD_ACK','es_ES','Acuse de recibo de corrección de pruebas','{$proofreaderName}:\n\nGracias por corregir las pruebas de las galeradas del manuscrito \"{$articleTitle},\" para {$journalName}. Su trabajo supone una importante contribución a la calidad de esta revista.\n\n{$editorialContactSignature}','Este correo enviado por el / la Editor/a de Sección al / a la Corrector/a confirma que el/la corrector/a ha completado el proceso de corrección y le agradece su contribución.'),('PROOFREAD_LAYOUT_REQUEST','es_ES','Petición de corrección de pruebas (Editor/a de maquetación)','{$layoutEditorName}:\n\nLe solicitamos que proceda a hacer las correcciones solicitadas una vez corregidas las pruebas de las galeradas del manuscrito \"{$articleTitle},\" para {$journalName}.\n\nURL del manuscrito: {$submissionUrl}\nNombre de usuaria/o: {$layoutEditorUsername}\n\nSi no puede llevar a cabo esta tarea en este momento o tiene cualquier pregunta, póngase en contacto con nosotros/as. Gracias por su contribución a esta revista.\n\n{$editorialContactSignature}','Este correo del / de la Editor/a de Sección al / a la Editor/a de Maquetación le notifica que las galeradas de un artículo están listas para la corrección final. Le proporciona información sobre el artículo y cómo acceder a él.'),('PROOFREAD_LAYOUT_COMPLETE','es_ES','Corrección de pruebas completada (Editor/a de maquetación)','{$editorialContactName}:\n\nYa se han corregido las galeradas, una vez hechas las pruebas, del manuscrito \"{$articleTitle},\" para {$journalName}. Ya está listo para su publicación.\n\n{$layoutEditorName}','Este correo del / de la Editor/a de Maquetación al / a la Editor/a de Sección le notifica que la etapa final de corrección ha finalizado y que el artículo está listo para su publicación.'),('PROOFREAD_LAYOUT_ACK','es_ES','Acuse de recibo de corrección de pruebas (Editor/a de maquetación)','{$layoutEditorName}:\n\nGracias por completar la corrección de las pruebas de galeradas asociadas con el manuscrito \"{$articleTitle},\" para {$journalName}. Esto representa una importante contribución al trabajo de esta revista.\n\n{$editorialContactSignature}','Este correo del / de la Editor/a de Sección al / a la Editor/a de Maquetación notifica la finalización de la etapa final de corrección y les agradece su contribución.'),('EMAIL_LINK','es_ES','Artículo interesante','He pensado que le podría interesar ver el artículo \"{$articleTitle}\" de {$authorName}, publicado en el vol. {$volume}, nº {$number} ({$year}) de {$journalName} en \"{$articleUrl}\".','Esta plantilla de correo proporciona a un/a lector/a registrado/a la oportunidad de enviar información sobre un artículo a alguien a quien le podría interesar. Está disponible a través de las Herramientas de Lectura y debe ser activado por el/la Gestor/a de la Revista en las Administración de Herramientas de Lectura.'),('USER_VALIDATE','es_ES','Activación de cuenta','Estimada/o {$userFullName}\n\nSe ha recibido una solicitud de cuenta de usuario para la revista {$journalName} utilizando su dirección de correo. Si desea activar su cuenta en {$journalName}, pulse por favor sobre el vínculo siguiente:\n\n{$activateUrl}\n\nMuchas gracias por su interés.',''),('REVIEWER_REGISTER','es_ES','Revisor para {$journalName}','Estimado/a colega:\n\nA la vista de su trayectoria profesional, su nombre ha sido propuesto para figurar como revisor potencial en el sistema de gestión electrónica de artículos de la revista {$journalName}, sin que ello implique ningún compromiso por su parte y pudiendo dejar de formar parte de esta lista cuando lo desee.\n\nEn caso de estar conforme con actuar como revisor para la revista, podrá recibir solicitudes de revisión de artículos, y aceptar o rechazar dichas solicitudes en su momento. \n\nA continuación le enviamos un nombre de usuario y contraseña con los que podrá acceder al sistema de gestión de envíos de la revista.\n\nUsuario: {$username}\ncontraseña: {$password}\n\nMuchas gracias por su atención y por su colaboración en {$journalName}','Este email se envía a los nuevos revisores para darles la bienvenida al sistema y proporcionarles sus datos de acceso.'),('NOTIFICATION','es_ES','Nueva notificación desde {$siteTitle}','Tiene una nueva notificación desde {$siteTitle}:\n\n{$notificationContents}\n\nEnlace: {$url}\n\n{$principalContactSignature}','El email es enviado a usuarios registrados que han seleccionado recibir notificaciones.'),('NOTIFICATION_MAILLIST','es_ES','Nueva notificación desde {$siteTitle}','Tiene una nueva notificación desde {$siteTitle}:\n--\n{$notificationContents}\n\nLink: {$url}\n--\n\nSi no desea recibir los correos de notificaciones, vaya a {$unsubscribeLink} e introduzca su dirección de correo y su contraseña en nuestra plataforma.\n\n{$principalContactSignature}','Este email es enviado a usuarios sin registrar en las listas de notificaciones.'),('NOTIFICATION_MAILLIST_WELCOME','es_ES','Bienvenido a la lista de correo de {$siteTitle} !','Has escogido recibir notificaciones desde {$siteTitle}.\n\nHaga clic en este enlace para confirmar tu petición y añadir tu email a la lista de notificaciones:\n {$confirmLink}\n\nSi no desea recibir emails de notificaciones, ve a {$unsubscribeLink} e introduzca su dirección de email y su contraseña.\n\nSu contraseña para deshabilitar las notificaciones por email es: {$password}\n\n{$principalContactSignature}','Este correo es enviado a usuarios sin registrar los cuales acaban de registrarse en la lista de notificaciones.'),('SUBSCRIPTION_RENEW_INSTL','es_ES','Renovación de Suscripción: Institucional','An institutional subscription has been renewed online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nInstitution:\n{$institutionName}\n{$institutionMailingAddress}\n\nDomain (if provided):\n{$domain}\n\nIP Ranges (if provided):\n{$ipRanges}\n\nPersona de Contacto:\n{$userDetails}\n\nInformación de membresía (si proporcionada):\n{$membership}\n\nPara ver o editar esta suscripción, por favor use la siguiente url:\n\nURL para gestionar la Suscripción: {$subscriptionUrl}','Este correo notifica al Gestor de Suscripciones de que una Suscripción Institucional ha sido renovada online. Provee de información resumida de la suscripción y de un enlace deacceso rápido a la suscripción renovada.'),('SUBSCRIPTION_RENEW_INDL','es_ES','Renovación de suscrpción: Individual','Una Suscripción Individual ha sido renovada online para {$journalName} con los siguientes detalles.\n\nTipo de Subscripción:\n{$subscriptionType}\n\nUsuario:\n{$userDetails}\n\nInformación de Membresía (si proporcionada):\n{$membership}\n\nPara ver o editar esta suscripción use la siguiente URL:\n\nURL para gestionar la subscripción: {$subscriptionUrl}','Este email notifica al Gestor de Suscripciones de que una suscripción Individual se ha renovado online. Provee de información resumida sobre la suscripción y de un enlace de acceso rápido a la suscripción renovada.'),('EDITOR_DECISION_ACCEPT','es_ES','Decisión del Editor','{$authorName}:\n\nHemos tomado una decisión sobre su presentación a {$journalTitle}, \"{$articleTitle}\".\n\nNuestra decisión es:\n\n{$editorialContactSignature}','Este email del Editor o Editor de Sección  a un Autor notifica de la decisión final sobre su envío.'),('EDITOR_DECISION_RESUBMIT','es_ES','Decisión del Editor','{$authorName}:\n\nHemos tomado una decisión sobre su presentación a {$journalTitle}, \"{$articleTitle}\".\n\nNuestra decisión es:\n\n{$editorialContactSignature}','Este email del Editor o Editor de Sección a un Autor le notifica de que se ha tomado una decisión definitiva sobre su presentación.'),('EDITOR_DECISION_DECLINE','es_ES','Decisión del Editor','{$authorName}:\n\nHemos tomado una decisión sobre su presentación a {$journalTitle}, \"{$articleTitle}\".\n\nNuestra decisión es:\n\n{$editorialContactSignature}','Este email del Editor o Editor de Sección a un Autor les notifica sobre una decisión definitiva sobre su presentación.'),('NOTIFICATION_MAILLIST_PASSWORD','es_ES','Tu lista de correo de notificaciones de {$siteTitle}','Tu nueva contraseña para deshabilitar los emails de notificación es: {$password}\n\nSi deseas dejar de recibir emails de notificación, ve a {$unsubscribeLink} e introduce tu dirección de email y la citada contraseña.\n\n{$principalContactSignature}','Este email se envía a usuarios sin registrar cuando indican que han olvidado la contraseña o son incapaces de entrar. Proporciona una URL que pueden seguir para resetear su contraseña.'),('EDITOR_DECISION_REVISIONS','es_ES','Decisión del Editor','{$authorName}:\n\nHemos tomado una decisión sobre su presentación en {$journalTitle}, \"{$articleTitle}\".\n\nNuestra decisión es:\n\n{$editorialContactSignature}','Este email del Editor o Editor de Sección a un Autor, les notifica de una decisión definitiva sobre su presentación.'),('SUBSCRIPTION_PURCHASE_INDL','es_ES','Compra de Suscripción: Individual','An individual subscription has been purchased online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nUsuario:\n{$userDetails}\n\nInformación de Membresía (si proporcionada):\n{$membership}\n\nPara ver o editar esta suscripción, use la siguiente URL.\n\nURL de la suscripción: {$subscriptionUrl}','Este correo notifica al Gestor de Suscripciones que una suscripción individual ha sido comprada online. Proporciona de un resumen de la información sobre la suscripción y un acceso rápido al enlace de la suscripción comprada.'),('SUBSCRIPTION_PURCHASE_INSTL','es_ES','Compra de Suscripción: Institucional','Una Suscripción Institucional ha sido comprada online en {$journalName} con los siguientes detalles. Para activar la suscripción, use el enlace proporcionado y pon el status de la suscripción como \'Activo\'.\n\nTipo de Suscripción:\n{$subscriptionType}\n\nInstitución:\n{$institutionName}\n{$institutionMailingAddress}\n\nDominio (si se proporciona):\n{$domain}\n\nRangos de IP (si se proporcionan):\n{$ipRanges}\n\nPersona de contacto:\n{$userDetails}\n\nInformación de Membresía (si proporcionada):\n{$membership}\n\nPara ver o editar esta suscripción, use el siguiente enlace.\n\nEnlace de la suscripción: {$subscriptionUrl}','Este correo notifica al Gestor de Suscripciones de que una suscripción institucional ha sido comprada online. Proporciona información resumida sobre la suscripción y un enlace rápido a la suscripción comprada.'),('CITATION_EDITOR_AUTHOR_QUERY','es_ES','Edición de Citas','{$authorFirstName},\n\nPor favor, ¿Podría usted verificar o proporcionarnos la cita adecuada para la siguiente referencia de su artículo, {$articleTitle}:\n\n{$rawCitation}\n\nGracias!\n\n{$userFirstName}\nCorrector de estilo, {$journalName}','Este correo electrónico permite a los correctores de estilo solicitar información adicional acerca de las referencias de los autores.'),('PASSWORD_RESET_CONFIRM','ca_ES','Confirmació per a la reinicialització de la contrasenya','Hem rebut una sol·licitud per a reinicialitzar la vostra contrasenya per al lloc web {$siteTitle}.\n\nSi no sou l\'autor d\'aquesta sol·licitud, ignoreu aquest missatge de correu electrònic i no es canviarà la vostra contrasenya. Si voleu reinicialitzar la contrasenya, feu clic a l\'URL següent.\n\nReinicialització de la meva contrasenya: {$url}\n\n{$principalContactSignature}','Aquest missatge de correu electrònic s\'envia a un usuari registrat si ha indicat que no recorda la seva contrasenya o que no pot iniciar la sessió. Inclou un URL per a la reinicialització de la contrasenya.'),('PASSWORD_RESET','ca_ES','Reinicialització de la contrasenya','La vostra contrasenya per al lloc web {$siteTitle} s\'ha reinicialitzat correctament. Recordeu aquest nom d\'usuari i aquesta contrasenya, ja que els necessitareu per a accedir a la revista i treballar-hi.\n\nNom d\'usuari: {$username}\nContrasenya nova: {$password}\n\n{$principalContactSignature}','Aquest missatge de correu electrònic s\'envia a un usuari registrat per a notificar-li que la seva contrasenya s\'ha reinicialitzat amb èxit després d\'haver seguit el procés descrit al missatge de correu electrònic PASSWORD_RESET_CONFIRM.'),('USER_REGISTER','ca_ES','Registre a la revista','Benvolgut/uda {$userFullName},\n\nUs acabeu de registrar com a usuari de {$journalName}. Aquest missatge de correu electrònic conté el vostre nom d\'usuari i la vostra contrasenya. Necessitareu aquestes dades per a accedir al lloc web de la revista i treballar-hi. Recordeu que en qualsevol moment em podeu sol·licitar que us suprimeixi de la llista d\'usuaris de la revista.\n\nNom d\'usuari: {$username}\nContrasenya: {$password}\n\nMoltes gràcies,\n\n{$principalContactSignature}','Aquest missatge de correu electrònic s\'envia a un usuari que s\'acaba de registrar a la revista per a donar-li la benvinguda al sistema i fer-li arribar el seu nom d\'usuari i la seva contrasenya.'),('USER_VALIDATE','ca_ES','Valideu el vostre compte','Benvolgut/uda {$userFullName},\n\nHeu creat un compte d\'usuari per a {$journalName}, però abans de poder-lo començar a utilitzar heu de validar el vostre compte de correu electrònic. Per a fer-ho, seguiu l\'enllaç següent:\n\n{$activateUrl}\n\nMoltes gràcies,\n\n{$principalContactSignature}','Aquest missatge de correu electrònic s\'envia a un usuari que s\'acaba de registrar per a donar-li la benvinguda al sistema i fer-li arribar el seu nom d\'usuari i la seva contrasenya.'),('REVIEWER_REGISTER','ca_ES','Registre com a revisor a {$journalName}','Després d\'avaluar el vostre perfil, ens hem pres la llibertat de registrar el vostre nom a la base de dades de revisors per a {$journalName}. El fet de pertànyer a aquesta base de dades no suposa cap compromís per part vostra i, d\'altra banda, ens permet fer-vos arribar propostes de revisions. Quan rebeu una proposta de revisió d\'un document tindreu l\'oportunitat de consultar-ne el títol i el resum, i tant podreu acceptar com rebutjar la invitació. En qualsevol moment podeu sol·licitar que se suprimeixi el vostre nom d\'aquesta llista de revisors.\n\nA continuació trobareu el vostre nom d\'usuari i la vostra contrasenya. Necessitareu aquestes dades per a entrar al lloc web de la revista i treballar-hi. És possible que, per exemple, vulgueu actualitzar el vostre perfil i incloure-hi els vostres interessos de revisió.\n\nNom d\'usuari: {$username}\nContrasenya: {$password}\n\nMoltes gràcies,\n\n{$principalContactSignature}','Aquest missatge de correu electrònic s\'envia a un revisor que s\'acaba de registrar per a donar-li la benvinguda al sistema i fer-li arribar el seu nom d\'usuari i la seva contrasenya.'),('PUBLISH_NOTIFY','ca_ES','Nou número publicat','Benvolguts lectors,\n\n{$journalName} acaba de publicar el seu darrer número a {$journalUrl}. Us convidem a consultar-ne el sumari i a visitar el nostre lloc web per a accedir als articles i documents que us puguin interessar.\n\nUs agraïm l\'interès per la nostra revista.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic s\'envia als lectors registrats mitjançant l\'enllaç Notifica als usuaris que hi ha a la pàgina inicial de l\'usuari per a l\'editor. Notifica als lectors la publicació d\'un número nou i els convida a entrar a la revista mitjançant l\'enllaç proporcionat.'),('LOCKSS_EXISTING_ARCHIVE','ca_ES','Sol·licitud d\'arxivament per a {$journalName}','Benvolgut/uda [bibliotecari universitari],\n\n{$journalName} <{$journalUrl}> és una revista en què un membre de la vostra facultat o universitat, [nom del membre], participa en qualitat de [nom del rol]. Des d\'aquesta revista volem crear un arxiu amb la vostra biblioteca universitària i altres biblioteques, d\'acord amb la iniciativa LOCKSS (<i>lots of copies keep stuff safe</i>).\n\n[Descripció breu de la revista]\n\nL\'URL del LOCKSS Publisher Manifest per a la nostra revista és: {$journalUrl}/gateway/lockss\n\nSegons la informació de què disposem, la vostra biblioteca ja participa en la iniciativa LOCKSS. Per tant, no dubteu a sol·licitar-nos totes les metadades addicionals que necessiteu per a registrar aquesta revista a la vostra versió de LOCKSS.\n\nMoltes gràcies,\n\n{$principalContactSignature}','Aquest missatge de correu electrònic sol·licita al conservador de l\'arxiu LOCKSS la inclusió d\'aquesta revista en el seu arxiu. Inclou l\'URL del LOCKSS Publisher Manifest per a la revista.'),('LOCKSS_NEW_ARCHIVE','ca_ES','Sol·licitud d\'arxivament per a {$journalName}','Benvolgut/uda [bibliotecari universitari],\n\n{$journalName} <{$journalUrl}> és una revista en què un membre de la vostra facultat o universitat, [nom del membre], participa en qualitat de [nom del rol]. Des d\'aquesta revista volem crear un arxiu amb la vostra biblioteca universitària i altres biblioteques, d\'acord amb la iniciativa LOCKSS (<i>lots of copies keep stuff safe</i>).\n\n[Descripció breu de la revista]\n\nEl programa LOCKSS <http://lockss.stanford.edu/>, una iniciativa internacional d\'enllaç entre biblioteques i entitats publicadores, representa un exemple viu de conservació distribuïda i repositori d\'arxivament. Es tracta d\'una aplicació gratuïta executable en qualsevol ordinador personal que podeu gestionar fàcilment i per a la qual es requereix un manteniment mínim.\n\nPer a contribuir a l\'arxivament d\'aquesta revista, us convido a ser membre de la comunitat LOCKSS i a col·laborar en la recopilació i conservació de títols elaborats a la vostra facultat o universitat i en altres entitats acadèmiques de l\'àmbit internacional. Per a fer-ho, us recomano que algun membre del vostre personal visiti el lloc web de LOCKSS per a obtenir informació sobre el funcionament d\'aquest sistema. Confio rebre ben aviat la vostra acceptació per a col·laborar en l\'arxivament d’aquesta revista.\n\nMoltes gràcies,\n\n{$principalContactSignature}','Aquest missatge de correu electrònic convida el destinatari a participar en la iniciativa LOCKSS i a incloure aquesta revista en el seu arxiu. Proporciona informació sobre la iniciativa LOCKSS i com s\'hi ha de participar.'),('SUBMISSION_ACK','ca_ES','Justificant de recepció de la tramesa','Benvolgut/uda {$authorName},\n\nGràcies per haver tramès el manuscrit \"{$articleTitle}\" a {$journalName}. Gràcies al sistema de gestió de revistes en línia que utilitzem, en podreu seguir el progrés durant el procés editorial iniciant la sessió al lloc web de la revista:\n\nURL del manuscrit: {$submissionUrl}\nNom d\'usuari: {$authorUsername}\n\nSi teniu qualsevol dubte o consulta, no dubteu a fer-me-la arribar. Us agraeixo que hàgiu tingut en compte aquesta revista com a mitjà per a difondre la vostra obra.\n\n{$editorialContactSignature}','Si està activat, aquest missatge de correu electrònic s\'envia automàticament als autors quan completen el procés de tramesa d\'un manuscrit a la revista. Proporciona informació sobre el seguiment de la tramesa durant el procés editorial i agraeix a l\'autor la seva contribució a la revista.'),('SUBMISSION_UNSUITABLE','ca_ES','Tramesa rebutjada','Benvolgut/uda {$authorName},\n\nDesprés d\'una primera revisió de \"{$articleTitle}\", hem decidit que aquesta tramesa no s\'adequa a la temàtica i l\'àmbit de {$journalName}. Per a conèixer millor el tipus d\'obres que publiquem us recomano que consulteu la descripció d\'aquesta revista a la secció Quant a i també els articles publicats fins ara. També podeu intentar trametre aquest manuscrit a una altra revista més adequada.\n\n{$editorialContactSignature}',''),('SUBMISSION_COMMENT','ca_ES','Comentari de la tramesa','Benvolgut/uda {$name},\n\n{$commentName} ha afegit un comentari a la tramesa \"{$articleTitle}\" per a la revista {$journalName}:\n\n{$comments}','Aquest missatge de correu electrònic notifica la publicació d\'un nou comentari a les diverses persones involucrades en el procés editorial d\'una tramesa.'),('SUBMISSION_DECISION_REVIEWERS','ca_ES','Decisió sobre \"{$articleTitle}\"','Com a membre del grup de revisors de la tramesa \"{$articleTitle}\" per a la revista {$journalName}, us faig arribar les revisions i la decisió de l\'editor enviats a l\'autor d\'aquesta obra. \n\nGràcies una vegada més per la vostra important contribució a aquest procés.\n \n{$editorialContactSignature}\n\n{$comments}','Aquest missatge de correu electrònic notifica als revisors d\'una tramesa que s\'ha completat el procés de revisió. Inclou informació sobre l\'article i la decisió presa, i agraeix als revisors la seva contribució.'),('EDITOR_ASSIGN','ca_ES','Assignació editorial','Benvolgut/uda {$editorialContactName},\n\nUs ha estat assignada la tramesa \"{$articleTitle}\" per a la revista {$journalName} perquè en superviseu el procés editorial en qualitat d\'editor de secció.\n\nURL de la tramesa: {$submissionUrl}\nNom d\'usuari: {$editorUsername}\n\nMoltes gràcies,\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic notifica a l\'editor de secció que l\'editor li ha assignat la tasca de supervisar el procés editorial d\'una tramesa. Proporciona informació sobre la tramesa i indica com s\'ha d\'accedir al lloc web de la revista.'),('REVIEW_REQUEST','ca_ES','Sol·licitud de revisió d\'un article','Benvolgut/uda {$reviewerName},\n\nConsidero que el vostre perfil és adequat per a revisar el manuscrit \"{$articleTitle}\" tramès a la revista {$journalName}. A continuació trobareu un resum de la tramesa, i confio que acceptareu encarregar-vos d\'aquesta important tasca.\n\nUs demano que inicieu la sessió a la revista abans del {$weekLaterDate} per a indicar-nos si accepteu o no encarregar-vos de la revisió de la tramesa i, en cas d\'acceptar-la, per a accedir-hi i enregistrar-ne la revisió i recomanació. El lloc web de la revista és {$journalUrl}.\n\nLa data límit per a la revisió és el {$reviewDueDate}.\n\nSi heu perdut el vostre nom d\'usuari o la vostra contrasenya per al lloc web de la revista, podeu utilitzar l\'enllaç següent per a reinicialitzar la contrasenya (en rebreu una de nova per correu electrònic, juntament amb el vostre nom d\'usuari). {$passwordResetUrl}\n\nURL de la tramesa: {$submissionReviewUrl}\n\nGràcies per tenir en compte aquesta sol·licitud.\n\n{$editorialContactSignature}\n\n\n\n\"{$articleTitle}\"\n\n{$abstractTermIfEnabled}\n{$articleAbstract}','Aquest missatge de correu electrònic té com a remitent l\'editor de secció i s\'envia a un possible revisor perquè accepti o rebutgi la revisió d\'una tramesa. Proporciona la informació següent relativa a la tramesa: títol i resum, data de venciment per a la revisió i mode d\'accés a la tramesa. Aquest missatge s\'utilitza si s\'ha seleccionat el procés de revisió estàndard en el pas 2 de la configuració de la revista (en cas contrari, vegeu el missatge de correu electrònic REVIEW_REQUEST_ATTACHED).'),('REVIEW_REQUEST_ONECLICK','ca_ES','Sol·licitud de revisió d\'un article','Benvolgut/uda {$reviewerName},\n\nConsidero que el vostre perfil és adequat per a revisar el manuscrit \"{$articleTitle}\" tramès a la revista {$journalName}. A continuació trobareu un resum de la tramesa, i confio que acceptareu encarregar-vos d\'aquesta important tasca.\n\nUs demano que inicieu la sessió a la revista abans del {$weekLaterDate} per a indicar-nos si accepteu o no encarregar-vos de la revisió de la tramesa i, en cas d\'acceptar-la, per a accedir-hi i enregistrar-ne la revisió i recomanació.\n\nLa data límit per a la revisió és el {$reviewDueDate}.\n\nURL de la tramesa: {$submissionReviewUrl}\n\nGràcies per tenir en compte aquesta sol·licitud.\n\n{$editorialContactSignature}\n\n\n\n\"{$articleTitle}\"\n\n{$abstractTermIfEnabled}\n{$articleAbstract}','Aquest missatge de correu electrònic té com a remitent l\'editor de secció i s\'envia a un possible revisor perquè accepti o rebutgi la revisió d\'una tramesa. Proporciona la informació següent relativa a la tramesa: títol i resum, data de venciment per a la revisió i mode d\'accés a la tramesa. Aquest missatge s\'utilitza si s\'ha seleccionat el procés de revisió estàndard en el pas 2 de la configuració de la revista i s\'ha habilitat l\'accés a la revisió en un clic.'),('REVIEW_REQUEST_ATTACHED','ca_ES','Sol·licitud de revisió d\'un article','Benvolgut/uda {$reviewerName},\n\nConsidero que el vostre perfil és adequat per a revisar el manuscrit \"{$articleTitle}\" tramès a la revista {$journalName}, per la qual cosa us demano que valoreu la possibilitat d\'encarregar-vos d\'aquesta important tasca per a la nostra revista. A continuació trobareu les indicacions per a la revisió d\'aquesta revista, així com també la tramesa com a fitxer adjunt. Noteu que m\'hauríeu de fer arribar per correu electrònic la revisió de la tramesa i la recomanació corresponent abans del {$reviewDueDate}.\n\nUs demano que respongueu a aquest missatge abans del {$weekLaterDate} per a indicar-nos si accepteu encarregar-vos de la revisió.\n\nGràcies per tenir en compte aquesta sol·licitud.\n\n{$editorialContactSignature}\n\n\nIndicacions per a la revisió\n\n{$reviewGuidelines}','Aquest missatge de correu electrònic té com a remitent l\'editor de secció i s\'envia a un possible revisor perquè accepti o rebutgi la revisió d\'una tramesa. Inclou la tramesa com a fitxer adjunt. Aquest missatge s\'utilitza si s\'ha seleccionat el procés de revisió amb fitxer adjunt en el pas 2 de la configuració de la revista (en cas contrari, vegeu el missatge de correu electrònic REVIEW_REQUEST).'),('REVIEW_CANCEL','ca_ES','Sol·licitud de revisió cancel·lada','Benvolgut/uda {$reviewerName},\n\nHem decidit cancel·lar la nostra sol·licitud perquè reviseu la tramesa \"{$articleTitle}\" per a {$journalName}. Lamentem les molèsties que us pugui causar aquesta decisió i confiem tornar a sol·licitar els vostres serveis de revisió per a aquesta revista en el futur.\n\nSi teniu qualsevol consulta, no dubteu a fer-me-la arribar.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té com a remitent l\'editor de secció i s\'envia a un revisor que estigui revisant una tramesa per a notificar-li que aquesta tasca ha estat cancel·lada.'),('REVIEW_CONFIRM','ca_ES','Accepto la revisió','Benvolgut/uda {$editorialContactName},\n\nAccepto revisar la tramesa \"{$articleTitle}\" per a {$journalName}, i us agraeixo que m\'hàgiu tingut en compte per a aquesta tasca. La meva intenció és tenir-la acabada per a la data de venciment prevista ({$reviewDueDate}), o abans si és possible.\n\n{$reviewerName}','Aquest missatge de correu electrònic té un revisor com a remitent i s\'envia a l\'editor de secció en resposta a una sol·licitud de revisió per a notificar-li que ha acceptat encarregar-se d\'aquesta tasca i que la trametrà abans de la data indicada.'),('REVIEW_DECLINE','ca_ES','Rebutjo la revisió','Benvolgut/uda {$editorialContactName},\n\nLamento comunicar-vos que en aquesta ocasió no em podré encarregar de la revisió de la tramesa \"{$articleTitle}\" per a {$journalName}. Us agraeixo que m\'hàgiu tingut en compte i confio que ens tornem a posar en contacte en una altra ocasió.\n\n{$reviewerName}','Aquest missatge de correu electrònic té un revisor com a remitent i s\'envia a l\'editor de secció en resposta a una sol·licitud de revisió per a notificar-li que rebutja encarregar-se d\'aquesta tasca.'),('REVIEW_COMPLETE','ca_ES','Revisió de l\'article completada','Benvolgut/uda {$editorialContactName},\n\nUs comunico que he acabat la revisió de \"{$articleTitle}\" per a {$journalName} i que també n\'he tramès la recomanació corresponent, \"{$recommendation}\".\n\n{$reviewerName}','Aquest missatge de correu electrònic té un revisor com a remitent i s\'envia a l\'editor de secció per a notificar-li que ha completat la revisió i que ha enregistrat els comentaris i les recomanacions corresponents al lloc web de la revista.'),('REVIEW_ACK','ca_ES','Justificant de recepció de la revisió de l\'article','Benvolgut/uda {$reviewerName},\n\nUs agraïm que hàgiu revisat la tramesa \"{$articleTitle}\" per a {$journalName}. Valorem la vostra contribució a la qualitat de les obres que publiquem.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té un editor de secció com a remitent i s\'envia al revisor per a confirmar-li la recepció d\'una revisió completada i agrair-li la seva contribució.'),('REVIEW_REMIND','ca_ES','Recordatori de revisió de la tramesa','Benvolgut/uda {$reviewerName},\n\nUs recordem la nostra petició per a revisar la tramesa \"{$articleTitle}\" per a {$journalName}. Esperàvem aquesta revisió abans del {$reviewDueDate}, i confiem rebre-la tan aviat com la tingueu enllestida.\n\nSi heu perdut el vostre nom d\'usuari o la vostra contrasenya per al lloc web de la revista, podeu utilitzar l\'enllaç següent per a reinicialitzar la contrasenya (en rebreu una de nova per correu electrònic, juntament amb el vostre nom d\'usuari). {$passwordResetUrl}\n\nURL de la tramesa: {$submissionReviewUrl}\n\nUs agrairem que ens confirmeu la vostra disponibilitat per a completar aquesta contribució vital per al funcionament de la revista, i confiem rebre notícies vostres ben aviat.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té un editor de secció com a remitent i s\'envia a un revisor per a recordar-li que ha superat la data de venciment per a lliurar la revisió.'),('REVIEW_REMIND_ONECLICK','ca_ES','Recordatori de revisió de la tramesa','Benvolgut/uda {$reviewerName},\n\nUs recordem la nostra petició per a revisar la tramesa \"{$articleTitle}\" per a {$journalName}. Esperàvem aquesta revisió abans del {$reviewDueDate}, i confiem rebre-la tan aviat com la tingueu enllestida.\n\nURL de la tramesa: {$submissionReviewUrl}\n\nUs agrairem que ens confirmeu la vostra disponibilitat per a completar aquesta contribució vital per al funcionament de la revista, i confiem rebre notícies vostres ben aviat.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té un editor de secció com a remitent i s\'envia a un revisor per a recordar-li que ha superat la data de venciment per a lliurar la revisió.'),('REVIEW_REMIND_AUTO','ca_ES','Recordatori automàtic de revisió de la tramesa','Benvolgut/uda {$reviewerName},\n\nUs recordem la nostra petició per a revisar la tramesa \"{$articleTitle}\" per a {$journalName}. Esperàvem aquesta revisió abans del {$reviewDueDate}, i aquest missatge de correu electrònic s\'ha generat i enviat automàticament en haver-se superat aquesta data. Malgrat això, encara confiem rebre la vostra revisió tan aviat com la tingueu enllestida.\n\nSi heu perdut el vostre nom d\'usuari o la vostra contrasenya per al lloc web de la revista, podeu utilitzar l\'enllaç següent per a reinicialitzar la contrasenya (en rebreu una de nova per correu electrònic, juntament amb el vostre nom d\'usuari). {$passwordResetUrl}\n\nURL de la tramesa: {$submissionReviewUrl}\n\nUs agrairem que ens confirmeu la vostra disponibilitat per a completar aquesta contribució vital per al funcionament de la revista, i confiem rebre notícies vostres ben aviat.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic s’envia automàticament quan se supera la data de venciment per a una revisió (vegeu les opcions de revisió del pas 2 de la configuració de la revista) i s\'ha inhabilitat l\'accés per a revisors en un clic. Les tasques planificades han d\'estar habilitades i configurades (vegeu el fitxer de configuració del lloc).'),('REVIEW_REMIND_AUTO_ONECLICK','ca_ES','Recordatori automàtic de revisió de la tramesa','Benvolgut/uda {$reviewerName},\n\nUs recordem la nostra petició per a revisar la tramesa \"{$articleTitle}\" per a {$journalName}. Esperàvem aquesta revisió abans del {$reviewDueDate}, i aquest missatge de correu electrònic s\'ha generat i enviat automàticament en haver-se superat aquesta data. Malgrat això, encara confiem rebre la vostra revisió tan aviat com la tingueu enllestida.\n\nURL de la tramesa: {$submissionReviewUrl}\n\nUs agrairem que ens confirmeu la vostra disponibilitat per a completar aquesta contribució vital per al funcionament de la revista, i confiem rebre notícies vostres  ben aviat.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic s\'envia automàticament quan se supera la data de venciment per a una revisió (vegeu les opcions de revisió del pas 2 de la configuració de la revista) i s\'ha habilitat l\'accés per a revisors en un clic. Les tasques planificades han d\'estar habilitades i configurades (vegeu el fitxer de configuració del lloc).'),('COPYEDIT_REQUEST','ca_ES','Sol·licitud de correcció','Benvolgut/uda {$copyeditorName},\n\nM\'agradaria demanar-vos que us encarreguéssiu de la revisió de \"{$articleTitle}\" per a {$journalName}. Els passos que hauríeu de seguir són els següents:\n\n1. Feu clic a l\'URL de la tramesa que trobareu més avall en aquest missatge.\n2. Inicieu la sessió a la revista i feu clic al fitxer que trobareu en el pas 1.\n3. Consulteu les instruccions per a la correcció que hi ha publicades a la pàgina web.\n4. Obriu el fitxer que heu baixat i corregiu-lo. Hi podeu incloure totes les consultes a l\'autor que considereu necessàries. \n5. Deseu el fitxer corregit i pengeu-lo en el pas 1 de la correcció.\n6. Envieu el missatge de correu electrònic COMPLET a l\'editor.\n\nURL de {$journalName}: {$journalUrl}\nURL de la tramesa: {$submissionCopyeditingUrl}\nNom d\'usuari: {$copyeditorUsername}\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té un editor de secció com a remitent i s\'envia al possible corrector d\'una tramesa per a sol·licitar-li que comenci el procés de correcció. Proporciona informació sobre la tramesa i com s\'hi ha d\'accedir.'),('COPYEDIT_COMPLETE','ca_ES','Correcció completada','Benvolgut/uda {$authorName},\n\nJa hem corregit la vostra tramesa \"{$articleTitle}\" per a {$journalName}. Seguiu els passos següents per a revisar els canvis proposats i respondre a les consultes a l\'autor:\n\n1. Inicieu la sessió a la revista fent clic a l\'URL que s\'indica més endavant en aquest missatge i introduint-hi el vostre nom d\'usuari i la vostra contrasenya (utilitzeu l\'enllaç Oblida, si escau).\n2. Feu clic al fitxer que hi ha a 1. Fitxer de la correcció inicial per a baixar i obrir la versió corregida. \n3. Reviseu la correcció, feu-hi els canvis necessaris mitjançant l\'eina de seguiment de canvis del Word i responeu les consultes. \n4. Deseu el fitxer a l\'escriptori i pengeu-lo a 2. Correcció de l\'autor.\n5. Feu clic a la icona de correu electrònic que hi ha a sota de COMPLET i envieu el missatge de correu electrònic a l\'editor.\n\nNoteu que aquesta serà la darrera oportunitat que tindreu per a fer canvis substancials a la tramesa, atès que més endavant se us demanarà que corregiu les galerades, però durant aquest procés només podreu esmenar errors tipogràfics i de format.\n\nURL del manuscrit: {$submissionEditingUrl}\nNom d\'usuari: {$authorUsername}\n\nSi no esteu disponible per a encarregar-vos d\'aquesta tasca o si teniu cap dubte o consulta, no dubteu a fer-m\'ho saber. \n\nGràcies per la vostra contribució a aquesta revista.\n\n{$copyeditorName}',''),('COPYEDIT_ACK','ca_ES','Justificant de recepció de la correcció','Benvolgut/uda {$copyeditorName},\n\nGràcies per haver corregit el manuscrit \"{$articleTitle}\" per a {$journalName}. La vostra tasca és una contribució molt important a la qualitat d\'aquesta revista.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al corrector d\'una tramesa per a notificar-li que ha completat el procés de correcció i agrair-li la seva contribució.'),('COPYEDIT_AUTHOR_REQUEST','ca_ES','Sol·licitud de revisió de la correcció','Benvolgut/uda {$authorName},\n\nS\'ha completat la primera etapa de correcció de la vostra tramesa \"{$articleTitle}\" per a {$journalName}. Seguiu els passos següents per a revisar-la:\n\n1. Feu clic a l\'URL de la tramesa que trobareu més avall en aquest missatge.\n2. Inicieu la sessió a la revista i feu clic al fitxer que trobareu al pas 1.\n3. Obriu la tramesa baixada.\n4. Reviseu el text tenint en compte les propostes de correcció i les consultes a l\'autor.\n5. Feu totes les correccions que considereu que milloraran el text.\n6. Una vegada hàgiu acabat la revisió, pengeu el fitxer al pas 2.\n7. Feu clic a METADADES per a comprovar que la informació d\'indexació sigui completa i correcta.\n8. Envieu el missatge de correu electrònic COMPLET a l\'editor i al corrector.\n\nURL de la tramesa: {$submissionCopyeditingUrl}\nNom d\'usuari: {$authorUsername}\n\nNoteu que aquesta serà la darrera oportunitat que tindreu per a fer correccions substancials a la tramesa, atès que a l\'etapa de correcció de proves, que segueix la preparació de les galerades, només es podran esmenar errors tipogràfics i de format.\n\nSi no esteu disponible per a encarregar-vos d\'aquesta tasca o si teniu cap dubte o consulta, no dubteu a fer-m\'ho saber. \n\nGràcies per la vostra contribució a aquesta revista,\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia a l\'autor d\'una tramesa per a sol·licitar-li que revisi la feina feta pel corrector. Proporciona informació per a accedir al manuscrit i alerta a l\'autor que aquesta és la darrera oportunitat que té per a fer-hi canvis substancials.'),('COPYEDIT_AUTHOR_COMPLETE','ca_ES','Revisió de la correcció completada','Benvolgut/uda {$editorialContactName},\n\nJa he revisat la correcció del manuscrit \"{$articleTitle}\" per a {$journalName}. Per tant, la tramesa ja és a punt per a fer-hi la darrera ronda de revisió i preparar-la per a la maquetació. \n\nGràcies per aquesta contribució a la meva obra.\n\n{$authorName}','Aquest missatge de correu electrònic té l\'autor com a remitent i s\'envia a l\'editor de secció per a notificar-li que s\'ha completat el procés de correcció de l\'autor.'),('COPYEDIT_AUTHOR_ACK','ca_ES','Justificant de recepció de la revisió de la correcció','Benvolgut/uda {$authorName},\n\nGràcies per haver revisat la correcció del vostre manuscrit \"{$articleTitle}\" per a {$journalName}. Esperem publicar la vostra obra ben aviat.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia a l\'autor d\'una tramesa per a notificar-li que ha completat correctament el procés de correcció i agrair-li la seva contribució.'),('COPYEDIT_FINAL_REQUEST','ca_ES','Revisió final de la correcció','Benvolgut/uda {$copyeditorName},\n\nL\'autor i l\'editor ja han acabat de revisar la correcció de \"{$articleTitle}\" per a {$journalName}. Ara, doncs, ja es pot preparar una \"còpia neta\" de la tramesa per a la maquetació. Per a fer-ho, seguiu els passos següents:\n1. Feu clic a l\'URL de la tramesa que trobareu més endavant en aquest missatge.\n2. Inicieu la sessió a la revista i feu clic al fitxer que trobareu en el pas 2.\n3. Obriu el fitxer baixat i incorporeu-hi totes les correccions i les respostes a les consultes.\n4. Deseu el fitxer net i pengeu-lo en el pas 3 de la correcció.\n5. Feu clic a METADADES per a comprovar que la informació d\'indexació sigui correcta (recordeu de desar totes les correccions que hi feu).\n6. Envieu el missatge de correu electrònic COMPLET a l\'editor.\n\nURL de {$journalName}: {$journalUrl}\nURL de la tramesa: {$submissionCopyeditingUrl}\nNom d\'usuari: {$copyeditorUsername}\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al corrector per a sol·licitar-li que s\'encarregui de la ronda final de correcció d\'una tramesa abans que entri en el procés de maquetació.'),('COPYEDIT_FINAL_COMPLETE','ca_ES','Revisió final de la correcció completada','Benvolgut/uda {$editorialContactName},\n\nHe preparat una versió neta i corregida del manuscrit \"{$articleTitle}\" per a {$journalName}. Aquesta versió ja és a punt per a entrar en el procés de maquetació i de preparació de les galerades.\n\n{$copyeditorName}','Aquest missatge de correu electrònic té el corrector com a remitent i s\'envia a l\'editor de secció per a notificar-li que ha completat la ronda final de correcció i que el procés de maquetació ja pot començar.'),('COPYEDIT_FINAL_ACK','ca_ES','Justificant de recepció de la revisió final de la correcció','Benvolgut/uda {$copyeditorName},\n\nGràcies per haver completat la correcció del manuscrit \"{$articleTitle}\" per a {$journalName}. La preparació d’una \"còpia neta\" per a la maquetació és un pas molt important del procés editorial.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al corrector per a notificar-li que ha completat la ronda final de correcció i agrair-li la seva contribució.'),('LAYOUT_REQUEST','ca_ES','Sol·licitud de galerades','Benvolgut/uda {$layoutEditorName},\n\nUs demanem que us encarregueu de preparar les galerades de la tramesa \"{$articleTitle}\" per a {$journalName} seguint els passos següents:\n\n1. Feu clic a l\'URL de la tramesa que trobareu més avall en aquest missatge.\n2. Inicieu la sessió a la revista i utilitzeu el fitxer de la versió maquetada per a crear les galerades d\'acord amb els estàndards de la revista.\n3. Envieu el missatge de correu electrònic COMPLET a l\'editor.\n\nURL de {$journalName}: {$journalUrl}\nURL de la tramesa: {$submissionLayoutUrl}\nNom d\'usuari: {$layoutEditorUsername}\n\nSi no esteu disponible per a encarregar-vos d\'aquesta tasca o si teniu cap dubte o consulta, no dubteu a fer-m\'ho saber. \n\nGràcies per la vostra contribució a aquesta revista.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al maquetador per a notificar-li que ha estat assignat per a encarregar-se de la maquetació d\'una tramesa. Proporciona informació sobre la tramesa i com s\'hi ha d\'accedir.'),('LAYOUT_COMPLETE','ca_ES','Galerades completades','Benvolgut/uda {$editorialContactName},\n\nJa he preparat les galerades del manuscrit \"{$articleTitle}\" per a {$journalName}. Així, doncs, ja estan a punt per a entrar en el procés de correcció de proves. \n\nSi teniu qualsevol consulta, no dubteu a fer-me-la arribar.\n\n{$layoutEditorName}','Aquest missatge té el maquetista com a remitent i s\'envia a l\'editor de secció per a notificar-li que s\'ha completat el procés de maquetació.'),('LAYOUT_ACK','ca_ES','Justificant de recepció de les galerades','Benvolgut/uda {$layoutEditorName},\n\nGràcies per haver preparat les galerades del manuscrit \"{$articleTitle}\" per a {$journalName}. Aquesta tasca és una contribució molt important al procés de publicació.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al maquetista per a notificar-li que ha completat el procés de maquetació i agrair-li la seva contribució.'),('PROOFREAD_AUTHOR_REQUEST','ca_ES','Sol·licitud de correcció de proves (autor)','Benvolgut/uda {$authorName},\n\nUs volem demanar que us encarregueu de la correcció de proves de la vostra tramesa \"{$articleTitle}\" per a {$journalName} seguint els passos següents:\n\n1. Feu clic a l\'URL de la tramesa que trobareu més avall en aquest missatge.\n2. Inicieu la sessió a la revista i consulteu les INSTRUCCIONS PER A LA CORRECCIÓ DE PROVES.\n3. Feu clic a VISUALITZA LA PROVA a la secció de maquetació i corregiu les galerades en un dels formats utilitzats o en més d\'un.\n4. Introduïu les correccions (tipogràfiques i de format) a Correccions de proves.\n5. Deseu les correccions i envieu-les per correu electrònic al maquetista i el corrector de proves.\n6. Envieu el missatge de correu electrònic COMPLET a l\'editor.\n\nURL de la tramesa: {$submissionUrl}\nNom d\'usuari: {$authorUsername}\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia a l\'autor per a notificar-li que les galerades d\'un article ja són a punt per a fer-hi la correcció de proves. Proporciona informació sobre l\'article i com s\'hi ha d\'accedir.'),('PROOFREAD_AUTHOR_COMPLETE','ca_ES','Correcció de proves completada (autor)','Benvolgut/uda {$editorialContactName},\n\nHe acabat la correcció de proves de les galerades per al meu manuscrit \"{$articleTitle}\" per a {$journalName}. Així, doncs, les galerades ja són a punt perquè el corrector i el maquetista hi facin les correccions finals. \n\n{$authorName}','Aquest missatge de correu electrònic té l\'autor com a remitent i s\'envia al corrector de proves i a l\'editor per a notificar-los que s\'ha completat la ronda de correcció de proves i que en trobaran més detalls als comentaris de l\'article.'),('PROOFREAD_AUTHOR_ACK','ca_ES','Justificant de recepció de la correcció de proves (autor)','Benvolgut/uda {$authorName},\n\nGràcies per haver fet la correcció de proves per a les galerades del vostre manuscrit \"{$articleTitle}\" per a {$journalName}. Confiem publicar el vostre article ben aviat.\n\nNoteu que si us subscriviu al nostre sistema de notificacions rebreu un missatge de correu electrònic amb el sumari de la revista tan aviat com aquesta es publiqui. Si teniu qualsevol consulta, no dubteu a fer-me-la arribar.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia a l\'autor per a notificar-li que ha completat la ronda inicial de correcció de proves i agrair-li la seva contribució.'),('PROOFREAD_REQUEST','ca_ES','Sol·licitud de correcció de proves','Benvolgut/uda {$proofreaderName},\n\nUs volem demanar que us encarregueu de la correcció de proves de la tramesa \"{$articleTitle}\" per a {$journalName} seguint els passos següents:\n\n1. Feu clic a l\'URL de la tramesa que trobareu més avall en aquest missatge.\n2. Inicieu la sessió a la revista i consulteu les INSTRUCCIONS PER A LA CORRECCIÓ DE PROVES.\n3. Feu clic a VISUALITZA LA PROVA a la secció de maquetació i corregiu les galerades en un dels formats utilitzats o en més d\'un.\n4. Introduïu les correccions (tipogràfiques i de format) a Correccions de proves.\n5. Deseu les correccions i envieu-les per correu electrònic al maquetista.\n6. Envieu el missatge de correu electrònic COMPLET a l\'editor.\n\nURL del manuscrit: {$submissionUrl}\nNom d\'usuari: {$proofreaderUsername}\n\nSi no esteu disponible per a encarregar-vos d\'aquesta tasca o si teniu cap dubte o consulta, no dubteu a fer-m\'ho saber. \n\nGràcies per la vostra contribució a aquesta revista.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al corrector de proves per a sol·licitar-li que s\'encarregui de la correcció de proves de les galerades per a un article. Proporciona informació sobre l\'article i com s\'hi accedeix.'),('PROOFREAD_COMPLETE','ca_ES','Correcció de proves completada','Benvolgut/uda {$editorialContactName},\n\nHe acabat la correcció de proves de les galerades per al manuscrit \"{$articleTitle}\" per a {$journalName}. Així, doncs, les galerades ja són a punt perquè el maquetista hi faci les correccions finals. \n\n{$proofreaderName}','Aquest missatge de correu electrònic té el corrector de proves com a remitent i s\'envia a l\'editor de secció per a notificar-li que s\'ha completat el procés de correcció de proves.'),('PROOFREAD_ACK','ca_ES','Justificant de recepció de la correcció de proves','Benvolgut/uda {$proofreaderName},\n\nGràcies per haver fet la correcció de proves de les galerades per al manuscrit \"{$articleTitle}\" per a {$journalName}. La vostra tasca és una contribució molt important a la qualitat d\'aquesta revista.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al corrector de proves per a notificar-li que ha completat el procés correcció de proves i agrair-li la seva contribució.'),('PROOFREAD_LAYOUT_REQUEST','ca_ES','Sol·licitud de correcció de proves (maquetista)','Benvolgut/uda {$layoutEditorName},\n\nL\'autor i el corrector de proves ja han fet la correcció de proves de la tramesa \"{$articleTitle}\" per a {$journalName} i, per tant, ara us hauríeu d\'encarregar de corregir-la seguint els passos següents:\n\n1. Feu clic a l\'URL de la tramesa que trobareu més avall en aquest missatge.\n2. Inicieu la sessió a la revista i consulteu les instruccions per a crear unes galerades corregides.\n3. Pengeu les galerades revisades.\n4. Envieu el missatge de correu electrònic COMPLET del pas 3 de la correcció de proves a l\'editor.\n\nURL de {$journalName}: {$journalUrl}\nURL de la tramesa: {$submissionUrl}\nNom d\'usuari: {$layoutEditorUsername}\n\nSi no esteu disponible per a encarregar-vos d\'aquesta tasca o si teniu cap dubte o consulta, no dubteu a fer-m\'ho saber. \n\nGràcies per la vostra contribució a aquesta revista.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al maquetista per a notificar-li que les galerades d\'un article ja són a punt per a fer-hi la correcció de proves final. Proporciona informació sobre l\'article i com accedir-hi.'),('PROOFREAD_LAYOUT_COMPLETE','ca_ES','Correcció de proves completada (maquetista)','Benvolgut/uda {$editorialContactName},\n\nHe acabat la correcció posterior a la correcció de proves de les galerades per al manuscrit \"{$articleTitle}\" per a {$journalName}. Així, doncs, aquest article ja es pot publicar.\n\n{$layoutEditorName}','Aquest missatge de correu electrònic té el maquetista com a remitent i s\'envia a l\'editor de secció per a notificar-li que s\'ha completat l\'etapa final del procés de correcció de proves i que l\'article ja es pot publicar.'),('PROOFREAD_LAYOUT_ACK','ca_ES','Justificant de recepció de la correcció de proves (maquetista)','Benvolgut/uda {$layoutEditorName},\n\nGràcies per haver completat el procés de correcció de proves per a les galerades associades amb el manuscrit \"{$articleTitle}\" per a {$journalName}. La vostra tasca és una contribució molt important a la qualitat d\'aquesta revista.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic té l\'editor de secció com a remitent i s\'envia al maquetista per a notificar-li que ha completat l\'etapa final de la correcció de proves i agrair-li la seva contribució.'),('EMAIL_LINK','ca_ES','Article que us pot interessar','Considero que us pot interessar llegir l\'article \"{$articleTitle}\" de {$authorName} publicat en el volum {$volume}, número {$number} ({$year}) de {$journalName}. El podeu consultar a \"{$articleUrl}\".','Aquesta plantilla de missatge de correu electrònic ofereix als lectors registrats l\'oportunitat d\'enviar informació sobre un article a algú que hi pugui estar interessat. Aquesta plantilla està disponible a les eines de lectura si l\'administrador de la revista l\'ha habilitada a la pàgina d\'administració d\'aquestes eines.'),('SUBSCRIPTION_NOTIFY','ca_ES','Notificació de subscripció','Benvolgut/uda {$subscriberName},\n\nUs acabeu de registrar com a subscriptor del nostre sistema de gestió de revistes en línia per a {$journalName} amb la subscripció següent:\n\n{$subscriptionType}\n\nPer a accedir als continguts que només estan disponibles per als subscriptors, inicieu la sessió al sistema amb el vostre nom d\'usuari, \"{$username}\".\n\nUna vegada dins el sistema podreu canviar la contrasenya i els detalls del vostre perfil en qualsevol moment.\n\nNoteu que si disposeu d\'una subscripció institucional, els usuaris membres de la institució no hauran d\'iniciar la sessió, ja que el sistema autenticarà automàticament les sol·licituds d\'accés al contingut per a subscriptors.\n\nSi teniu qualsevol consulta, no dubteu a fer-me-la arribar.\n\n{$subscriptionContactSignature}','Aquest missatge de correu electrònic notifica a un lector que l\'administrador l\'ha subscrit al sistema. Proporciona l\'URL de la revista i també instruccions per a accedir-hi.'),('OPEN_ACCESS_NOTIFY','ca_ES','Ara el número és d\'accés obert','Benvolguts lectors,\n\n{$journalName} acaba de publicar en format d\'accés obert el número següent. Us convidem a consultar-ne el sumari adjunt i a visitar el nostre lloc web ({$journalUrl}) per a accedir als articles que us interessin.\n\nUs agraïm el vostre interès per la nostra revista.\n\n{$editorialContactSignature}','Aquest missatge de correu electrònic s\'envia als lectors que han sol·licitat rebre una notificació per correu electrònic quan es publiqui un número en format d\'accés obert.'),('SUBSCRIPTION_BEFORE_EXPIRY','ca_ES','Avís de venciment de la subscripció','Benvolgut/uda {$subscriberName},\n\nLa vostra subscripció per a {$journalName} és a punt de vèncer.\n\n{$subscriptionType}\nData de venciment: {$expiryDate}\n\nPer a assegurar-vos que seguireu tenint accés a aquesta revista, entreu al lloc web i renoveu la vostra subscripció. Podeu iniciar la sessió al sistema amb el vostre nom d\'usuari, \"{$username}\".\n\nSi teniu cap consulta, no dubteu a fer-me-la arribar.\n\n{$subscriptionContactSignature}','Aquest missatge de correu electrònic notifica a un subscriptor que la seva subscripció és a punt de vèncer. Proporciona l\'URL de la revista i instruccions per a accedir-hi.'),('SUBSCRIPTION_AFTER_EXPIRY','ca_ES','La subscripció ha vençut','Benvolgut/uda {$subscriberName},\n\nLa vostra subscripció per a {$journalName} ha vençut.\n\n{$subscriptionType}\nData de venciment: {$expiryDate}\n\nPer a renovar la subscripció, aneu al lloc web de la revista. Podeu iniciar la sessió al sistema amb el vostre nom d\'usuari, \"{$username}\".\n\nSi teniu qualsevol consulta, no dubteu a fer-me-la arribar.\n\n{$subscriptionContactSignature}','Aquest missatge de correu electrònic notifica a un subscriptor que la seva subscripció ha vençut. Proporciona l\'URL de la revista i també instruccions per a accedir-hi.'),('SUBSCRIPTION_AFTER_EXPIRY_LAST','ca_ES','La subscripció ha vençut (últim recordatori)','Benvolgut/uda {$subscriberName},\n\nLa vostra subscripció per a {$journalName} ha vençut.\nTingueu en compte que aquest missatge és el darrer recordatori que rebreu.\n\n{$subscriptionType}\nData de venciment: {$expiryDate}\n\nPer a renovar la subscripció, aneu al lloc web de la revista. Podeu iniciar la sessió al sistema amb el vostre nom d\'usuari, \"{$username}\".\n\nSi teniu qualsevol consulta, no dubteu a fer-me-la arribar.\n\n{$subscriptionContactSignature}','Aquest missatge de correu electrònic notifica a un subscriptor que la seva subscripció ha vençut. Proporciona l\'URL de la revista i també instruccions per a accedir-hi.'),('BFR_REVIEW_REMINDER','en_US','Book for Review: Due Date Reminder','Dear {$authorName}:\n\nThis is a friendly reminder that your book review of {$bookForReviewTitle} is due {$bookForReviewDueDate}.\n\nTo submit your book review, please log into the journal website and complete the online article submission process. For your convenience, a submission URL has been provided below.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\nThank you for your contribution to the journal and I look forward to receiving your submission.\n\n{$editorialContactSignature}','This is an automatically generated email that is sent to a book for review author as a reminder that the due date for the review is approaching.'),('BFR_REVIEW_REMINDER_LATE','en_US','Book for Review: Review Due','Dear {$authorName}:\n\nThis is a friendly reminder that your book review of {$bookForReviewTitle} was due {$bookForReviewDueDate} but has not been received yet.\n\nTo submit your book review, please log into the journal website and complete the online article submission process. For your convenience, a submission URL has been provided below.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\nThank you for your contribution to the journal and I look forward to receiving your submission.\n\n{$editorialContactSignature}','This is an automatically generated email that is sent to a book for review author after the review due date has passed.'),('BFR_BOOK_ASSIGNED','en_US','Book for Review: Book Assigned','Dear {$authorName}:\n\nThis email confirms that {$bookForReviewTitle} has been assigned to you for a book review to be completed by {$bookForReviewDueDate}.\n\nPlease ensure that your mailing address in your online user profile is up-to-date. This address will be used to mail a copy of the book to you for the review.\n\nThe mailing address that we currently have on file is:\n{$authorMailingAddress}\n\nIf this address is incomplete or you are no longer at this address, please use the following user profile URL to update your address:\n\nUser Profile URL: {$userProfileUrl}\n \nTo submit your book review, please log into the journal website and complete the online article submission process.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\n{$editorialContactSignature}','This email is sent by an editor to a book review author when an editor assigns the book for review to the author.'),('BFR_BOOK_DENIED','en_US','Book for Review','Dear {$authorName}:\n\nUnfortunately, I am not able to assign {$bookForReviewTitle} to you at this time for a book review.\n\nI hope you consider reviewing another book from our listing, either at this time or in the future.\n\n{$editorialContactSignature}','This email is sent by an editor to an interested author when a book is no longer available for review.'),('BFR_BOOK_REQUESTED','en_US','Book for Review: Book Requested','Dear {$editorName}:\n\nI am interested in writing a book review of {$bookForReviewTitle}.\n\nCan you please confirm whether this book is still available for review?\n\n{$authorContactSignature}','This email is sent to an editor by an author interested in writing a book review for a listed book.'),('BFR_BOOK_MAILED','en_US','Book for Review: Book Mailed','Dear {$authorName}:\n\nThis email confirms that I have mailed a copy of {$bookForReviewTitle} to the following mailing address from your online user profile:\n{$authorMailingAddress}\n \nTo submit your book review, please log into the journal website and complete the online article submission process.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\n{$editorialContactSignature}','This email is sent by an editor to a book review author when the editor has mailed a copy of the book to the author.'),('BFR_REVIEWER_REMOVED','en_US','Book for Review','Dear {$authorName}:\n\nThis email confirms that you have been removed as the book reviewer for {$bookForReviewTitle}, which will be made available to other authors interested in reviewing the book.\n\nI hope you consider reviewing another book from our listing, either at this time or in the future.\n\n{$editorialContactSignature}','This email is sent by an editor to an interested author when a book is no longer available for review.'),('BFR_REVIEW_REMINDER','es_ES','Petición de Revisión: Recordatorio Fecha de vencimiento','Estimado {$authorName}:\n\nEste es un recordatorio de que su reseña del libro {$bookForReviewTitle}  se debe realizar hacer antes de la fecha {$bookForReviewDueDate}.\n\nPara enviar su reseña del libro, inicie sesión en la Web de la revista y complete el proceso de envío de revisión en línea. Para su conveniencia, un enlace directo se proporciona a continuación:\n\nURL Presentación: {$submissionUrl}\n\nPor favor, no dude en ponerse en contacto conmigo si tiene alguna pregunta o inquietud sobre esta reseña del libro.\n\nGracias por su contribución a la revista y espero con interés recibir su envío.\n\n{$editorialContactSignature}','Este es un mensaje generado automáticamente que se envía al autor de la revisión de un libro como un recordatorio de que la fecha de su vencimiento se acerca.'),('BFR_REVIEW_REMINDER_LATE','es_ES','Petición de Revisión: Recordatorio Fecha de vencimiento','Estimado  {$authorName}:\n\nEste es un recordatorio de que su reseña del libro {$bookForReviewTitle} se debió hacer para la fecha {$bookForReviewDueDate} pero no se ha recibido todavía.\n\nPara enviar su reseña del libro, por favor, inicie sesión en el Web site del diario y complete el proceso de envío de revisión en línea. Para su conveniencia, un enlace directo se proporciona a continuación:\n\nURL Presentación: {$submissionUrl}\n\nPor favor, no dude en ponerse en contacto conmigo si tiene alguna pregunta o inquietud sobre esta reseña del libro.\n\nGracias por su contribución a la revista y espero con interés recibir su envío.\n\n{$editorialContactSignature}','Este es un mensaje generado automáticamente que se envía a un autor de una revisión después de que la revisión ha llegado a la fecha de vencimiento.'),('BFR_BOOK_ASSIGNED','es_ES','Petición de revisión: Petición asignada','Estimado  {$authorName}:\n\nEste mensaje confirma que {$bookForReviewTitle} se ha asignado a usted para una revisión que debe ser completada antes de {$bookForReviewDueDate}.\n\nAsegúrese de que su dirección de correo en su perfil de usuario está al día. Esta dirección se usará para enviar por correo una copia de la petición a usted para la revisión.\n\nLa dirección de correo que tenemos actualmente en el archivo es:\n{$authorMailingAddress}\n\nSi la dirección es incompleta o ya no está disponible, por favor use la siguiente URL  para actualizar su dirección en su perfil de usuario:\n\nPerfil del usuario URL: {$userProfileUrl}\n \nPara enviar su reseña, por favor, inicie sesión en el Web de la revista y complete el proceso de envío de artículos en línea.\n\nURL: {$submissionUrl}\n\nPor favor, no dude en ponerse en contacto conmigo si tiene alguna pregunta o inquietud sobre esta petición de revisión.\n\n{$editorialContactSignature}','Este correo electrónico es enviado por un editor a un autor de revisión cuando un editor le asigna la petición de revisión al autor.'),('BFR_BOOK_DENIED','es_ES','Petición de revisión','Estimado {$authorName}:\n\nDesafortunadamente, no puedo asignarle en este momento la petición {$bookForReviewTitle}.\n\nEspero que considere la revisión de otra petición de nuestra lista, ya sea en este momento o en el futuro.\n\n{$editorialContactSignature}','Este correo electrónico es enviado por un editor a un autor interesado cuando una petición ya no está disponible para su revisión.'),('BFR_BOOK_REQUESTED','es_ES','Petición de Revisión: Petición solicitada','Estimado {$editorName}:\n\nEstoy interesado en escribir la reseña  {$bookForReviewTitle}.\n\n¿Puede usted confirmar si aún está disponible para su revisión?\n\n{$authorContactSignature}','Este correo electrónico se envía por un autor interesado en escribir una reseña de la lista de peticiones a un editor.'),('BFR_BOOK_MAILED','es_ES','Petición de revisión: Petición enviada','Estimado {$authorName}:\n\nEste mensaje confirma que he enviado {$bookForReviewTitle} a la siguiente dirección de su perfil de usuario :\n{$authorMailingAddress}\n \nPara enviar su reseña, por favor, inicie sesión en la Web de la Revista y complete el proceso de envío:\n\nURL: {$submissionUrl}\n\nPor favor, no dude en ponerse en contacto conmigo si tiene alguna pregunta o inquietud sobre esta reseña.\n\n{$editorialContactSignature}','Este correo electrónico es enviado por un editor para el autor de una revisión cuando el editor ha enviado por correo una petición autor.'),('BFR_REVIEWER_REMOVED','es_ES','Petición de revisión','Estimado {$authorName}:\n\nEste mensaje confirma que ha sido eliminado como revisor de {$bookForReviewTitle}, que se pondrá a disposición de otros autores interesados en hace la revisión.\n\nEspero que considere realizar otra revisión de nuestra lista, ya sea en este momento o en el futuro.\n\n{$editorialContactSignature}','Este correo electrónico es enviado por un editor a un autor interesado cuando una petición ya no está disponible para su revisión.'),('THESIS_ABSTRACT_CONFIRM','en_US','Thesis Abstract Submission','This email was automatically generated by the {$journalName} thesis abstract submission form.\n\nPlease confirm that the submitted information is correct. Upon receiving your confirmation, the abstract will be published in the online edition of the journal.\n\nSimply reply to {$thesisName} ({$thesisEmail}) with the contents of this message and your confirmation, as well as any recommended clarifications or corrections.\n\nThank you.\n\n\nTitle : {$title} \nAuthor : {$studentName}\nDegree : {$degree}\nDegree Name: {$degreeName}\nDepartment : {$department}\nUniversity : {$university}\nAcceptance Date : {$dateApproved}\nSupervisor : {$supervisorName}\n\nAbstract\n--------\n{$abstract}\n\n{$thesisContactSignature}','This email template is used to confirm a thesis abstract submission by a student. It is sent to the student\'s supervisor, who is asked to confirm the details of the submitted thesis abstract.'),('THESIS_ABSTRACT_CONFIRM','es_ES','Presentación de resúmen de Tesis','Este correo fué generado automáticamente por el formulario de envío de resúmenes de tesis de {$journalName} \n\nPor favor, confirme que la información enviada es correcta. Tras recibir su confirmación, el resúmen será publicado en la edición online de la revista.\n\nSimplemente responda a {$thesisName} ({$thesisEmail}) con el contenido de este mensaje y tu confirmación, así como cualquier clarificación o corrección recomendada.\n\nGracias.\n\n\nTítulo : {$title} \nAutor : {$studentName}\nTítulo : {$degree}\nNombre del Título: {$degreeName}\nDepartamento : {$department}\nUniversidad : {$university}\nFecha de Aceptación : {$dateApproved}\nSupervisor : {$supervisorName}\n\nResúmen\n--------\n{$abstract}\n\n{$thesisContactSignature}','Esta plantilla de correo se usa para confirmar un envío de un resúmen de una tesis por un investigador. Se envía al supervisor del investigador, a quien se le pide que confirme los detalles del resúmen de tesis enviado.'),('SWORD_DEPOSIT_NOTIFICATION','en_US','Deposit Notification','Congratulations on the acceptance of your submission, \"{$articleTitle}\", for publication in {$journalName}. If you choose, you may automatically deposit your submission in one or more repositories.\n\nGo to {$swordDepositUrl} to proceed.\n\nThis email was generated by Open Journal Systems\' SWORD deposit plugin.','This email template is used to notify an author of optional deposit points for SWORD deposits.'),('SWORD_DEPOSIT_NOTIFICATION','es_ES','Notificación de depósito','Enhorabuena por la aceptación de su presentación, \"($ articleTitle)\", para su publicación en {$journalName}. Si lo desea, puede depositar de forma automática su presentación en uno o varios repositorios.\n\nVaya a {$swordDepositUrl} para proceder.\n\nEste correo electrónico fue generado por Open Journal Systems\' SWORD deposit plugin.','Esta plantilla de correo electrónico se utiliza para notificar a un autor de puntos opcionales de depósito para los depósitos SWORD.'),('MANUAL_PAYMENT_NOTIFICATION','en_US','Manual Payment Notification','A manual payment needs to be processed for the journal {$journalName} and the user {$userFullName} (username \"{$userName}\").\n\nThe item being paid for is \"{$itemName}\".\nThe cost is {$itemCost} ({$itemCurrencyCode}).\n\nThis email was generated by Open Journal Systems\' Manual Payment plugin.','This email template is used to notify a journal manager contact that a manual payment was requested.'),('MANUAL_PAYMENT_NOTIFICATION','es_ES','Notificación de Pago Manual','Un pago manual necesita ser procesado para la revista  {$journalName} y el usuario {$userFullName} (username \"{$userName}\").\n\nEl ítem pagado es \"{$itemName}\".\nEl precio es {$itemCost} ({$itemCurrencyCode}).\n\nEste correo ha sido generado por el plugin de Pago Manual de  Open Journal Systems.','Este correo se usa para notificar al Gestor de la Revista de que se ha realizado un pago manual.'),('PAYPAL_INVESTIGATE_PAYMENT','en_US','Unusual PayPal Activity','Open Journal Systems has encountered unusual activity relating to PayPal payment support for the journal {$journalName}. This activity may need further investigation or manual intervention.\n                       \nThis email was generated by Open Journal Systems\' PayPal plugin.\n\nFull post information for the request:\n{$postInfo}\n\nAdditional information (if supplied):\n{$additionalInfo}\n\nServer vars:\n{$serverVars}\n','This email template is used to notify a journal\'s primary contact that suspicious activity or activity requiring manual intervention was encountered by the PayPal plugin.'),('PAYPAL_INVESTIGATE_PAYMENT','es_ES','Actividad inusual de PayPal','Open Journal Systems ha notado una actividad inusual relacionada con el soporte de pago de PayPal para la revista {$journalName}.  Esta actividad puede necesitar de mayor investigación o intervención manual.\n\nEste email ha sido generado por el plugin de PayPal de Open Journal Systems.\n\nInformación completa de envío para la solicitud:\n{$postInfo}\n\nInformación adicional (si proporcionada):\n{$additionalInfo}\n\nVariables de servidor:\n{$serverVars}','Esta plantilla de correo es usada para notificar al contacto principal de la revista de que el plugin de PayPal ha detectado actividad sospechosa o actividad que requiere de intervención manual.');
/*!40000 ALTER TABLE `email_templates_default_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `external_feed_settings`
--

DROP TABLE IF EXISTS `external_feed_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `external_feed_settings` (
  `feed_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `external_feed_settings_pkey` (`feed_id`,`locale`,`setting_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `external_feed_settings`
--

LOCK TABLES `external_feed_settings` WRITE;
/*!40000 ALTER TABLE `external_feed_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `external_feed_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `external_feeds`
--

DROP TABLE IF EXISTS `external_feeds`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `external_feeds` (
  `feed_id` bigint(20) NOT NULL auto_increment,
  `journal_id` bigint(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `seq` double NOT NULL default '0',
  `display_homepage` tinyint(4) NOT NULL default '0',
  `display_block` smallint(6) NOT NULL default '0',
  `limit_items` tinyint(4) default '0',
  `recent_items` smallint(6) default NULL,
  PRIMARY KEY  (`feed_id`),
  KEY `external_feeds_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `external_feeds`
--

LOCK TABLES `external_feeds` WRITE;
/*!40000 ALTER TABLE `external_feeds` DISABLE KEYS */;
/*!40000 ALTER TABLE `external_feeds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filter_settings`
--

DROP TABLE IF EXISTS `filter_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `filter_settings` (
  `filter_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `filter_settings_pkey` (`filter_id`,`locale`,`setting_name`),
  KEY `filter_settings_id` (`filter_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `filter_settings`
--

LOCK TABLES `filter_settings` WRITE;
/*!40000 ALTER TABLE `filter_settings` DISABLE KEYS */;
INSERT INTO `filter_settings` VALUES (1,'','phpVersionMin','5.0.0','string'),(2,'','phpVersionMin','5.0.0','string'),(3,'','phpVersionMin','5.0.0','string'),(4,'','phpVersionMin','5.0.0','string'),(5,'','citationModule','Standard','string'),(5,'','phpVersionMin','5.0.0','string'),(6,'','phpVersionMin','5.0.0','string'),(7,'','phpVersionMin','5.0.0','string'),(9,'','citationOutputFilterName','lib.pkp.classes.citation.output.abnt.NlmCitationSchemaAbntFilter','string'),(9,'','ordering','2','int'),(11,'','citationOutputFilterName','lib.pkp.classes.citation.output.apa.NlmCitationSchemaApaFilter','string'),(11,'','ordering','2','int'),(13,'','citationOutputFilterName','lib.pkp.classes.citation.output.mla.NlmCitationSchemaMlaFilter','string'),(13,'','ordering','2','int'),(15,'','citationOutputFilterName','lib.pkp.classes.citation.output.vancouver.NlmCitationSchemaVancouverFilter','string'),(15,'','ordering','1','int'),(17,'','settingsMapping','a:2:{s:6:\"apiKey\";a:2:{i:0;s:11:\"seq1_apiKey\";i:1;s:11:\"seq2_apiKey\";}s:10:\"isOptional\";a:2:{i:0;s:15:\"seq1_isOptional\";i:1;s:15:\"seq2_isOptional\";}}','object'),(18,'','phpVersionMin','5.0.0','string'),(19,'','phpVersionMin','5.0.0','string'),(22,'','xsl','lib/pkp/classes/importexport/nlm/nlm-ref-list-30-to-23.xsl','string'),(22,'','xslType','2','int');
/*!40000 ALTER TABLE `filter_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filters`
--

DROP TABLE IF EXISTS `filters`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `filters` (
  `filter_id` bigint(20) NOT NULL auto_increment,
  `context_id` bigint(20) NOT NULL default '0',
  `display_name` varchar(255) default NULL,
  `class_name` varchar(255) default NULL,
  `input_type` varchar(255) default NULL,
  `output_type` varchar(255) default NULL,
  `is_template` tinyint(4) NOT NULL default '0',
  `parent_filter_id` bigint(20) NOT NULL default '0',
  `seq` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`filter_id`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `filters`
--

LOCK TABLES `filters` WRITE;
/*!40000 ALTER TABLE `filters` DISABLE KEYS */;
INSERT INTO `filters` VALUES (1,0,'CrossRef','lib.pkp.classes.citation.lookup.crossref.CrossrefNlmCitationSchemaFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',1,0,0),(2,0,'PubMed','lib.pkp.classes.citation.lookup.pubmed.PubmedNlmCitationSchemaFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',1,0,0),(3,0,'WorldCat','lib.pkp.classes.citation.lookup.worldcat.WorldcatNlmCitationSchemaFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',1,0,0),(4,0,'FreeCite','lib.pkp.classes.citation.parser.freecite.FreeciteRawCitationNlmCitationSchemaFilter','primitive::string','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',1,0,0),(5,0,'ParaCite','lib.pkp.classes.citation.parser.paracite.ParaciteRawCitationNlmCitationSchemaFilter','primitive::string','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',1,0,0),(6,0,'ParsCit','lib.pkp.classes.citation.parser.parscit.ParscitRawCitationNlmCitationSchemaFilter','primitive::string','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',1,0,0),(7,0,'RegEx','lib.pkp.classes.citation.parser.regex.RegexRawCitationNlmCitationSchemaFilter','primitive::string','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',1,0,0),(8,0,'ABNT Citation Output','lib.pkp.classes.citation.output.abnt.NlmCitationSchemaAbntFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','primitive::string',0,0,0),(9,0,'ABNT Citation Output','lib.pkp.classes.citation.output.PlainTextReferencesListFilter','class::lib.pkp.classes.submission.Submission','class::lib.pkp.classes.citation.PlainTextReferencesList',0,0,0),(10,0,'APA Citation Output','lib.pkp.classes.citation.output.apa.NlmCitationSchemaApaFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','primitive::string',0,0,0),(11,0,'APA Citation Output','lib.pkp.classes.citation.output.PlainTextReferencesListFilter','class::lib.pkp.classes.submission.Submission','class::lib.pkp.classes.citation.PlainTextReferencesList',0,0,0),(12,0,'MLA Citation Output','lib.pkp.classes.citation.output.mla.NlmCitationSchemaMlaFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','primitive::string',0,0,0),(13,0,'MLA Citation Output','lib.pkp.classes.citation.output.PlainTextReferencesListFilter','class::lib.pkp.classes.submission.Submission','class::lib.pkp.classes.citation.PlainTextReferencesList',0,0,0),(14,0,'Vancouver Citation Output','lib.pkp.classes.citation.output.vancouver.NlmCitationSchemaVancouverFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','primitive::string',0,0,0),(15,0,'Vancouver Citation Output','lib.pkp.classes.citation.output.PlainTextReferencesListFilter','class::lib.pkp.classes.submission.Submission','class::lib.pkp.classes.citation.PlainTextReferencesList',0,0,0),(16,0,'NLM Journal Publishing V3.0 ref-list','lib.pkp.classes.importexport.nlm.PKPSubmissionNlmXmlFilter','class::lib.pkp.classes.submission.Submission','xml::*',0,0,0),(17,0,'ISBNdb','lib.pkp.classes.filter.GenericSequencerFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',1,0,0),(18,0,'ISBNdb (from NLM)','lib.pkp.classes.citation.lookup.isbndb.IsbndbNlmCitationSchemaIsbnFilter','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)','primitive::string',0,17,1),(19,0,'ISBNdb','lib.pkp.classes.citation.lookup.isbndb.IsbndbIsbnNlmCitationSchemaFilter','primitive::string','metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)',0,17,2),(20,0,'NLM Journal Publishing V2.3 ref-list','lib.pkp.classes.filter.GenericSequencerFilter','class::lib.pkp.classes.submission.Submission','xml::*',0,0,0),(21,0,'NLM Journal Publishing V3.0 ref-list','lib.pkp.classes.importexport.nlm.PKPSubmissionNlmXmlFilter','class::lib.pkp.classes.submission.Submission','xml::*',0,20,1),(22,0,'NLM 3.0 to 2.3 ref-list downgrade','lib.pkp.classes.xslt.XSLTransformationFilter','xml::*','xml::*',0,20,2);
/*!40000 ALTER TABLE `filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_memberships`
--

DROP TABLE IF EXISTS `group_memberships`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `group_memberships` (
  `user_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `about_displayed` tinyint(4) NOT NULL default '1',
  `seq` double NOT NULL default '0',
  UNIQUE KEY `group_memberships_pkey` (`user_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `group_memberships`
--

LOCK TABLES `group_memberships` WRITE;
/*!40000 ALTER TABLE `group_memberships` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_memberships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_settings`
--

DROP TABLE IF EXISTS `group_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `group_settings` (
  `group_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `group_settings_pkey` (`group_id`,`locale`,`setting_name`),
  KEY `group_settings_group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `group_settings`
--

LOCK TABLES `group_settings` WRITE;
/*!40000 ALTER TABLE `group_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `groups` (
  `group_id` bigint(20) NOT NULL auto_increment,
  `assoc_type` smallint(6) default NULL,
  `publish_email` smallint(6) default NULL,
  `assoc_id` bigint(20) default NULL,
  `context` bigint(20) default NULL,
  `about_displayed` tinyint(4) NOT NULL default '0',
  `seq` double NOT NULL default '0',
  PRIMARY KEY  (`group_id`),
  KEY `groups_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `institutional_subscription_ip`
--

DROP TABLE IF EXISTS `institutional_subscription_ip`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `institutional_subscription_ip` (
  `institutional_subscription_ip_id` bigint(20) NOT NULL auto_increment,
  `subscription_id` bigint(20) NOT NULL,
  `ip_string` varchar(40) NOT NULL,
  `ip_start` bigint(20) NOT NULL,
  `ip_end` bigint(20) default NULL,
  PRIMARY KEY  (`institutional_subscription_ip_id`),
  KEY `institutional_subscription_ip_subscription_id` (`subscription_id`),
  KEY `institutional_subscription_ip_start` (`ip_start`),
  KEY `institutional_subscription_ip_end` (`ip_end`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `institutional_subscription_ip`
--

LOCK TABLES `institutional_subscription_ip` WRITE;
/*!40000 ALTER TABLE `institutional_subscription_ip` DISABLE KEYS */;
/*!40000 ALTER TABLE `institutional_subscription_ip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `institutional_subscriptions`
--

DROP TABLE IF EXISTS `institutional_subscriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `institutional_subscriptions` (
  `institutional_subscription_id` bigint(20) NOT NULL auto_increment,
  `subscription_id` bigint(20) NOT NULL,
  `institution_name` varchar(255) NOT NULL,
  `mailing_address` varchar(255) default NULL,
  `domain` varchar(255) default NULL,
  PRIMARY KEY  (`institutional_subscription_id`),
  KEY `institutional_subscriptions_subscription_id` (`subscription_id`),
  KEY `institutional_subscriptions_domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `institutional_subscriptions`
--

LOCK TABLES `institutional_subscriptions` WRITE;
/*!40000 ALTER TABLE `institutional_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `institutional_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_settings`
--

DROP TABLE IF EXISTS `issue_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `issue_settings` (
  `issue_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `issue_settings_pkey` (`issue_id`,`locale`,`setting_name`),
  KEY `issue_settings_issue_id` (`issue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `issue_settings`
--

LOCK TABLES `issue_settings` WRITE;
/*!40000 ALTER TABLE `issue_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issues`
--

DROP TABLE IF EXISTS `issues`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `issues` (
  `issue_id` bigint(20) NOT NULL auto_increment,
  `journal_id` bigint(20) NOT NULL,
  `volume` smallint(6) default NULL,
  `number` varchar(10) default NULL,
  `year` smallint(6) default NULL,
  `published` tinyint(4) NOT NULL default '0',
  `current` tinyint(4) NOT NULL default '0',
  `date_published` datetime default NULL,
  `date_notified` datetime default NULL,
  `access_status` tinyint(4) NOT NULL default '1',
  `open_access_date` datetime default NULL,
  `public_issue_id` varchar(255) default NULL,
  `show_volume` tinyint(4) NOT NULL default '0',
  `show_number` tinyint(4) NOT NULL default '0',
  `show_year` tinyint(4) NOT NULL default '0',
  `show_title` tinyint(4) NOT NULL default '0',
  `style_file_name` varchar(90) default NULL,
  `original_style_file_name` varchar(255) default NULL,
  PRIMARY KEY  (`issue_id`),
  UNIQUE KEY `issues_public_issue_id` (`public_issue_id`,`journal_id`),
  KEY `issues_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `issues`
--

LOCK TABLES `issues` WRITE;
/*!40000 ALTER TABLE `issues` DISABLE KEYS */;
/*!40000 ALTER TABLE `issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journal_settings`
--

DROP TABLE IF EXISTS `journal_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `journal_settings` (
  `journal_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `journal_settings_pkey` (`journal_id`,`locale`,`setting_name`),
  KEY `journal_settings_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `journal_settings`
--

LOCK TABLES `journal_settings` WRITE;
/*!40000 ALTER TABLE `journal_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `journal_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journals`
--

DROP TABLE IF EXISTS `journals`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `journals` (
  `journal_id` bigint(20) NOT NULL auto_increment,
  `path` varchar(32) NOT NULL,
  `seq` double NOT NULL default '0',
  `primary_locale` varchar(5) NOT NULL,
  `enabled` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`journal_id`),
  UNIQUE KEY `journals_path` (`path`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `journals`
--

LOCK TABLES `journals` WRITE;
/*!40000 ALTER TABLE `journals` DISABLE KEYS */;
/*!40000 ALTER TABLE `journals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata_description_settings`
--

DROP TABLE IF EXISTS `metadata_description_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `metadata_description_settings` (
  `metadata_description_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `metadata_descripton_settings_pkey` (`metadata_description_id`,`locale`,`setting_name`),
  KEY `metadata_description_settings_id` (`metadata_description_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `metadata_description_settings`
--

LOCK TABLES `metadata_description_settings` WRITE;
/*!40000 ALTER TABLE `metadata_description_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `metadata_description_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata_descriptions`
--

DROP TABLE IF EXISTS `metadata_descriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `metadata_descriptions` (
  `metadata_description_id` bigint(20) NOT NULL auto_increment,
  `assoc_type` bigint(20) NOT NULL default '0',
  `assoc_id` bigint(20) NOT NULL default '0',
  `schema_namespace` varchar(255) NOT NULL,
  `schema_name` varchar(255) NOT NULL,
  `display_name` varchar(255) default NULL,
  `seq` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`metadata_description_id`),
  KEY `metadata_descriptions_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `metadata_descriptions`
--

LOCK TABLES `metadata_descriptions` WRITE;
/*!40000 ALTER TABLE `metadata_descriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `metadata_descriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `notes` (
  `note_id` bigint(20) NOT NULL auto_increment,
  `assoc_type` smallint(6) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime default NULL,
  `title` varchar(255) default NULL,
  `file_id` bigint(20) default NULL,
  `context_id` bigint(20) default NULL,
  `contents` text,
  PRIMARY KEY  (`note_id`),
  KEY `notes_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_settings`
--

DROP TABLE IF EXISTS `notification_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `notification_settings` (
  `setting_id` bigint(20) NOT NULL auto_increment,
  `setting_name` varchar(64) NOT NULL,
  `setting_value` text,
  `user_id` bigint(20) NOT NULL,
  `product` varchar(20) default NULL,
  `context` bigint(20) NOT NULL,
  PRIMARY KEY  (`setting_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `notification_settings`
--

LOCK TABLES `notification_settings` WRITE;
/*!40000 ALTER TABLE `notification_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `notifications` (
  `notification_id` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) NOT NULL,
  `level` bigint(20) default NULL,
  `date_created` datetime NOT NULL,
  `date_read` datetime default NULL,
  `title` varchar(255) default NULL,
  `contents` text,
  `param` varchar(255) default NULL,
  `location` varchar(255) default NULL,
  `is_localized` tinyint(4) NOT NULL default '1',
  `product` varchar(20) default NULL,
  `context` bigint(20) NOT NULL,
  `assoc_type` bigint(20) NOT NULL,
  PRIMARY KEY  (`notification_id`),
  KEY `notifications_by_user` (`product`,`user_id`,`level`,`context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oai_resumption_tokens`
--

DROP TABLE IF EXISTS `oai_resumption_tokens`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `oai_resumption_tokens` (
  `token` varchar(32) NOT NULL,
  `expire` bigint(20) NOT NULL,
  `record_offset` int(11) NOT NULL,
  `params` text,
  UNIQUE KEY `oai_resumption_tokens_pkey` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `oai_resumption_tokens`
--

LOCK TABLES `oai_resumption_tokens` WRITE;
/*!40000 ALTER TABLE `oai_resumption_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `oai_resumption_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paypal_transactions`
--

DROP TABLE IF EXISTS `paypal_transactions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `paypal_transactions` (
  `txn_id` varchar(17) NOT NULL,
  `txn_type` varchar(20) default NULL,
  `payer_email` varchar(127) default NULL,
  `receiver_email` varchar(127) default NULL,
  `item_number` varchar(127) default NULL,
  `payment_date` varchar(127) default NULL,
  `payer_id` varchar(13) default NULL,
  `receiver_id` varchar(13) default NULL,
  PRIMARY KEY  (`txn_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `paypal_transactions`
--

LOCK TABLES `paypal_transactions` WRITE;
/*!40000 ALTER TABLE `paypal_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `paypal_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_settings`
--

DROP TABLE IF EXISTS `plugin_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `plugin_settings` (
  `plugin_name` varchar(80) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `journal_id` bigint(20) NOT NULL,
  `setting_name` varchar(80) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `plugin_settings_pkey` (`plugin_name`,`locale`,`journal_id`,`setting_name`),
  KEY `plugin_settings_plugin_name` (`plugin_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `plugin_settings`
--

LOCK TABLES `plugin_settings` WRITE;
/*!40000 ALTER TABLE `plugin_settings` DISABLE KEYS */;
INSERT INTO `plugin_settings` VALUES ('tinymceplugin','',0,'enabled','1','bool'),('coinsplugin','',0,'enabled','1','bool'),('helpblockplugin','',0,'enabled','1','bool'),('helpblockplugin','',0,'seq','1','int'),('helpblockplugin','',0,'context','2','int'),('donationblockplugin','',0,'enabled','1','bool'),('donationblockplugin','',0,'seq','5','int'),('donationblockplugin','',0,'context','2','int'),('navigationblockplugin','',0,'enabled','1','bool'),('navigationblockplugin','',0,'seq','5','int'),('navigationblockplugin','',0,'context','2','int'),('userblockplugin','',0,'enabled','1','bool'),('userblockplugin','',0,'seq','2','int'),('userblockplugin','',0,'context','2','int'),('notificationblockplugin','',0,'enabled','1','bool'),('notificationblockplugin','',0,'seq','3','int'),('notificationblockplugin','',0,'context','2','int'),('developedbyblockplugin','',0,'enabled','1','bool'),('developedbyblockplugin','',0,'seq','0','int'),('developedbyblockplugin','',0,'context','2','int'),('languagetoggleblockplugin','',0,'enabled','1','bool'),('languagetoggleblockplugin','',0,'seq','4','int'),('languagetoggleblockplugin','',0,'context','2','int'),('fontsizeblockplugin','',0,'enabled','1','bool'),('fontsizeblockplugin','',0,'seq','6','int'),('fontsizeblockplugin','',0,'context','2','int');
/*!40000 ALTER TABLE `plugin_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `processes`
--

DROP TABLE IF EXISTS `processes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `processes` (
  `process_id` varchar(23) NOT NULL,
  `process_type` tinyint(4) NOT NULL,
  `time_started` bigint(20) NOT NULL,
  `obliterated` tinyint(4) NOT NULL default '0',
  UNIQUE KEY `processes_pkey` (`process_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `processes`
--

LOCK TABLES `processes` WRITE;
/*!40000 ALTER TABLE `processes` DISABLE KEYS */;
/*!40000 ALTER TABLE `processes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `published_articles`
--

DROP TABLE IF EXISTS `published_articles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `published_articles` (
  `pub_id` bigint(20) NOT NULL auto_increment,
  `article_id` bigint(20) NOT NULL,
  `issue_id` bigint(20) NOT NULL,
  `date_published` datetime NOT NULL,
  `seq` double NOT NULL default '0',
  `views` int(11) NOT NULL default '0',
  `access_status` tinyint(4) NOT NULL default '0',
  `public_article_id` varchar(255) default NULL,
  PRIMARY KEY  (`pub_id`),
  UNIQUE KEY `published_articles_article_id` (`article_id`),
  KEY `published_articles_issue_id` (`issue_id`),
  KEY `published_articles_public_article_id` (`public_article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `published_articles`
--

LOCK TABLES `published_articles` WRITE;
/*!40000 ALTER TABLE `published_articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `published_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queued_payments`
--

DROP TABLE IF EXISTS `queued_payments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `queued_payments` (
  `queued_payment_id` bigint(20) NOT NULL auto_increment,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `expiry_date` date default NULL,
  `payment_data` text,
  PRIMARY KEY  (`queued_payment_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `queued_payments`
--

LOCK TABLES `queued_payments` WRITE;
/*!40000 ALTER TABLE `queued_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `queued_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referral_settings`
--

DROP TABLE IF EXISTS `referral_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `referral_settings` (
  `referral_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `referral_settings_pkey` (`referral_id`,`locale`,`setting_name`),
  KEY `referral_settings_referral_id` (`referral_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `referral_settings`
--

LOCK TABLES `referral_settings` WRITE;
/*!40000 ALTER TABLE `referral_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `referral_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referrals`
--

DROP TABLE IF EXISTS `referrals`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `referrals` (
  `referral_id` bigint(20) NOT NULL auto_increment,
  `article_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `url` varchar(255) NOT NULL,
  `date_added` datetime NOT NULL,
  `link_count` bigint(20) NOT NULL,
  PRIMARY KEY  (`referral_id`),
  UNIQUE KEY `referral_article_id` (`article_id`,`url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `referrals`
--

LOCK TABLES `referrals` WRITE;
/*!40000 ALTER TABLE `referrals` DISABLE KEYS */;
/*!40000 ALTER TABLE `referrals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_assignments`
--

DROP TABLE IF EXISTS `review_assignments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `review_assignments` (
  `review_id` bigint(20) NOT NULL auto_increment,
  `submission_id` bigint(20) NOT NULL,
  `reviewer_id` bigint(20) NOT NULL,
  `competing_interests` text,
  `regret_message` text,
  `recommendation` tinyint(4) default NULL,
  `date_assigned` datetime default NULL,
  `date_notified` datetime default NULL,
  `date_confirmed` datetime default NULL,
  `date_completed` datetime default NULL,
  `date_acknowledged` datetime default NULL,
  `date_due` datetime default NULL,
  `date_response_due` datetime default NULL,
  `last_modified` datetime default NULL,
  `reminder_was_automatic` tinyint(4) NOT NULL default '0',
  `declined` tinyint(4) NOT NULL default '0',
  `replaced` tinyint(4) NOT NULL default '0',
  `cancelled` tinyint(4) NOT NULL default '0',
  `reviewer_file_id` bigint(20) default NULL,
  `date_rated` datetime default NULL,
  `date_reminded` datetime default NULL,
  `quality` tinyint(4) default NULL,
  `review_type` tinyint(4) NOT NULL default '1',
  `review_method` tinyint(4) NOT NULL default '1',
  `round` tinyint(4) NOT NULL default '1',
  `step` tinyint(4) NOT NULL default '1',
  `review_form_id` bigint(20) default NULL,
  PRIMARY KEY  (`review_id`),
  KEY `review_assignments_submission_id` (`submission_id`),
  KEY `review_assignments_reviewer_id` (`reviewer_id`),
  KEY `review_assignments_form_id` (`review_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `review_assignments`
--

LOCK TABLES `review_assignments` WRITE;
/*!40000 ALTER TABLE `review_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_form_element_settings`
--

DROP TABLE IF EXISTS `review_form_element_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `review_form_element_settings` (
  `review_form_element_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `review_form_element_settings_pkey` (`review_form_element_id`,`locale`,`setting_name`),
  KEY `review_form_element_settings_review_form_element_id` (`review_form_element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `review_form_element_settings`
--

LOCK TABLES `review_form_element_settings` WRITE;
/*!40000 ALTER TABLE `review_form_element_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_form_element_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_form_elements`
--

DROP TABLE IF EXISTS `review_form_elements`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `review_form_elements` (
  `review_form_element_id` bigint(20) NOT NULL auto_increment,
  `review_form_id` bigint(20) NOT NULL,
  `seq` double default NULL,
  `element_type` bigint(20) default NULL,
  `required` tinyint(4) default NULL,
  `included` tinyint(4) default NULL,
  PRIMARY KEY  (`review_form_element_id`),
  KEY `review_form_elements_review_form_id` (`review_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `review_form_elements`
--

LOCK TABLES `review_form_elements` WRITE;
/*!40000 ALTER TABLE `review_form_elements` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_form_elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_form_responses`
--

DROP TABLE IF EXISTS `review_form_responses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `review_form_responses` (
  `review_form_element_id` bigint(20) NOT NULL,
  `review_id` bigint(20) NOT NULL,
  `response_type` varchar(6) default NULL,
  `response_value` text,
  KEY `review_form_responses_pkey` (`review_form_element_id`,`review_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `review_form_responses`
--

LOCK TABLES `review_form_responses` WRITE;
/*!40000 ALTER TABLE `review_form_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_form_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_form_settings`
--

DROP TABLE IF EXISTS `review_form_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `review_form_settings` (
  `review_form_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `review_form_settings_pkey` (`review_form_id`,`locale`,`setting_name`),
  KEY `review_form_settings_review_form_id` (`review_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `review_form_settings`
--

LOCK TABLES `review_form_settings` WRITE;
/*!40000 ALTER TABLE `review_form_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_form_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_forms`
--

DROP TABLE IF EXISTS `review_forms`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `review_forms` (
  `review_form_id` bigint(20) NOT NULL auto_increment,
  `assoc_type` bigint(20) NOT NULL default '0',
  `assoc_id` bigint(20) NOT NULL default '0',
  `seq` double default NULL,
  `is_active` tinyint(4) default NULL,
  PRIMARY KEY  (`review_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `review_forms`
--

LOCK TABLES `review_forms` WRITE;
/*!40000 ALTER TABLE `review_forms` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_forms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_rounds`
--

DROP TABLE IF EXISTS `review_rounds`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `review_rounds` (
  `submission_id` bigint(20) NOT NULL,
  `round` tinyint(4) NOT NULL,
  `review_revision` bigint(20) default NULL,
  `review_type` bigint(20) default NULL,
  `status` bigint(20) default NULL,
  UNIQUE KEY `review_rounds_pkey` (`submission_id`,`round`,`review_type`),
  KEY `review_rounds_submission_id` (`submission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `review_rounds`
--

LOCK TABLES `review_rounds` WRITE;
/*!40000 ALTER TABLE `review_rounds` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_rounds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles` (
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  UNIQUE KEY `roles_pkey` (`journal_id`,`user_id`,`role_id`),
  KEY `roles_journal_id` (`journal_id`),
  KEY `roles_user_id` (`user_id`),
  KEY `roles_role_id` (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (0,1,1);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rt_contexts`
--

DROP TABLE IF EXISTS `rt_contexts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rt_contexts` (
  `context_id` bigint(20) NOT NULL auto_increment,
  `version_id` bigint(20) NOT NULL,
  `title` varchar(120) NOT NULL,
  `abbrev` varchar(32) NOT NULL,
  `description` text,
  `cited_by` tinyint(4) NOT NULL default '0',
  `author_terms` tinyint(4) NOT NULL default '0',
  `define_terms` tinyint(4) NOT NULL default '0',
  `geo_terms` tinyint(4) NOT NULL default '0',
  `seq` double NOT NULL default '0',
  PRIMARY KEY  (`context_id`),
  KEY `rt_contexts_version_id` (`version_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `rt_contexts`
--

LOCK TABLES `rt_contexts` WRITE;
/*!40000 ALTER TABLE `rt_contexts` DISABLE KEYS */;
/*!40000 ALTER TABLE `rt_contexts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rt_searches`
--

DROP TABLE IF EXISTS `rt_searches`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rt_searches` (
  `search_id` bigint(20) NOT NULL auto_increment,
  `context_id` bigint(20) NOT NULL,
  `title` varchar(120) NOT NULL,
  `description` text,
  `url` text,
  `search_url` text,
  `search_post` text,
  `seq` double NOT NULL default '0',
  PRIMARY KEY  (`search_id`),
  KEY `rt_searches_context_id` (`context_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `rt_searches`
--

LOCK TABLES `rt_searches` WRITE;
/*!40000 ALTER TABLE `rt_searches` DISABLE KEYS */;
/*!40000 ALTER TABLE `rt_searches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rt_versions`
--

DROP TABLE IF EXISTS `rt_versions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rt_versions` (
  `version_id` bigint(20) NOT NULL auto_increment,
  `journal_id` bigint(20) NOT NULL,
  `version_key` varchar(40) NOT NULL,
  `locale` varchar(5) default 'en_US',
  `title` varchar(120) NOT NULL,
  `description` text,
  PRIMARY KEY  (`version_id`),
  KEY `rt_versions_journal_id` (`journal_id`),
  KEY `rt_versions_version_key` (`version_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `rt_versions`
--

LOCK TABLES `rt_versions` WRITE;
/*!40000 ALTER TABLE `rt_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `rt_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scheduled_tasks`
--

DROP TABLE IF EXISTS `scheduled_tasks`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `scheduled_tasks` (
  `class_name` varchar(255) NOT NULL,
  `last_run` datetime default NULL,
  UNIQUE KEY `scheduled_tasks_pkey` (`class_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `scheduled_tasks`
--

LOCK TABLES `scheduled_tasks` WRITE;
/*!40000 ALTER TABLE `scheduled_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `scheduled_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section_editors`
--

DROP TABLE IF EXISTS `section_editors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `section_editors` (
  `journal_id` bigint(20) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `can_edit` tinyint(4) NOT NULL default '1',
  `can_review` tinyint(4) NOT NULL default '1',
  UNIQUE KEY `section_editors_pkey` (`journal_id`,`section_id`,`user_id`),
  KEY `section_editors_journal_id` (`journal_id`),
  KEY `section_editors_section_id` (`section_id`),
  KEY `section_editors_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `section_editors`
--

LOCK TABLES `section_editors` WRITE;
/*!40000 ALTER TABLE `section_editors` DISABLE KEYS */;
/*!40000 ALTER TABLE `section_editors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section_settings`
--

DROP TABLE IF EXISTS `section_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `section_settings` (
  `section_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `section_settings_pkey` (`section_id`,`locale`,`setting_name`),
  KEY `section_settings_section_id` (`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `section_settings`
--

LOCK TABLES `section_settings` WRITE;
/*!40000 ALTER TABLE `section_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `section_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sections` (
  `section_id` bigint(20) NOT NULL auto_increment,
  `journal_id` bigint(20) NOT NULL,
  `review_form_id` bigint(20) default NULL,
  `seq` double NOT NULL default '0',
  `editor_restricted` tinyint(4) NOT NULL default '0',
  `meta_indexed` tinyint(4) NOT NULL default '0',
  `meta_reviewed` tinyint(4) NOT NULL default '1',
  `abstracts_not_required` tinyint(4) NOT NULL default '0',
  `hide_title` tinyint(4) NOT NULL default '0',
  `hide_author` tinyint(4) NOT NULL default '0',
  `hide_about` tinyint(4) NOT NULL default '0',
  `disable_comments` tinyint(4) NOT NULL default '0',
  `abstract_word_count` bigint(20) default NULL,
  PRIMARY KEY  (`section_id`),
  KEY `sections_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sessions` (
  `session_id` varchar(40) NOT NULL,
  `user_id` bigint(20) default NULL,
  `ip_address` varchar(39) NOT NULL,
  `user_agent` varchar(255) default NULL,
  `created` bigint(20) NOT NULL default '0',
  `last_used` bigint(20) NOT NULL default '0',
  `remember` tinyint(4) NOT NULL default '0',
  `data` text,
  `acting_as` bigint(20) NOT NULL default '0',
  UNIQUE KEY `sessions_pkey` (`session_id`),
  KEY `sessions_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('f946f69fae92390660faab0d1885f501',1,'158.109.1.15','Mozilla/5.0 (X11; U; Linux i686; es-ES; rv:1.9.2.13) Gecko/20101206 Ubuntu/10.04 (lucid) Firefox/3.6.13',1302097609,1302097765,0,'userId|s:1:\"1\";username|s:5:\"admin\";',0);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `signoffs`
--

DROP TABLE IF EXISTS `signoffs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `signoffs` (
  `signoff_id` bigint(20) NOT NULL auto_increment,
  `symbolic` varchar(32) NOT NULL,
  `assoc_type` bigint(20) NOT NULL default '0',
  `assoc_id` bigint(20) NOT NULL default '0',
  `user_id` bigint(20) NOT NULL,
  `file_id` bigint(20) default NULL,
  `file_revision` bigint(20) default NULL,
  `date_notified` datetime default NULL,
  `date_underway` datetime default NULL,
  `date_completed` datetime default NULL,
  `date_acknowledged` datetime default NULL,
  `stage_id` bigint(20) default NULL,
  `user_group_id` bigint(20) default NULL,
  PRIMARY KEY  (`signoff_id`),
  UNIQUE KEY `signoff_symbolic` (`assoc_type`,`assoc_id`,`symbolic`,`user_id`,`stage_id`,`user_group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `signoffs`
--

LOCK TABLES `signoffs` WRITE;
/*!40000 ALTER TABLE `signoffs` DISABLE KEYS */;
/*!40000 ALTER TABLE `signoffs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site`
--

DROP TABLE IF EXISTS `site`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site` (
  `redirect` bigint(20) NOT NULL default '0',
  `primary_locale` varchar(5) NOT NULL,
  `min_password_length` tinyint(4) NOT NULL default '6',
  `installed_locales` varchar(255) NOT NULL default 'en_US',
  `supported_locales` varchar(255) default NULL,
  `original_style_file_name` varchar(255) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `site`
--

LOCK TABLES `site` WRITE;
/*!40000 ALTER TABLE `site` DISABLE KEYS */;
INSERT INTO `site` VALUES (0,'es_ES',6,'en_US:es_ES:ca_ES','en_US:es_ES:ca_ES',NULL);
/*!40000 ALTER TABLE `site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_settings`
--

DROP TABLE IF EXISTS `site_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_settings` (
  `setting_name` varchar(255) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `site_settings_pkey` (`setting_name`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `site_settings`
--

LOCK TABLES `site_settings` WRITE;
/*!40000 ALTER TABLE `site_settings` DISABLE KEYS */;
INSERT INTO `site_settings` VALUES ('title','es_ES','Open Journal Systems','string'),('contactName','es_ES','Open Journal Systems','string'),('contactEmail','es_ES','marc.bria@uab.cat','string');
/*!40000 ALTER TABLE `site_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `static_page_settings`
--

DROP TABLE IF EXISTS `static_page_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `static_page_settings` (
  `static_page_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` longtext,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `static_page_settings_pkey` (`static_page_id`,`locale`,`setting_name`),
  KEY `static_page_settings_static_page_id` (`static_page_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `static_page_settings`
--

LOCK TABLES `static_page_settings` WRITE;
/*!40000 ALTER TABLE `static_page_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `static_page_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `static_pages`
--

DROP TABLE IF EXISTS `static_pages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `static_pages` (
  `static_page_id` bigint(20) NOT NULL auto_increment,
  `path` varchar(255) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`static_page_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `static_pages`
--

LOCK TABLES `static_pages` WRITE;
/*!40000 ALTER TABLE `static_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `static_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_type_settings`
--

DROP TABLE IF EXISTS `subscription_type_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscription_type_settings` (
  `type_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `subscription_type_settings_pkey` (`type_id`,`locale`,`setting_name`),
  KEY `subscription_type_settings_type_id` (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_type_settings`
--

LOCK TABLES `subscription_type_settings` WRITE;
/*!40000 ALTER TABLE `subscription_type_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_type_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_types`
--

DROP TABLE IF EXISTS `subscription_types`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscription_types` (
  `type_id` bigint(20) NOT NULL auto_increment,
  `journal_id` bigint(20) NOT NULL,
  `cost` double NOT NULL,
  `currency_code_alpha` varchar(3) NOT NULL,
  `non_expiring` tinyint(4) NOT NULL default '0',
  `duration` smallint(6) default NULL,
  `format` smallint(6) NOT NULL,
  `institutional` tinyint(4) NOT NULL default '0',
  `membership` tinyint(4) NOT NULL default '0',
  `disable_public_display` tinyint(4) NOT NULL,
  `seq` double NOT NULL,
  PRIMARY KEY  (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_types`
--

LOCK TABLES `subscription_types` WRITE;
/*!40000 ALTER TABLE `subscription_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscriptions` (
  `subscription_id` bigint(20) NOT NULL auto_increment,
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `type_id` bigint(20) NOT NULL,
  `date_start` date default NULL,
  `date_end` datetime default NULL,
  `status` tinyint(4) NOT NULL default '1',
  `membership` varchar(40) default NULL,
  `reference_number` varchar(40) default NULL,
  `notes` text,
  PRIMARY KEY  (`subscription_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporary_files`
--

DROP TABLE IF EXISTS `temporary_files`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `temporary_files` (
  `file_id` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) NOT NULL,
  `file_name` varchar(90) NOT NULL,
  `file_type` varchar(255) default NULL,
  `file_size` bigint(20) NOT NULL,
  `original_file_name` varchar(127) default NULL,
  `date_uploaded` datetime NOT NULL,
  PRIMARY KEY  (`file_id`),
  KEY `temporary_files_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `temporary_files`
--

LOCK TABLES `temporary_files` WRITE;
/*!40000 ALTER TABLE `temporary_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `temporary_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `theses`
--

DROP TABLE IF EXISTS `theses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `theses` (
  `thesis_id` bigint(20) NOT NULL auto_increment,
  `journal_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `degree` smallint(6) NOT NULL,
  `degree_name` varchar(255) default NULL,
  `department` varchar(255) NOT NULL,
  `university` varchar(255) NOT NULL,
  `date_approved` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `url` text,
  `abstract` text,
  `comment` text,
  `student_first_name` varchar(40) NOT NULL,
  `student_middle_name` varchar(40) default NULL,
  `student_last_name` varchar(90) NOT NULL,
  `student_email` varchar(90) NOT NULL,
  `student_email_publish` tinyint(4) default '0',
  `student_bio` text,
  `supervisor_first_name` varchar(40) NOT NULL,
  `supervisor_middle_name` varchar(40) default NULL,
  `supervisor_last_name` varchar(90) NOT NULL,
  `supervisor_email` varchar(90) NOT NULL,
  `discipline` varchar(255) default NULL,
  `subject_class` varchar(255) default NULL,
  `subject` varchar(255) default NULL,
  `coverage_geo` varchar(255) default NULL,
  `coverage_chron` varchar(255) default NULL,
  `coverage_sample` varchar(255) default NULL,
  `method` varchar(255) default NULL,
  `language` varchar(10) default 'en',
  `date_submitted` datetime NOT NULL,
  PRIMARY KEY  (`thesis_id`),
  KEY `theses_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `theses`
--

LOCK TABLES `theses` WRITE;
/*!40000 ALTER TABLE `theses` DISABLE KEYS */;
/*!40000 ALTER TABLE `theses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_settings` (
  `user_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL default '',
  `setting_name` varchar(255) NOT NULL,
  `assoc_type` bigint(20) default '0',
  `assoc_id` bigint(20) default '0',
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `user_settings_pkey` (`user_id`,`locale`,`setting_name`,`assoc_type`,`assoc_id`),
  KEY `user_settings_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_settings`
--

LOCK TABLES `user_settings` WRITE;
/*!40000 ALTER TABLE `user_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL auto_increment,
  `username` varchar(32) NOT NULL,
  `password` varchar(40) NOT NULL,
  `salutation` varchar(40) default NULL,
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) default NULL,
  `last_name` varchar(90) NOT NULL,
  `gender` varchar(1) default NULL,
  `initials` varchar(5) default NULL,
  `email` varchar(90) NOT NULL,
  `url` varchar(255) default NULL,
  `phone` varchar(24) default NULL,
  `fax` varchar(24) default NULL,
  `mailing_address` varchar(255) default NULL,
  `country` varchar(90) default NULL,
  `locales` varchar(255) default NULL,
  `date_last_email` datetime default NULL,
  `date_registered` datetime NOT NULL,
  `date_validated` datetime default NULL,
  `date_last_login` datetime NOT NULL,
  `must_change_password` tinyint(4) default NULL,
  `auth_id` bigint(20) default NULL,
  `auth_str` varchar(255) default NULL,
  `disabled` tinyint(4) NOT NULL default '0',
  `disabled_reason` text,
  PRIMARY KEY  (`user_id`),
  UNIQUE KEY `users_username` (`username`),
  UNIQUE KEY `users_email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','08e319e0381aee086f37ca41bfe03d414bb929b0',NULL,'admin',NULL,'',NULL,NULL,'marc.bria@uab.cat',NULL,NULL,NULL,NULL,NULL,'',NULL,'2011-04-06 15:44:30',NULL,'2011-04-06 15:49:23',0,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `versions` (
  `major` int(11) NOT NULL default '0',
  `minor` int(11) NOT NULL default '0',
  `revision` int(11) NOT NULL default '0',
  `build` int(11) NOT NULL default '0',
  `date_installed` datetime NOT NULL,
  `current` tinyint(4) NOT NULL default '0',
  `product_type` varchar(30) default NULL,
  `product` varchar(30) default NULL,
  `product_class_name` varchar(80) default NULL,
  `lazy_load` tinyint(4) NOT NULL default '0',
  `sitewide` tinyint(4) NOT NULL default '0',
  UNIQUE KEY `versions_pkey` (`product`,`major`,`minor`,`revision`,`build`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `versions`
--

LOCK TABLES `versions` WRITE;
/*!40000 ALTER TABLE `versions` DISABLE KEYS */;
INSERT INTO `versions` VALUES (1,0,0,0,'2011-04-06 15:44:30',1,'plugins.auth','ldap','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','help','HelpBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','donation','DonationBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','subscription','SubscriptionBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','navigation','NavigationBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','authorBios','AuthorBiosBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','relatedItems','RelatedItemsBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','user','UserBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','keywordCloud','KeywordCloudBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','readingTools','ReadingToolsBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','information','InformationBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','notification','NotificationBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','role','RoleBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','developedBy','DevelopedByBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','languageToggle','LanguageToggleBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.blocks','fontSize','FontSizeBlockPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','bibtex','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','apa','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','refMan','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','abnt','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','refWorks','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','cbe','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','turabian','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','endNote','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','proCite','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.citationFormats','mla','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.gateways','metsGateway','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.gateways','resolver','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','xmlGalley','XmlGalleyPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','booksForReview','BooksForReviewPlugin',1,0),(1,2,0,0,'2011-04-06 15:44:30',1,'plugins.generic','staticPages','StaticPagesPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','externalFeed','ExternalFeedPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','thesis','ThesisPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','phpMyVisites','PhpMyVisitesPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','sehl','SehlPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','googleAnalytics','GoogleAnalyticsPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','webFeed','WebFeedPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','tinymce','TinyMCEPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','openAIRE','OpenAIREPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','customLocale','CustomLocalePlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','translator','TranslatorPlugin',1,1),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','referral','ReferralPlugin',1,0),(1,1,0,0,'2011-04-06 15:44:30',1,'plugins.generic','customBlockManager','CustomBlockManagerPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','roundedCorners','RoundedCornersPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','thesisFeed','ThesisFeedPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','announcementFeed','AnnouncementFeedPlugin',1,0),(1,1,0,0,'2011-04-06 15:44:30',1,'plugins.generic','counter','CounterPlugin',1,1),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','openAds','OpenAdsPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','coins','CoinsPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.generic','sword','SwordPlugin',1,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.implicitAuth','shibboleth','',0,1),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.importexport','pubmed','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.importexport','erudit','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.importexport','doaj','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.importexport','quickSubmit','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.importexport','users','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.importexport','native','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.importexport','mets','',0,0),(1,1,0,0,'2011-04-06 15:44:30',1,'plugins.importexport','crossref','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.oaiMetadataFormats','nlm','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.oaiMetadataFormats','marc','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.oaiMetadataFormats','rfc1807','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.oaiMetadataFormats','dc','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.oaiMetadataFormats','marcxml','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.paymethod','manual','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.paymethod','paypal','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.reports','subscriptions','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.reports','views','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.reports','reviews','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.reports','articles','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','steel','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','classicGreen','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','classicNavy','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','custom','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','vanilla','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','classicBlue','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','classicRed','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','classicBrown','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','uncommon','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','desert','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','night','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','lilac','',0,0),(1,0,0,0,'2011-04-06 15:44:30',1,'plugins.themes','redbar','',0,0),(2,3,4,0,'2011-04-06 15:44:29',1,'core','ojs2','',0,1);
/*!40000 ALTER TABLE `versions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-04-06 14:03:14
