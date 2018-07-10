-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.2.7-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for smvsdc
CREATE DATABASE IF NOT EXISTS `smvsdc` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `smvsdc`;

-- Dumping structure for table smvsdc.faq
DROP TABLE IF EXISTS `faq`;
CREATE TABLE IF NOT EXISTS `faq` (
  `faq_id` int(11) NOT NULL AUTO_INCREMENT,
  `faq_sub_id` int(11) DEFAULT NULL,
  `faq_vid_id` int(11) DEFAULT NULL,
  `faq_question` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`faq_id`),
  KEY `fk_faq_vid` (`faq_vid_id`),
  KEY `fk_faq_sub` (`faq_sub_id`),
  CONSTRAINT `fk_faq_vid` FOREIGN KEY (`faq_vid_id`) REFERENCES `video` (`vid_id`),
  CONSTRAINT `fk_faq_sub` FOREIGN KEY (`faq_sub_id`) REFERENCES `subject` (`sub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table smvsdc.faq: ~23 rows (approximately)
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
INSERT INTO `faq` (`faq_id`, `faq_sub_id`, `faq_vid_id`, `faq_question`) VALUES
	(1, 1, 1, 'How many human factors can SMV handle?'),
	(2, 1, 2, 'What other types of factors are there?'),
	(3, 1, 3, 'How will the system know my personal factors?'),
	(4, 1, 4, 'What are Video Lectures?'),
	(5, 1, 5, 'Why are Power Point presentation considered old?'),
	(6, 1, 6, 'What is meant by information dump?'),
	(7, 1, 7, 'What is wrong with group exercise?'),
	(8, 1, 8, 'Did you mean online chats or face-to-face chats?'),
	(9, 1, 9, 'Why is e learning considered old?'),
	(10, 1, 10, 'What new memorize and regurgitate techniques are being used?'),
	(11, 1, 11, 'What are the problems with on-the-job training?'),
	(12, 1, 12, 'What are Visual Explanations?'),
	(13, 1, 13, 'What is Card-Based Dialog?'),
	(14, 1, 14, 'How do social networks like Facebook help train employees?'),
	(15, 1, 15, 'How do networks like LinkedIn help train employees?'),
	(16, 1, 16, 'How do online networks differ from online Communities?'),
	(17, 1, 17, 'How does multimedia e-learning differ from online e-learning?'),
	(18, 1, 18, 'How do trainers use simulators?'),
	(19, 1, 19, 'What is graphic facilitation?'),
	(20, 1, 20, 'What is action research and learning?'),
	(21, 1, 21, 'When is SMV going to be in the market for sale?'),
	(22, 1, 22, 'When can companies start buying SMV?'),
	(23, 1, 23, 'Have you presented SMV to any training companies?');
/*!40000 ALTER TABLE `faq` ENABLE KEYS */;

-- Dumping structure for table smvsdc.subject
DROP TABLE IF EXISTS `subject`;
CREATE TABLE IF NOT EXISTS `subject` (
  `sub_id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`sub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table smvsdc.subject: ~1 rows (approximately)
/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
INSERT INTO `subject` (`sub_id`, `sub_name`) VALUES
	(1, 'Introduction to SMV');
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;

-- Dumping structure for table smvsdc.video
DROP TABLE IF EXISTS `video`;
CREATE TABLE IF NOT EXISTS `video` (
  `vid_id` int(11) NOT NULL AUTO_INCREMENT,
  `vid_sub_id` int(11) NOT NULL,
  `vid_script` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`vid_id`),
  KEY `fk_vid_sub` (`vid_sub_id`),
  CONSTRAINT `fk_vid_sub` FOREIGN KEY (`vid_sub_id`) REFERENCES `subject` (`sub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table smvsdc.video: ~23 rows (approximately)
/*!40000 ALTER TABLE `video` DISABLE KEYS */;
INSERT INTO `video` (`vid_id`, `vid_sub_id`, `vid_script`) VALUES
	(1, 1, 'SMV can virtually manage an infinite number of factors.  So the number of factors is immaterial.  What’s most material is that we identify all the factors.'),
	(2, 1, 'SMV can consider other factors – For example: Business factors that relate to the company itself and industry factors related to the industry that the company operates in.'),
	(3, 1, 'Normally we’ll ask you to fill out a profile.  This time we didn’t because this session is only a demonstration.'),
	(4, 1, 'Video Lectures are nothing more than videos used for one-way large audience broadcast that follow traditional educational classroom models.'),
	(5, 1, 'Many times Power Point text snippets are disjointed limiting the learners’ ability to cognitively absorb the ideas being presented, this normally results in boredom.'),
	(6, 1, 'Information dumps happen more often than we wish; learners are given large quantities of text to read. The result is that most text goes unread, and valuable lessons are lost.'),
	(7, 1, 'Its “how” we do it. Many traditional group exercises are contrived and have only a superficial relevance to work activities. Employees often think of these exercises as phony and just going through the motions.'),
	(8, 1, 'It doesn’t matter because more often than not instead of deep debates, learners talk past each other and go off on pointless tangents. People expect to learn from each other but get few substantive lessons.'),
	(9, 1, 'Instead of tailoring content to the medium, old text documents are simply repackaged for online consumption. Too much time is spent on reading long documents on computer screens with little interaction and engagement.  On the other hand, when multimedia is use e-learning moves into a whole new dimension.'),
	(10, 1, 'A variety of new techniques have been developed. In practice results are the same. Rote studying does little to stimulate imagination, show logic and lessons are quickly forgotten.'),
	(11, 1, 'Learners are left to themselves because veterans have little time or inclination to train successors. Unprepared employees learn the ropes with risky and unproductive coping.'),
	(12, 1, 'Ideas are explained visually with graphics, photos, and other visual aids. Visualization forces instructors to orchestrate words and visuals into clear & coherent messages and frameworks. Complicated ideas are -- better understood, -- easier to fit together and more memorable.'),
	(13, 1, 'New Card-Based Dialog methods expose learners to ideas and research during dialog sessions. Cards help groups brainstorm, diagnose problems, set a course of action and provide an opportunity for individuals to reflect on ideas after the session is over. Simply put, dialog sessions have greater focus when people concentrate on realistic problems.'),
	(14, 1, 'Web-based social-networking technologies facilitate online conversations and new ideas as perspectives are brought to bear on problems.'),
	(15, 1, 'Web-based business-networking technologies facilitate online conversations and new ideas -- as perspectives are brought to bear on problems.'),
	(16, 1, 'Normally, communities of practice meet online and/or face-to-face in order to steward a body of practice knowledge -- in the process teaching new members just happens.'),
	(17, 1, 'Multimedia e-learning courses offer interactions, and intellectual stimulation, allowing people to learn from their desktops. '),
	(18, 1, 'Trainers use immersive simulators to encourage people to imagine themselves within a real-world scenario & solve problems. Imagining is a technique used to change perceptions.'),
	(19, 1, 'Graphics help people see patterns and craft ideas in coherent manners, thus facilitators can help people visualize their ideas on the fly, and teach them visualizations skills.'),
	(20, 1, 'Action research involves bringing a diverse group of experts and practitioners together to jointly inquirer about a subject of interest. The advice that results tends to be more relevant to daily work, and action-learning techniques actively put course lessons to work. These methods prevent course lessons from languishing on the shelf unused.'),
	(21, 1, 'We are not quite ready. But we expect to begin licensing it in 2018.'),
	(22, 1, 'We are ready now and we expect to begin selling it in 2017.'),
	(23, 1, 'Yes and we have a few companies who we’re presently developing their SMV systems.');
/*!40000 ALTER TABLE `video` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
