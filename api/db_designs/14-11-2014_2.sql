-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server versie:                5.6.20 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Versie:              9.1.0.4867
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Databasestructuur van skik_app wordt geschreven
CREATE DATABASE IF NOT EXISTS `skik_app` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `skik_app`;


-- Structuur van  tabel skik_app.feed wordt geschreven
CREATE TABLE IF NOT EXISTS `feed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `last_fetch` int(11) DEFAULT '0',
  `fetch_minutes` int(11) DEFAULT '30',
  `score` int(11) DEFAULT '0',
  `url` varchar(512) DEFAULT NULL,
  `repository` smallint(6) DEFAULT '0',
  `language_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_feed_language` (`language_id`),
  CONSTRAINT `FK_feed_language` FOREIGN KEY (`language_id`) REFERENCES `language` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8;

-- Dumpen data van tabel skik_app.feed: ~103 rows (ongeveer)
/*!40000 ALTER TABLE `feed` DISABLE KEYS */;
INSERT INTO `feed` (`id`, `name`, `last_fetch`, `fetch_minutes`, `score`, `url`, `repository`, `language_id`) VALUES
	(1, 'PHP.net Announcements', 1415965693, 15, 0, 'http://news.php.net/group.php?group=php.announce&format=rss', 0, 2),
	(2, 'Planet-php', 1415965695, 15, 0, 'http://www.planet-php.net/rss', 0, 2),
	(3, 'AllTop PHP', 1415965700, 15, 0, 'http://php.alltop.com/rss', 0, 2),
	(4, 'Reddit PHP', 1415965702, 15, 0, 'http://www.reddit.com/r/PHP/.rss', 0, 2),
	(7, 'C daily trending Github Repositories', 1415965704, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_c_daily.rss', 1, 14),
	(8, 'C weekly trending Github Repositories', 1415965705, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_c_weekly.rss', 2, 14),
	(9, 'C++ daily trending Github Repositories', 1415965706, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_cpp_daily.rss', 1, 1),
	(10, 'C++ weekly trending Github Repositories', 1415965707, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_cpp_weekly.rss', 1, 1),
	(11, 'Clojure daily trending Github Repositories', 1415965708, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_clojure_daily.rss', 1, 22),
	(12, 'Clojure weekly trending Github Repositories', 1415965709, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_clojure_weekly.rss', 1, 22),
	(13, 'CoffeeScript daily trending Github Repositories', 1415965710, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_coffeescript_daily.rss', 1, 18),
	(14, 'CoffeeScript weekly trending Github Repositories', 1415965711, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_coffeescript_weekly.rss', 1, 18),
	(15, 'CSS daily trending Github Repositories', 1415965712, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_css_daily.rss', 1, 5),
	(16, 'CSS weekly trending Github Repositories', 1415965713, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_css_weekly.rss', 1, 5),
	(17, 'Dart daily trending Github Repositories', 1415965714, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_dart_daily.rss', 1, 17),
	(18, 'Dart weekly trending Github Repositories', 1415965715, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_dart_weekly.rss', 1, 17),
	(19, 'Go daily trending Github Repositories', 1415965716, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_go_daily.rss', 1, 15),
	(20, 'Go weekly trending Github Repositories', 1415965717, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_go_weekly.rss', 1, 15),
	(21, 'Haskell daily trending Github Repositories', 1415965718, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_haskell_daily.rss', 1, 13),
	(22, 'Haskell weekly trending Github Repositories', 1415965719, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_haskell_weekly.rss', 1, 13),
	(23, 'Java daily trending Github Repositories', 1415965720, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_java_daily.rss', 1, 19),
	(24, 'Java weekly trending Github Repositories', 1415965721, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_java_weekly.rss', 1, 19),
	(25, 'JavaScript daily trending Github Repositories', 1415965722, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_javascript_daily.rss', 1, 3),
	(26, 'JavaScript weekly trending Github Repositories', 1415965723, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_javascript_weekly.rss', 1, 3),
	(29, 'Ruby daily trending Github Repositories', 1415965724, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_ruby_daily.rss', 1, 16),
	(30, 'Ruby weekly trending Github Repositories', 1415965725, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_ruby_weekly.rss', 1, 16),
	(31, 'Objective-C daily trending Github Repositories', 1415965726, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_objective-c_daily.rss', 1, 12),
	(32, 'Objective-C weekly trending Github Repositories', 1415965727, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_objective-c_weekly.rss', 1, 12),
	(33, 'Perl daily trending Github Repositories', 1415965728, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_perl_daily.rss', 1, 11),
	(34, 'Perl weekly trending Github Repositories', 1415965729, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_perl_weekly.rss', 1, 11),
	(35, 'PHP daily trending Github Repositories', 1415965730, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_php_daily.rss', 1, 2),
	(36, 'PHP weekly trending Github Repositories', 1415965731, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_php_weekly.rss', 1, 2),
	(37, 'Python daily trending Github Repositories', 1415965732, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_python_daily.rss', 1, 6),
	(38, 'Python weekly trending Github Repositories', 1415965733, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_python_weekly.rss', 1, 6),
	(39, 'JavaScript daily trending Github Repositories', 1415965734, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_r_daily.rss', 1, 7),
	(40, 'JavaScript weekly trending Github Repositories', 1415965735, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_r_weekly.rss', 1, 7),
	(41, 'Scala daily trending Github Repositories', 1415965736, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_scala_daily.rss', 1, 21),
	(42, 'Scala weekly trending Github Repositories', 1415965738, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_scala_weekly.rss', 1, 21),
	(43, 'SQL daily trending Github Repositories', 1415965739, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_sql_daily.rss', 1, 8),
	(44, 'SQL weekly trending Github Repositories', 1415965740, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_sql_weekly.rss', 1, 8),
	(45, 'Swift daily trending Github Repositories', 1415965741, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_swift_daily.rss', 1, 10),
	(46, 'Swift weekly trending Github Repositories', 1415965742, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_swift_weekly.rss', 1, 10),
	(47, 'TeX daily trending Github Repositories', 1415965743, 60, 0, 'http://github-trends.ryotarai.info/rss/github_trends_tex_daily.rss', 1, 9),
	(48, 'TeX weekly trending Github Repositories', 1415965744, 300, 0, 'http://github-trends.ryotarai.info/rss/github_trends_tex_weekly.rss', 1, 9),
	(49, 'DailyJS', 1415965746, 30, 0, 'http://feeds.feedburner.com/dailyjs?format=xml', 0, 3),
	(50, 'CssTricks', 1415965747, 30, 0, 'http://feeds.feedburner.com/CssTricks?format=xml', 0, 5),
	(51, 'DZone Java', 1415965748, 30, 0, 'http://feeds.dzone.com/javalobby/frontpage', 0, 19),
	(52, 'Reddit Java', 1415965749, 30, 0, 'http://www.reddit.com/r/java/.rss', 0, 19),
	(54, 'Reddit Javascript', 1415965750, 30, 0, 'http://www.reddit.com/r/javascript/.rss', 0, 3),
	(55, 'Reddit C', 1415965751, 30, 0, 'http://www.reddit.com/r/C_programming/.rss', 0, 14),
	(56, 'Reddit C++', 1415965752, 30, 0, 'http://www.reddit.com/r/cpp/.rss', 0, 1),
	(57, 'Reddit Perl', 1415965752, 30, 0, 'http://www.reddit.com/r/perl/.rss', 0, 11),
	(58, 'Reddit Ruby', 1415965753, 30, 0, 'http://www.reddit.com/r/ruby/.rss', 0, 16),
	(59, 'Reddit Python', 1415965754, 30, 0, 'http://www.reddit.com/r/Python/.rss', 0, 6),
	(60, 'Reddit R', 1415965755, 30, 0, 'http://www.reddit.com/r/RLanguage/.rss', 0, 7),
	(61, 'Reddit Go', 1415965759, 30, 0, 'http://www.reddit.com/r/golang/.rss', 0, 15),
	(62, 'Reddit Dart', 1415965760, 30, 0, 'http://www.reddit.com/r/dartlang/.rss', 0, 17),
	(63, 'Reddit Scala', 1415965760, 30, 0, 'http://www.reddit.com/r/scala/.rss', 0, 21),
	(64, 'Reddit Clojure', 1415965761, 30, 0, 'http://www.reddit.com/r/clojure/.rss', 0, 22),
	(65, 'Reddit Haskell', 1415965762, 30, 0, 'http://www.reddit.com/r/haskell/.rss', 0, 13),
	(66, 'Reddit Swift', 1415965763, 30, 0, 'http://www.reddit.com/r/swift/.rss', 0, 10),
	(67, 'Reddit LaTeX', 1415965764, 30, 0, 'http://www.reddit.com/r/LaTeX/.rss', 0, 9),
	(68, 'Reddit TeX', 1415965764, 30, 0, 'http://www.reddit.com/r/tex/.rss', 0, 9),
	(69, 'Reddit SQL', 1415965765, 30, 0, 'http://www.reddit.com/r/SQL/.rss', 0, 8),
	(70, 'Reddit SQLServer', 1415965766, 30, 0, 'http://www.reddit.com/r/SQLServer/.rss', 0, 8),
	(71, 'WebAppers', 1415965766, 30, 0, 'http://feeds.feedburner.com/Webappers?format=xml', 0, 3),
	(72, 'SitePoint PHP', 1415965768, 30, 0, 'http://www.sitepoint.com/php/feed/', 0, 2),
	(73, 'SitePoint Javascript', 1415965769, 30, 0, 'http://www.sitepoint.com/javascript/feed', 0, 3),
	(74, 'SitePoint Ruby', 1415965770, 30, 0, 'http://www.sitepoint.com/ruby/feed', 0, 16),
	(75, 'David Walsh Css', 1415965772, 300, 0, 'http://davidwalsh.name/tutorials/css/feed', 0, 5),
	(76, 'David Walsh HTML5', 1415965774, 30, 0, 'http://davidwalsh.name/tutorials/html5/feed', 0, 4),
	(77, 'David Walsh JavaScript', 1415965775, 30, 0, 'http://davidwalsh.name/tutorials/javascript/feed', 0, 3),
	(78, 'Planet Python', 1415965778, 30, 0, 'http://planetpython.org/rss20.xml', 0, 6),
	(79, 'Doug Hellmann Blog', 1415965780, 30, 0, 'http://feeds.doughellmann.com/DougHellmann?format=xml', 0, 6),
	(80, 'InventWithPython', 1415965783, 30, 0, 'http://inventwithpython.com/blog/feed/', 0, 6),
	(81, 'FreePythonTips', 1415965785, 30, 0, 'http://freepythontips.wordpress.com/feed/', 0, 6),
	(82, 'RBloggers', 1415965786, 30, 0, 'http://feeds.feedburner.com/RBloggers?format=xml', 0, 7),
	(83, 'RStatistics', 1415965788, 30, 0, 'http://www.r-statistics.com/feed/', 0, 7),
	(84, 'StatsBlog', 1415965789, 30, 0, 'http://feeds.feedburner.com/statsblogs?format=xml', 0, 7),
	(85, 'Apple\'s Swift Blog', 0, 30, 0, 'http://developer.apple.com/swift/blog/news.rss', 0, 10),
	(86, 'We Love Swift', 1415965793, 30, 0, 'http://www.weheartswift.com/feed', 0, 10),
	(87, 'PerlBuzz', 1415965794, 30, 0, 'http://feeds.feedburner.com/PerlBuzz', 0, 11),
	(88, 'Perl Hacks', 1415965795, 1000, 0, 'http://feeds.feedburner.com/PerlHacks', 0, 11),
	(89, 'Perl Foundation', 1415965797, 30, 0, 'http://news.perlfoundation.org/atom.xml', 0, 11),
	(90, 'Haskell.org', 1415965801, 30, 0, 'http://planet.haskell.org/rss20.xml', 0, 13),
	(91, 'Haskell For All', 1415965803, 30, 0, 'http://www.haskellforall.com/feeds/posts/default', 0, 13),
	(92, 'Go NewsLetter', 1415965803, 30, 0, 'http://feeds.feedburner.com/golangnewsletter?format=xml', 0, 15),
	(93, 'DCSOrbal', 1415965805, 30, 0, 'http://dcsobral.blogspot.com/feeds/posts/default', 0, 21),
	(94, 'Aritma Scala', 0, 30, 0, 'http://www.artima.com/buzz/feeds/scala.rss', 0, 21),
	(95, 'Aritma PHP', 1415991539, 30, 0, 'http://www.artima.com/buzz/feeds/php.rss', 0, 2),
	(96, 'Aritma Java', 0, 30, 0, 'http://www.artima.com/buzz/feeds/java.rss', 0, 19),
	(97, 'Aritma Perl', 0, 30, 0, 'http://www.artima.com/buzz/feeds/perl.rss', 0, 11),
	(98, 'Aritma Python', 0, 30, 0, 'http://www.artima.com/buzz/feeds/python.rss', 0, 6),
	(99, 'Aritma Ruby', 0, 30, 0, 'http://www.artima.com/buzz/feeds/ruby.rss', 0, 16),
	(100, 'Herb Sutter cpp', 1415965814, 30, 0, 'http://herbsutter.com/feed/', 0, 1),
	(101, 'Microsoft Visual Team Cpp', 1415965815, 30, 0, 'http://blogs.msdn.com/b/vcblog/rss.aspx', 0, 1),
	(102, 'Cpp Thruths', 1415965816, 30, 0, 'http://feeds.feedburner.com/CppTruths?format=xml', 0, 1),
	(103, 'Dr Drobbs Cpp', 1415965817, 30, 0, 'http://www.drdobbs.com/articles/cpp/rss', 0, 1),
	(104, 'MsDn Cpp', 1415965819, 30, 0, 'http://blogs.msdn.com/b/oldnewthing/rss.aspx', 0, 1),
	(105, 'Clojure Planet', 1415965821, 30, 0, 'http://planet.clojure.in/atom.xml', 0, 22),
	(106, 'W3 Blog CSS', 1415965823, 30, 0, 'http://www.w3.org/blog/CSS/feed/atom/', 0, 5),
	(107, 'DartLang', 1415965824, 30, 0, 'http://news.dartlang.org/feeds/posts/default', 0, 17),
	(108, 'DartoSphere', 1415965824, 30, 0, 'http://feeds.feedburner.com/dartosphere?format=xml', 0, 17);
/*!40000 ALTER TABLE `feed` ENABLE KEYS */;


-- Structuur van  tabel skik_app.item wordt geschreven
CREATE TABLE IF NOT EXISTS `item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `link` varchar(512) NOT NULL,
  `title` varchar(512) NOT NULL,
  `content` mediumtext,
  `authors` varchar(512) DEFAULT NULL,
  `description` mediumtext,
  `rank` int(11) DEFAULT NULL,
  `date` int(11) NOT NULL,
  `score` int(11) NOT NULL DEFAULT '0',
  `feed_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_item_feed` (`feed_id`),
  CONSTRAINT `FK_item_feed` FOREIGN KEY (`feed_id`) REFERENCES `feed` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumpen data van tabel skik_app.item: ~0 rows (ongeveer)
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
/*!40000 ALTER TABLE `item` ENABLE KEYS */;


-- Structuur van  tabel skik_app.item_interaction wordt geschreven
CREATE TABLE IF NOT EXISTS `item_interaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) DEFAULT '0',
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `value` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_item_interaction_item` (`item_id`),
  KEY `FK_item_interaction_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumpen data van tabel skik_app.item_interaction: ~0 rows (ongeveer)
/*!40000 ALTER TABLE `item_interaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_interaction` ENABLE KEYS */;


-- Structuur van  tabel skik_app.language wordt geschreven
CREATE TABLE IF NOT EXISTS `language` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `img` varchar(256) DEFAULT NULL,
  `score` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- Dumpen data van tabel skik_app.language: ~22 rows (ongeveer)
/*!40000 ALTER TABLE `language` DISABLE KEYS */;
INSERT INTO `language` (`id`, `name`, `img`, `score`) VALUES
	(1, 'C++', 'c++.png', 86),
	(2, 'PHP', 'php.png', 90),
	(3, 'JavaScript', 'js.png', 100),
	(4, 'HTML', 'html.png', 85),
	(5, 'CSS', 'css.png', 92),
	(6, 'Python', 'python.png', 88),
	(7, 'R', 'r.png', 80),
	(8, 'SQL', 'sql.png', 0),
	(9, 'TeX', 'tex.png', 60),
	(10, 'Swift', 'swift.png', 75),
	(11, 'Perl', 'perl.png', 66),
	(12, 'Objective-C', 'objc.png', 84),
	(13, 'Haskell', 'haskell.png', 56),
	(14, 'C', 'c.png', 94),
	(15, 'Go', 'go.png', 68),
	(16, 'Ruby', 'ruby.png', 96),
	(17, 'Dart', 'dart.png', 75),
	(18, 'CoffeeScript', 'coffee.png', 70),
	(19, 'Java', 'java.png', 98),
	(20, 'Markdown', 'markdown.png', 0),
	(21, 'Scala', 'scala.png', 64),
	(22, 'Clojure', 'clo.png', 58);
/*!40000 ALTER TABLE `language` ENABLE KEYS */;


-- Structuur van  tabel skik_app.user wordt geschreven
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(256) NOT NULL,
  `password_hash` varchar(256) NOT NULL,
  `recovery_key` varchar(256) DEFAULT NULL,
  `auth_key` varchar(256) DEFAULT NULL,
  `settings` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- Dumpen data van tabel skik_app.user: ~2 rows (ongeveer)
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`id`, `email`, `password_hash`, `recovery_key`, `auth_key`, `settings`) VALUES
	(9, 'a@a.com', '$2y$13$QYe/p2Ekmn6cTcDGco4qT.lHKlOJnfJWyORNAQ631hdwD8XWjrOry', NULL, 'BImk9CdyOx', '{"user_name":"","reader_show_left_column":true,"reader_show_repo":true,"reader_show_news":true,"reader_show_login":true,"reader_items_count":20,"reader_repo_count":20,"reader_repo_timespan":"weekly","editor_font_size":"14px","editor_theme":"ace/theme/monokai","overwrite_feeds":true,"editor_save_windows":"Ctrl-S","editor_save_mac":"Command-S","languages_following":["Java","Ruby","JavaScript"],"c++_feeds_enabled":[],"php_feeds_enabled":[],"javascript_feeds_enabled":["DailyJS","David Walsh JavaScript","Reddit Javascript","SitePoint Javascript","WebAppers"],"html_feeds_enabled":[],"css_feeds_enabled":[],"python_feeds_enabled":[],"r_feeds_enabled":[],"sql_feeds_enabled":[],"tex_feeds_enabled":[],"swift_feeds_enabled":[],"perl_feeds_enabled":[],"objective-c_feeds_enabled":[],"haskell_feeds_enabled":[],"c_feeds_enabled":[],"go_feeds_enabled":[],"ruby_feeds_enabled":["Aritma Ruby","Reddit Ruby","SitePoint Ruby"],"dart_feeds_enabled":[],"coffeescript_feeds_enabled":[],"java_feeds_enabled":["Aritma Java","DZone Java","Reddit Java"],"markdown_feeds_enabled":[],"scala_feeds_enabled":[],"clojure_feeds_enabled":[]}'),
	(10, 't@t.com', '$2y$13$DTN3U5BYScqkNrPNK4fnV.rKqsrm34A4yWLusdkkD85.kSt45X96W', NULL, 'OWUXt1GMqI', '{"user_name":"","reader_show_left_column":false,"reader_show_repo":true,"reader_show_news":false,"reader_show_login":true,"reader_items_count":20,"reader_repo_count":40,"reader_repo_timespan":"weekly","editor_font_size":"14px","editor_theme":"ace/theme/monokai","overwrite_feeds":true,"editor_save_windows":"Ctrl-S","editor_save_mac":"Command-S","languages_following":["C","CSS","PHP","Ruby","HTML","C++","JavaScript"],"c++_feeds_enabled":["Cpp Thruths","Dr Drobbs Cpp","Microsoft Visual Team Cpp","MsDn Cpp","Reddit C++"],"php_feeds_enabled":["AllTop PHP","Planet-php","Reddit PHP","SitePoint PHP"],"javascript_feeds_enabled":["DailyJS","David Walsh JavaScript","WebAppers"],"html_feeds_enabled":[],"css_feeds_enabled":["CssTricks","W3 Blog CSS"],"python_feeds_enabled":[],"r_feeds_enabled":[],"sql_feeds_enabled":[],"tex_feeds_enabled":[],"swift_feeds_enabled":[],"perl_feeds_enabled":[],"objective-c_feeds_enabled":[],"haskell_feeds_enabled":[],"c_feeds_enabled":["Reddit C"],"go_feeds_enabled":[],"ruby_feeds_enabled":["Reddit Ruby","SitePoint Ruby"],"dart_feeds_enabled":[],"coffeescript_feeds_enabled":[],"java_feeds_enabled":[],"markdown_feeds_enabled":[],"scala_feeds_enabled":[],"clojure_feeds_enabled":[]}');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
