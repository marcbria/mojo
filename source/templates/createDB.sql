CREATE DATABASE `ojs_%MOJO_JOURNAL_TAG%` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE ojs_%MOJO_JOURNAL_TAG%;
GRANT ALL PRIVILEGES ON `ojs_%MOJO_JOURNAL_TAG%` . * TO '%MOJO_MYSQL_USER%'@'localhost' WITH GRANT OPTION ;
