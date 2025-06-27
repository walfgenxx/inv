-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 27, 2025 at 07:58 AM
-- Server version: 8.0.42-cll-lve
-- PHP Version: 8.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `twhmbszk_quantivexcapital`
--

-- --------------------------------------------------------

--
-- Table structure for table `hm2_coins_transactions`
--

CREATE TABLE `hm2_coins_transactions` (
  `id` bigint NOT NULL,
  `coin` varchar(200) NOT NULL DEFAULT '',
  `user_id` bigint NOT NULL DEFAULT '0',
  `confirmations` int NOT NULL DEFAULT '0',
  `txid` varchar(200) NOT NULL DEFAULT '',
  `wallet` varchar(200) NOT NULL DEFAULT '',
  `amount` decimal(20,10) NOT NULL DEFAULT '0.0000000000',
  `ctime` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_deposits`
--

CREATE TABLE `hm2_deposits` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL DEFAULT '0',
  `type_id` bigint NOT NULL DEFAULT '0',
  `deposit_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_pay_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` enum('on','off') DEFAULT 'on',
  `q_pays` bigint NOT NULL DEFAULT '0',
  `amount` double(12,6) NOT NULL DEFAULT '0.000000',
  `actual_amount` double(12,6) NOT NULL DEFAULT '0.000000',
  `ec` int NOT NULL,
  `compound` float(10,2) DEFAULT NULL,
  `dde` datetime DEFAULT '1999-01-01 00:00:00',
  `unit_amount` decimal(20,10) NOT NULL DEFAULT '1.0000000000',
  `bonus_flag` tinyint(1) NOT NULL DEFAULT '0',
  `init_amount` decimal(20,10) NOT NULL DEFAULT '0.0000000000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Triggers `hm2_deposits`
--
DELIMITER $$
CREATE TRIGGER `after_deposits_insert` AFTER INSERT ON `hm2_deposits` FOR EACH ROW BEGIN DECLARE f INT; SET f = (SELECT count(*) FROM hm2_user_balances WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = 'active_deposit'); IF (f > 0 AND NEW.status = 'on') THEN UPDATE hm2_user_balances SET amount = amount + NEW.actual_amount WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = 'active_deposit'; ELSE INSERT INTO hm2_user_balances SET amount = NEW.actual_amount, user_id = NEW.user_id, ec = NEW.ec, type = 'active_deposit'; END IF; END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_deposits_update` AFTER UPDATE ON `hm2_deposits` FOR EACH ROW BEGIN DECLARE f INT; IF (OLD.status = 'on') THEN UPDATE hm2_user_balances SET amount = amount - OLD.actual_amount WHERE user_id = OLD.user_id AND ec = OLD.ec AND type = 'active_deposit'; END IF; IF (NEW.status = 'on') THEN SET f = (SELECT count(*) FROM hm2_user_balances WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = 'active_deposit'); IF (f > 0) THEN UPDATE hm2_user_balances SET amount = amount + NEW.actual_amount WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = 'active_deposit'; ELSE INSERT INTO hm2_user_balances SET amount = NEW.actual_amount, user_id = NEW.user_id, ec = NEW.ec, type = 'active_deposit'; END IF; END IF; END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_deposits_delete` BEFORE DELETE ON `hm2_deposits` FOR EACH ROW BEGIN UPDATE hm2_user_balances SET amount = amount - OLD.actual_amount WHERE user_id = OLD.user_id AND ec = OLD.ec AND type = 'active_deposit'; END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_deposit_addresses`
--

CREATE TABLE `hm2_deposit_addresses` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int UNSIGNED DEFAULT '0',
  `type_id` int UNSIGNED DEFAULT '0',
  `ec` int UNSIGNED DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `address` varchar(255) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_emails`
--

CREATE TABLE `hm2_emails` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `text` text,
  `html` text,
  `use_html` tinyint UNSIGNED DEFAULT '0',
  `status` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `use_presets` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_emails`
--

INSERT INTO `hm2_emails` (`id`, `name`, `subject`, `text`, `html`, `use_html`, `status`, `use_presets`) VALUES
('2fa_disabled_notification', '2FA Disable User Notification', '2FA Disabled', 'Hello #username#.\n\nTwo Factor Auth is disabled for your account by your request.\n\n\n#site_name#\n#site_url#', NULL, 0, 1, 1),
('2fa_enabled_notification', '2FA Enable User Notification', '2FA Enabled', 'Hello #username#.\n\nTwo Factor Auth is enabled for your account by your request.\n\n\n#site_name#\n#site_url#', NULL, 0, 1, 1),
('account_update_confirmation', 'Account Update Confirmation', 'Account Update Confirmation', 'Dear #name# (#username#),\n\nSomeone from IP address #ip# (most likely you) is trying to change your account data.\n\nTo confirm these changes please use this Confirmation Code:\n#confirmation_code#\n\nThank you.\n#site_name#\n#site_url#', '', 0, 1, 1),
('acsent_user', 'Send pin to user', 'Pin code', 'Hello #name#.\n\nSomeone tried login your account\nip: #ip#\nbrowser: #browser#\n\nPin code for entering your account is: #NEWPIN#\n\nThis code will be expired in 15 minutes.\n\n\n#site_name#\n#site_url#', NULL, 0, 1, 1),
('bonus', 'Bonus Notification', 'Bonus Notification', 'Hello #name#,\r\n\r\nYou received a bonus: $#amount#\r\nYou can check your statistics here:\r\n#site_url#\r\n\r\nGood luck.', '', 0, 1, 1),
('brute_force_activation', 'Account Activation after Brute Force', '#site_name# - Your account activation code.', 'Someone from IP #ip# has entered a password for your account \"#username#\" incorrectly #max_tries# times. System locked your accout until you activate it.\r\n\r\nClick here to activate your account :\r\n\r\n#site_url#?a=activate&code=#activation_code#\r\n\r\nThank you.\r\n#site_name#', '', 0, 1, 1),
('change_account', 'Account Change Notification', 'Account Change Notification', 'Hello #name#,\r\n\r\nYour account data has been changed from ip #ip#\r\n\r\n\r\nNew information:\r\n\r\nPassword: #password#\r\nE-gold account: #egold#\r\nE-mail address: #email#\r\n\r\nContact us immediately if you did not authorize this change.\r\n\r\nThank you.', '', 0, 1, 1),
('confirm_registration', 'Registration Confirmation', 'Confirm your registration', 'Hello #name#,\r\n\r\nThank you for registering in our program\r\nPlease confirm your registration or ignore this message.\r\n\r\nCopy and paste this link to your browser:\r\n#site_url#/?a=confirm_registration&c=#confirm_string#\r\n\r\nThank you.\r\n#site_name#', '', 0, 1, 1),
('deposit_account_admin_notification', 'Administrator Deposit Notification (from account balance)', 'A deposit has been processed', 'User #username# deposit #amount# #currency# from account balance to #plan#.\n\nAccount: #account#\nBatch: #batch#\nCompound: #compound#%.\nReferrers fee: #ref_sum#', NULL, 0, 1, 0),
('deposit_admin_notification', 'Administrator Deposit Notification', 'A deposit has been processed', 'User #username# deposit $#amount# #currency# to #plan#.\r\n\r\nAccount: #account#\r\nBatch: #batch#\r\nCompound: #compound#%.\r\nReferrers fee: $#ref_sum#', '', 0, 1, 0),
('deposit_approved_admin_notification', 'Deposit Approved Admin Notification', 'Deposit has been approved', 'Deposit has been approved:\n\nUser: #username# (#name#)\nAmount: $#amount# of #currency#\nPlan: #plan#\nDate: #deposit_date#\n#fields#', '', 0, 1, 0),
('deposit_approved_user_notification', 'Deposit Approved User Notification', 'Deposit has been approved', 'Dear #name#\n\nYour deposit has been approved:\n\nAmount: $#amount# of #currency#\nPlan: #plan#\n#fields#', '', 0, 1, 1),
('deposit_user_notification', 'Deposit User Notification', 'Payment received', 'Dear #name# (#username#)\r\n\r\nWe have successfully received your deposit $#amount# #currency# to #plan#.\r\n\r\nYour Account: #account#\r\nBatch: #batch#\r\nCompound: #compound#%.\r\n\r\n\r\nThank you.\r\n#site_name#\r\n#site_url#', '', 0, 1, 1),
('direct_signup_notification', 'Direct Referral Signup', 'You have a new direct signup on #site_name#', 'Dear #name# (#username#)\r\n\r\nYou have a new direct signup on #site_name#\r\nUser: #ref_username#\r\nName: #ref_name#\r\nE-mail: #ref_email#\r\n\r\nThank you.', '', 0, 1, 1),
('exchange_admin_notification', 'Exchange Admin Notification', 'Currency Exchange Processed', 'User #username# has exchanged $#amount_from# #currency_from# to $#amount_to# #currency_to#.', '', 0, 0, 0),
('exchange_user_notification', 'Exchange User Notification', 'Currency Exchange Completed', 'Dear #name# (#username#).\r\n\r\nYou have successfully exchanged $#amount_from# #currency_from# to $#amount_to# #currency_to#.\r\n\r\nThank you.\r\n#site_name#\r\n#site_url#', '', 0, 0, 1),
('forgot_password', 'Password Reminder', 'The password you requested', 'Hello #name#,\r\n\r\nSomeone (most likely you) requested your username and password from the IP #ip#.\r\nYour password has been changed!!!\r\n\r\nYou can log into our account with:\r\n\r\nUsername: #username#\r\nPassword: #password#\r\n\r\nHope that helps.', '', 0, 1, 1),
('forgot_password_confirm', 'Password Reminder Confirmation', 'Password request confirmation', 'Hello #name#,\r\n\r\nPlease confirm your reqest for password reqest.\r\n\r\nCopy and paste this link to your browser:\r\n#site_url#/?a=forgot_password&action=confirm&c=#confirm_string#\r\n\r\nThank you.\r\n#site_name#', '', 0, 1, 1),
('penalty', 'Penalty Notification', 'Penalty Notification', 'Hello #name#,\r\n\r\nYour account has been charged for $#amount#\r\nYou can check your statistics here:\r\n#site_url#\r\n\r\nGood luck.', '', 0, 1, 1),
('pending_deposit_admin_notification', 'Deposit Request Admin Notification', 'Deposit Request Notification', 'User #username# save deposit $#amount# of #currency# to #plan#.\r\n\r\n#fields#', '', 0, 1, 0),
('referral_commision_notification', 'Referral Comission Notification', '#site_name# Referral Comission', 'Dear #name# (#username#)\r\n\r\nYou have received a referral comission of $#amount# #currency# from the #ref_name# (#ref_username#) deposit.\r\n\r\nThank you.', '', 0, 1, 1),
('registration', 'Registration Completetion', 'Registration Info', 'Hello #name#,\r\n\r\nThank you for registration on our site.\r\n\r\nYour login information:\r\n\r\nLogin: #username#\r\nPassword: #password#\r\n\r\nYou can login here: #site_url#\r\n\r\nContact us immediately if you did not authorize this registration.\r\n\r\nThank you.', '', 0, 1, 1),
('registration_admin', 'Admin User Signup Notification', '#site_name# New Signup', 'New User Signup\n\nUsername: #username#\nName: #name#\nEmail: #email#\n', NULL, 0, 0, 0),
('tell_a_friend', 'Tell a friend', 'Friend invited you', 'Hello #name_invited#.\n\nYour friend #username# invited you\n\n#referal_link#\n\n\n#site_name#\n#site_url#', NULL, 0, 1, 1),
('transaction_code_recovery', 'Transaction code recovery', 'Transaction code', 'Hello #name#.\n\nYour transaction code is : #transaction_code#\n\n\n#site_name#\n#site_url#', NULL, 0, 1, 1),
('user_deposit_expired', 'Deposit expired to user', '#site_name# . Deposit expired', 'Hello #name#.\n\nDeposit you made #deposit_date# has been expired.\nDeposit amount: #deposit_amount#\nYour login: #username#.\n\n\n#site_name#\n#site_url#', NULL, 0, 0, 1),
('withdraw_admin_notification', 'Administrator Withdrawal Notification', 'Withdrawal has been sent', 'User #username# received $#amount# to #currency# account #account#. Batch is #batch#.', '', 0, 1, 0),
('withdraw_request_admin_notification', 'Administrator Withdrawal Request Notification', 'Withdrawal Request has been sent', 'User #username# requested to withdraw $#amount# from IP #ip#.', '', 0, 1, 0),
('withdraw_request_user_notification', 'User Withdrawal Request Notification', 'Withdrawal Request has been sent', 'Hello #name#,\r\n\r\n\r\nYou have requested to withdraw $#amount#.\r\nRequest IP address is #ip#.\r\n\r\n\r\nThank you.\r\n#site_name#\r\n#site_url#', '', 0, 1, 1),
('withdraw_user_notification', 'User Withdrawal Notification', 'Withdrawal has been sent', 'Hello #name#.\r\n\r\n$#amount# has been successfully sent to your #currency# account #account#.\r\nTransaction batch is #batch#.\r\n\r\n#site_name#\r\n#site_url#', '', 0, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `hm2_exchange_rates`
--

CREATE TABLE `hm2_exchange_rates` (
  `sfrom` int UNSIGNED DEFAULT NULL,
  `sto` int UNSIGNED DEFAULT NULL,
  `percent` float(10,2) DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_fchk`
--

CREATE TABLE `hm2_fchk` (
  `id` int NOT NULL,
  `filename` varchar(200) NOT NULL DEFAULT '',
  `key` varchar(50) NOT NULL DEFAULT '',
  `tdate` datetime NOT NULL,
  `inform` int NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_groups`
--

CREATE TABLE `hm2_groups` (
  `id` bigint NOT NULL,
  `name` text,
  `fields` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_history`
--

CREATE TABLE `hm2_history` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL DEFAULT '0',
  `amount` float(15,6) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `description` text NOT NULL,
  `actual_amount` float(15,6) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `str` varchar(40) NOT NULL DEFAULT '',
  `ec` int NOT NULL,
  `deposit_id` bigint NOT NULL DEFAULT '0',
  `confirm_delete` varchar(20) NOT NULL DEFAULT '',
  `hidden_batch` varchar(200) NOT NULL DEFAULT '',
  `rate` decimal(20,10) NOT NULL DEFAULT '1.0000000000',
  `batch` varchar(200) NOT NULL DEFAULT '',
  `stype` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Triggers `hm2_history`
--
DELIMITER $$
CREATE TRIGGER `after_history_insert` AFTER INSERT ON `hm2_history` FOR EACH ROW BEGIN DECLARE f INT; SET f = (SELECT count(*) FROM hm2_user_balances WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = 'balance'); IF (f > 0) THEN UPDATE hm2_user_balances SET amount = amount + NEW.actual_amount WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = 'balance'; ELSE INSERT INTO hm2_user_balances SET amount = NEW.actual_amount, user_id = NEW.user_id, ec = NEW.ec, type = 'balance'; END IF; SET f = (SELECT count(*) FROM hm2_user_balances WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = NEW.type); IF (f > 0) THEN UPDATE hm2_user_balances SET amount = amount + NEW.actual_amount WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = NEW.type; ELSE INSERT INTO hm2_user_balances SET amount = NEW.actual_amount, user_id = NEW.user_id, ec = NEW.ec, type = NEW.type; END IF; END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_history_update` AFTER UPDATE ON `hm2_history` FOR EACH ROW BEGIN DECLARE f INT; UPDATE hm2_user_balances SET amount = amount - OLD.actual_amount WHERE user_id = OLD.user_id AND ec = OLD.ec AND type = 'balance'; SET f = (SELECT count(*) FROM hm2_user_balances WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = 'balance'); IF (f > 0) THEN UPDATE hm2_user_balances SET amount = amount + NEW.actual_amount WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = 'balance'; ELSE INSERT INTO hm2_user_balances SET amount = NEW.actual_amount, user_id = NEW.user_id, ec = NEW.ec, type = 'balance'; END IF; UPDATE hm2_user_balances SET amount = amount - OLD.actual_amount WHERE user_id = OLD.user_id AND ec = OLD.ec AND type = OLD.type; SET f = (SELECT count(*) FROM hm2_user_balances WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = NEW.type); IF (f > 0) THEN UPDATE hm2_user_balances SET amount = amount + NEW.actual_amount WHERE user_id = NEW.user_id AND ec = NEW.ec AND type = NEW.type; ELSE INSERT INTO hm2_user_balances SET amount = NEW.actual_amount, user_id = NEW.user_id, ec = NEW.ec, type = NEW.type; END IF; END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_history_delete` BEFORE DELETE ON `hm2_history` FOR EACH ROW BEGIN UPDATE hm2_user_balances SET amount = amount - OLD.actual_amount WHERE user_id = OLD.user_id AND ec = OLD.ec AND type = 'balance'; UPDATE hm2_user_balances SET amount = amount - OLD.actual_amount WHERE user_id = OLD.user_id AND ec = OLD.ec AND type = OLD.type; END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_history_descriptions`
--

CREATE TABLE `hm2_history_descriptions` (
  `type_id` bigint NOT NULL,
  `date` datetime NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_holidays`
--

CREATE TABLE `hm2_holidays` (
  `id` int NOT NULL,
  `hd` date DEFAULT NULL,
  `hdescription` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_in_out_fees`
--

CREATE TABLE `hm2_in_out_fees` (
  `ec` int UNSIGNED NOT NULL DEFAULT '0',
  `in_percent` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `out_percent` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `in_add_amount` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `out_add_amount` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `in_fee_min` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `out_fee_min` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `in_fee_max` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `out_fee_max` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `in_amount_min` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `out_amount_min` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `in_amount_max` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `out_amount_max` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `out_amount_min_auto` decimal(20,8) NOT NULL DEFAULT '0.00000000',
  `out_amount_max_auto` decimal(20,8) NOT NULL DEFAULT '0.00000000'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_news`
--

CREATE TABLE `hm2_news` (
  `id` bigint NOT NULL,
  `date` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `small_text` text,
  `full_text` text,
  `image_url` varchar(255) DEFAULT '',
  `lang` varchar(255) NOT NULL DEFAULT 'default'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_online`
--

CREATE TABLE `hm2_online` (
  `ip` varchar(50) DEFAULT '',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_online`
--

INSERT INTO `hm2_online` (`ip`, `date`) VALUES
('170.205.30.11', '2025-06-27 07:29:57'),
('34.61.28.19', '2025-06-27 07:45:56'),
('152.39.178.203', '2025-06-27 07:46:45'),
('105.120.128.58', '2025-06-27 07:57:27');

-- --------------------------------------------------------

--
-- Table structure for table `hm2_pay_errors`
--

CREATE TABLE `hm2_pay_errors` (
  `id` bigint NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `txt` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_pay_settings`
--

CREATE TABLE `hm2_pay_settings` (
  `n` varchar(200) NOT NULL DEFAULT '',
  `v` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_pay_settings`
--

INSERT INTO `hm2_pay_settings` (`n`, `v`) VALUES
('settings_31', '697d6c052d5448057f0e2c0447504b067e262c26525a0626710c2f0374505a041b0601070801007324725f09617651050d0a0257040f750650014b0f5e713c7c7e605911725a2a48517c775829405a497e79012e7226060f530c42582d7406597f6f2b06790a460768261e2b7f684a2c5c7a70020b074901185770497859063e250a4b505f0f4f5d0d515b74795d2b5d7c7c020601706764106707'),
('settings_22', '69216c502d0b4b567f042c5047024b017e712c7d7c0b067171542f57745147072306605078540625127d5b58447042570d53580b570274557a515f01737c2e2752600311765a714b507c03580840584978795b2e32084b0f7f0c52580374044479572b677a7a06015710172f1018111b4c1463136c49'),
('settings_39', '69776c0c2d004b067f542c0d47014b027e732c23525b062371062f0b740b5a011b0601500806002224245f5b617651570d0a020a040f755150554b015e7d72207e605911725a354b6b7c68580c4049495579032e7f26480f6a0c7b580b740559536f38065c0a46077e262f2b7868592c777a710202071117636a04'),
('settings_11', '69776c0c2d004b067f542c0d47014b027e732c23525b062371062f0b740b5a011b0601500806002224245f5b617651570d0a020a040f755150554b015e7d72207e605911725a354b6b7c68580c4049495579032e7f26480f6a0c7b580b740559536f38065c0a46077e262f2b7868592c777a710202071117636a04'),
('settings_18', '69206c052d0748027f072c5547034b047e252c70520c067671062f0574515a0f1b0001020801002224235f0a617c51570d0002550406755050044b555e2774737e605911725a71486b7c67583a4040496b79692e1726580f7f0c085876740559536f38065c0a05077e262f2b7b68472c617a1a027c074a0126570149085948761c0a7250790f0f06216b48645f4e35477c69586e78152f2c7e76037508016313136d07');

-- --------------------------------------------------------

--
-- Table structure for table `hm2_pending_deposits`
--

CREATE TABLE `hm2_pending_deposits` (
  `id` bigint UNSIGNED NOT NULL,
  `ec` bigint UNSIGNED DEFAULT NULL,
  `fields` text,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT '0',
  `amount` float(12,6) NOT NULL DEFAULT '0.000000',
  `type_id` bigint UNSIGNED NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` enum('new','problem','processed') NOT NULL DEFAULT 'new',
  `compound` double(10,5) NOT NULL DEFAULT '0.00000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_plans`
--

CREATE TABLE `hm2_plans` (
  `id` bigint NOT NULL,
  `name` varchar(250) DEFAULT NULL,
  `description` text,
  `min_deposit` float(12,6) DEFAULT NULL,
  `max_deposit` float(12,6) DEFAULT NULL,
  `percent` float(10,2) DEFAULT NULL,
  `status` enum('on','off') DEFAULT NULL,
  `parent` bigint NOT NULL DEFAULT '0',
  `ext_id` bigint NOT NULL DEFAULT '0',
  `bonus_percent` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_plans`
--

INSERT INTO `hm2_plans` (`id`, `name`, `description`, `min_deposit`, `max_deposit`, `percent`, `status`, `parent`, `ext_id`, `bonus_percent`) VALUES
(1, 'Plan 1', NULL, 0.000000, 100.000000, 2.20, NULL, 1, 0, NULL),
(2, 'Plan 2', NULL, 101.000000, 1000.000000, 2.30, NULL, 1, 0, NULL),
(3, 'Plan 3', NULL, 1001.000000, 0.000000, 2.40, NULL, 1, 0, NULL),
(4, 'Plan 1', NULL, 10.000000, 100.000000, 3.20, NULL, 2, 0, NULL),
(5, 'Plan 2', NULL, 101.000000, 1000.000000, 3.30, NULL, 2, 0, NULL),
(6, 'Plan 3', NULL, 1001.000000, 5000.000000, 3.40, NULL, 2, 0, NULL),
(7, 'Plan 1', NULL, 10.000000, 100.000000, 10.00, NULL, 3, 0, NULL),
(8, 'Plan 2', NULL, 101.000000, 1000.000000, 20.00, NULL, 3, 0, NULL),
(9, 'Plan 3', NULL, 1001.000000, 0.000000, 50.00, NULL, 3, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `hm2_processings`
--

CREATE TABLE `hm2_processings` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `infofields` text,
  `status` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `description` text NOT NULL,
  `verify` tinyint(1) NOT NULL DEFAULT '0',
  `lang` varchar(10) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_processings`
--

INSERT INTO `hm2_processings` (`id`, `name`, `infofields`, `status`, `description`, `verify`, `lang`) VALUES
(999, 'Bank Wire', 'a:2:{s:7:\"deposit\";a:3:{i:1;s:9:\"Bank Name\";i:2;s:12:\"Account Name\";i:3;s:15:\"Payment Details\";}s:8:\"withdraw\";a:0:{}}', 0, 'Send your bank wires here:<br>\r\nBeneficiary\'s Bank Name: <b>Your Bank Name</b><br>\r\nBeneficiary\'s Bank SWIFT code: <b>Your Bank SWIFT code</b><br>\r\nBeneficiary\'s Bank Address: <b>Your Bank address</b><br>\r\nBeneficiary Account: <b>Your Account</b><br>\r\nBeneficiary Name: <b>Your Name</b><br>\r\n\r\nCorrespondent Bank Name: <b>Your Bank Name</b><br>\r\nCorrespondent Bank Address: <b>Your Bank Address</b><br>\r\nCorrespondent Bank codes: <b>Your Bank codes</b><br>\r\nABA: <b>Your ABA</b><br>', 0, ''),
(1000, 'e-Bullion', 'a:2:{s:7:\"deposit\";a:2:{i:1;s:13:\"Payer Account\";i:2;s:14:\"Transaction ID\";}s:8:\"withdraw\";a:0:{}}', 0, 'Please send your payments to this account: <b>Your e-Bullion account</b>', 0, ''),
(1001, 'NetPay', 'a:2:{s:7:\"deposit\";a:2:{i:1;s:13:\"Payer Account\";i:2;s:14:\"Transaction ID\";}s:8:\"withdraw\";a:0:{}}', 0, 'Send your funds to account: <b>Your NetPay account</b>', 0, ''),
(1002, 'GoldMoney', 'a:2:{s:7:\"deposit\";a:2:{i:1;s:13:\"Payer Account\";i:2;s:14:\"Transaction ID\";}s:8:\"withdraw\";a:0:{}}', 0, 'Send your fund to account: <b>your GoldMoney account</b>', 0, ''),
(1003, 'MoneyBookers', 'a:2:{s:7:\"deposit\";a:2:{i:1;s:13:\"Payer Account\";i:2;s:14:\"Transaction ID\";}s:8:\"withdraw\";a:0:{}}', 0, 'Send your funds to account: <b>your MoneyBookers account</b>', 0, ''),
(1004, 'Pecunix', 'a:2:{s:7:\"deposit\";a:2:{i:1;s:19:\"Your e-mail address\";i:2;s:16:\"Reference Number\";}s:8:\"withdraw\";a:0:{}}', 0, 'Send your funds to account: <b>your Pecunix account</b>', 0, ''),
(1005, 'PicPay', 'a:2:{s:7:\"deposit\";a:2:{i:1;s:13:\"Payer Account\";i:2;s:14:\"Transaction ID\";}s:8:\"withdraw\";a:0:{}}', 0, 'Send your funds to account: <b>Your PicPay account</b>', 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `hm2_referal`
--

CREATE TABLE `hm2_referal` (
  `id` bigint NOT NULL,
  `level` bigint NOT NULL DEFAULT '0',
  `name` varchar(200) DEFAULT NULL,
  `from_value` decimal(20,10) DEFAULT NULL,
  `to_value` decimal(20,10) DEFAULT NULL,
  `percent` double(10,2) DEFAULT NULL,
  `percent_daily` double(10,2) DEFAULT NULL,
  `percent_weekly` double(10,2) DEFAULT NULL,
  `percent_monthly` double(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_referal_stats`
--

CREATE TABLE `hm2_referal_stats` (
  `date` date NOT NULL,
  `user_id` bigint NOT NULL,
  `income` bigint NOT NULL,
  `reg` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_savelog`
--

CREATE TABLE `hm2_savelog` (
  `id` bigint NOT NULL,
  `log_text` text,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_savelog`
--

INSERT INTO `hm2_savelog` (`id`, `log_text`, `log_date`) VALUES
(1, '[[[pv1wBPZ/wwPlUqqdkfRNHqq/hpjAvQ6ORP5q8M0kjSd6oexQwAsP4PxxUyGjojq45cv/FfCnbLbl4+Kv0ENTbAVtXteuKMpYGGHW+oRm8f1jytx76JxLmpu8e1WCd48kJC9rYvUoXMdrfAwGAiRp6R0Xo0g49rLGcaNxYZ69TQs=]]]', '2025-06-27 07:55:31');

-- --------------------------------------------------------

--
-- Table structure for table `hm2_settings`
--

CREATE TABLE `hm2_settings` (
  `name` varchar(200) NOT NULL DEFAULT '',
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_settings`
--

INSERT INTO `hm2_settings` (`name`, `value`) VALUES
('update_id_news', '1'),
('update_id_user_notices', '1'),
('update_id', '102'),
('sr', '0'),
('srt', '2025-06-27 07:55:31');

-- --------------------------------------------------------

--
-- Table structure for table `hm2_tell_friend`
--

CREATE TABLE `hm2_tell_friend` (
  `user_id` bigint NOT NULL DEFAULT '0',
  `d` datetime NOT NULL,
  `email` varchar(250) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_types`
--

CREATE TABLE `hm2_types` (
  `id` bigint NOT NULL,
  `name` varchar(250) DEFAULT NULL,
  `description` text,
  `q_days` bigint DEFAULT NULL,
  `min_deposit` float(15,6) DEFAULT NULL,
  `max_deposit` float(15,6) DEFAULT NULL,
  `period` varchar(10) DEFAULT NULL,
  `status` enum('on','off','suspended') DEFAULT NULL,
  `return_profit` enum('0','1') DEFAULT NULL,
  `return_profit_percent` float(10,2) DEFAULT NULL,
  `percent` float(10,2) DEFAULT NULL,
  `pay_to_egold_directly` int NOT NULL DEFAULT '0',
  `use_compound` int NOT NULL,
  `work_week` int NOT NULL,
  `parent` int NOT NULL,
  `withdraw_principal` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `withdraw_principal_percent` double(10,2) NOT NULL DEFAULT '0.00',
  `withdraw_principal_duration` int UNSIGNED NOT NULL DEFAULT '0',
  `compound_min_deposit` double(15,6) DEFAULT '0.000000',
  `compound_max_deposit` double(15,6) DEFAULT '0.000000',
  `compound_percents_type` tinyint UNSIGNED DEFAULT '0',
  `compound_min_percent` double(10,2) DEFAULT '0.00',
  `compound_max_percent` double(10,2) DEFAULT '100.00',
  `compound_percents` text,
  `closed` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `withdraw_principal_duration_max` int UNSIGNED NOT NULL DEFAULT '0',
  `dsc` text,
  `hold` int NOT NULL,
  `delay` int NOT NULL,
  `ordering` int NOT NULL,
  `deposits_limit_num` int DEFAULT '0',
  `rpcp` float(15,2) NOT NULL DEFAULT '0.00',
  `ouma` float(15,2) NOT NULL DEFAULT '0.00',
  `pax_utype` int NOT NULL DEFAULT '0',
  `dawifi` int NOT NULL DEFAULT '0',
  `pae` bigint NOT NULL DEFAULT '0',
  `amount_mult` decimal(20,10) NOT NULL DEFAULT '1.0000000000',
  `data` text,
  `rc` decimal(6,2) DEFAULT NULL,
  `allow_internal_deps` int NOT NULL DEFAULT '1',
  `allow_external_deps` int NOT NULL DEFAULT '1',
  `s` int NOT NULL DEFAULT '0',
  `move_to_plan` int UNSIGNED NOT NULL DEFAULT '0',
  `move_to_plan_perc` decimal(10,4) NOT NULL DEFAULT '100.0000',
  `compound_return` tinyint(1) NOT NULL DEFAULT '0',
  `power_unit` varchar(10) NOT NULL DEFAULT '',
  `power_rate` decimal(20,8) NOT NULL DEFAULT '1.00000000',
  `power_ec` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_types`
--

INSERT INTO `hm2_types` (`id`, `name`, `description`, `q_days`, `min_deposit`, `max_deposit`, `period`, `status`, `return_profit`, `return_profit_percent`, `percent`, `pay_to_egold_directly`, `use_compound`, `work_week`, `parent`, `withdraw_principal`, `withdraw_principal_percent`, `withdraw_principal_duration`, `compound_min_deposit`, `compound_max_deposit`, `compound_percents_type`, `compound_min_percent`, `compound_max_percent`, `compound_percents`, `closed`, `withdraw_principal_duration_max`, `dsc`, `hold`, `delay`, `ordering`, `deposits_limit_num`, `rpcp`, `ouma`, `pax_utype`, `dawifi`, `pae`, `amount_mult`, `data`, `rc`, `allow_internal_deps`, `allow_external_deps`, `s`, `move_to_plan`, `move_to_plan_perc`, `compound_return`, `power_unit`, `power_rate`, `power_ec`) VALUES
(1, '1 year 2.4% daily', NULL, 365, NULL, NULL, 'd', 'on', '0', 0.00, NULL, 0, 0, 0, 0, 0, 0.00, 0, 0.000000, 0.000000, 0, 0.00, 100.00, '', 0, 0, '', 0, 0, 1, 0, 0.00, 0.00, 0, 0, 0, 1.0000000000, NULL, NULL, 1, 1, 0, 0, 100.0000, 0, '', 1.00000000, 0),
(2, '100 days 3.4% daily', NULL, 365, NULL, NULL, 'd', 'on', '0', 0.00, NULL, 0, 0, 0, 0, 0, 0.00, 0, 0.000000, 0.000000, 0, 0.00, 100.00, '', 0, 0, '', 0, 0, 2, 0, 0.00, 0.00, 0, 0, 0, 1.0000000000, NULL, NULL, 1, 1, 0, 0, 100.0000, 0, '', 1.00000000, 0),
(3, '30 days deposit. 150%', NULL, 30, NULL, NULL, 'end', 'on', '1', 0.00, NULL, 0, 0, 0, 0, 0, 0.00, 0, 0.000000, 0.000000, 0, 0.00, 100.00, '', 0, 0, '', 0, 0, 3, 0, 0.00, 0.00, 0, 0, 0, 1.0000000000, NULL, NULL, 1, 1, 0, 0, 100.0000, 0, '', 1.00000000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `hm2_users`
--

CREATE TABLE `hm2_users` (
  `id` bigint NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `date_register` datetime DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `status` enum('on','off','suspended') DEFAULT NULL,
  `came_from` text NOT NULL,
  `ref` bigint NOT NULL DEFAULT '0',
  `deposit_total` float(10,2) NOT NULL DEFAULT '0.00',
  `confirm_string` varchar(200) NOT NULL DEFAULT '',
  `password_confimation` varchar(200) NOT NULL DEFAULT '',
  `ip_reg` varchar(50) DEFAULT '',
  `last_access_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_access_ip` varchar(50) DEFAULT '',
  `stat_password` varchar(200) NOT NULL,
  `auto_withdraw` int NOT NULL DEFAULT '1',
  `user_auto_pay_earning` int NOT NULL,
  `admin_auto_pay_earning` int NOT NULL,
  `pswd` varchar(50) NOT NULL,
  `hid` varchar(50) NOT NULL,
  `l_e_t` datetime NOT NULL DEFAULT '2004-01-01 00:00:00',
  `activation_code` varchar(50) NOT NULL,
  `bf_counter` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `transaction_code` varchar(255) DEFAULT NULL,
  `ac` text NOT NULL,
  `accounts` text,
  `sq` text NOT NULL,
  `sa` text NOT NULL,
  `reg_fee` decimal(20,10) NOT NULL DEFAULT '0.0000000000',
  `home_phone` varchar(200) NOT NULL DEFAULT '',
  `cell_phone` varchar(200) NOT NULL DEFAULT '',
  `work_phone` varchar(200) NOT NULL DEFAULT '',
  `verify` int NOT NULL DEFAULT '0',
  `pax_utype` int NOT NULL DEFAULT '0',
  `gfst_phone` varchar(20) NOT NULL DEFAULT '',
  `add_fields` text,
  `admin_desc` text,
  `max_daily_withdraw` decimal(20,10) DEFAULT '0.0000000000',
  `group_id` bigint NOT NULL DEFAULT '0',
  `tfa_flag` tinyint(1) DEFAULT NULL,
  `demo_acc` tinyint(1) NOT NULL DEFAULT '0',
  `mult` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `mult_last_check` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_users`
--

INSERT INTO `hm2_users` (`id`, `name`, `username`, `password`, `date_register`, `email`, `status`, `came_from`, `ref`, `deposit_total`, `confirm_string`, `password_confimation`, `ip_reg`, `last_access_time`, `last_access_ip`, `stat_password`, `auto_withdraw`, `user_auto_pay_earning`, `admin_auto_pay_earning`, `pswd`, `hid`, `l_e_t`, `activation_code`, `bf_counter`, `address`, `city`, `state`, `zip`, `country`, `transaction_code`, `ac`, `accounts`, `sq`, `sa`, `reg_fee`, `home_phone`, `cell_phone`, `work_phone`, `verify`, `pax_utype`, `gfst_phone`, `add_fields`, `admin_desc`, `max_daily_withdraw`, `group_id`, `tfa_flag`, `demo_acc`, `mult`, `mult_last_check`) VALUES
(1, 'admin name', 'admin', '12cab44a31879a8935ed8a5d11c62ed1', NULL, 'info@quantivexcapital.com', 'on', '     ', 0, 0.00, '', '', '', '2025-06-27 07:56:46', '105.120.128.58', '', 1, 0, 0, '', '082DE6E32D197308DB1756987F71D4', '2004-01-01 00:00:00', '', 0, NULL, NULL, NULL, NULL, NULL, NULL, '2402070c3d460d097c642526412357451d2c32127e4a7f000a14225c4451242a2427177d470b73717812215c315d53421957455f31352431177d470b7a7f60542c4a245a5c5322170c437c737b61502b55582e6779437f0b7002125f285358703733202d412f42543a2623402c4d24541e552958150b357c70710f64585031311d523756324b5544640e440a74737b615c28525e023437512b4d2c4e554e2554475932272d6d56295913793678077f1b29594342195c47127d357b71007c16582c232d70344c2456445f30504f5327362837542a1a522d28600b3603760212462f5b150b357c717917640f42787c78123150285d4342275847127d2f7b730e3b', NULL, '', '', 0.0000000000, '', '', '', 0, 0, '', NULL, NULL, 0.0000000000, 0, NULL, 0, 0, NULL),
(2, 'Bespoke Quantum', 'gt', '518ed29525738cebdac49c49e60ea9d3', '2025-06-27 07:56:07', 'officialheolad@gmail.com', 'on', '', 0, 0.00, '', '', '', '2025-06-27 07:57:27', '105.120.128.58', '', 0, 0, 0, '', 'EDAA9D19C35A07D59E37EFB29E38FD', '2025-06-27 07:57:27', '', 0, NULL, NULL, NULL, NULL, NULL, NULL, '', 'a:0:{}', '', '', 0.0000000000, '', '', '', 0, 0, '', 'a:0:{}', '', 0.0000000000, 0, NULL, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `hm2_user_access_log`
--

CREATE TABLE `hm2_user_access_log` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL DEFAULT '0',
  `date` datetime DEFAULT NULL,
  `ip` varchar(50) DEFAULT '',
  `user_agent` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hm2_user_access_log`
--

INSERT INTO `hm2_user_access_log` (`id`, `user_id`, `date`, `ip`, `user_agent`) VALUES
(1, 1, '2025-06-27 07:55:29', '105.120.128.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) Gecko/20100101 Firefox/140.0'),
(2, 2, '2025-06-27 07:57:24', '105.120.128.58', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) Gecko/20100101 Firefox/140.0');

-- --------------------------------------------------------

--
-- Table structure for table `hm2_user_balances`
--

CREATE TABLE `hm2_user_balances` (
  `user_id` int UNSIGNED DEFAULT NULL,
  `ec` int UNSIGNED DEFAULT NULL,
  `amount` decimal(20,10) DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_user_notices`
--

CREATE TABLE `hm2_user_notices` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int UNSIGNED DEFAULT '0',
  `date` datetime DEFAULT NULL,
  `expiration` int UNSIGNED DEFAULT '0',
  `text` text,
  `title` varchar(255) DEFAULT NULL,
  `notified` tinyint(1) DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hm2_wires`
--

CREATE TABLE `hm2_wires` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `pname` varchar(250) NOT NULL,
  `paddress` varchar(250) NOT NULL,
  `pzip` varchar(250) NOT NULL,
  `pcity` varchar(250) NOT NULL,
  `pstate` varchar(250) NOT NULL,
  `pcountry` varchar(250) NOT NULL,
  `bname` varchar(250) NOT NULL,
  `baddress` varchar(250) NOT NULL,
  `bzip` varchar(250) NOT NULL,
  `bcity` varchar(250) NOT NULL,
  `bstate` varchar(250) NOT NULL,
  `bcountry` varchar(250) NOT NULL,
  `baccount` varchar(250) NOT NULL,
  `biban` varchar(250) NOT NULL,
  `bswift` varchar(250) NOT NULL,
  `amount` float(10,5) DEFAULT NULL,
  `type_id` bigint DEFAULT NULL,
  `wire_date` datetime NOT NULL,
  `compound` float(10,5) DEFAULT NULL,
  `status` enum('new','problem','processed') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hm2_coins_transactions`
--
ALTER TABLE `hm2_coins_transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_deposits`
--
ALTER TABLE `hm2_deposits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hi1` (`user_id`),
  ADD KEY `hi2` (`deposit_date`),
  ADD KEY `hi3` (`status`),
  ADD KEY `hi4` (`user_id`,`status`);

--
-- Indexes for table `hm2_deposit_addresses`
--
ALTER TABLE `hm2_deposit_addresses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `addr` (`address`(40));

--
-- Indexes for table `hm2_emails`
--
ALTER TABLE `hm2_emails`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `hm2_fchk`
--
ALTER TABLE `hm2_fchk`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_groups`
--
ALTER TABLE `hm2_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_history`
--
ALTER TABLE `hm2_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hi1` (`type`),
  ADD KEY `hi2` (`user_id`,`type`),
  ADD KEY `hi3` (`user_id`,`type`,`date`),
  ADD KEY `hi4` (`type`,`ec`),
  ADD KEY `hi5` (`date`,`deposit_id`),
  ADD KEY `hi6` (`date`,`type`),
  ADD KEY `hi7` (`date`,`type`,`deposit_id`),
  ADD KEY `d2` (`deposit_id`);

--
-- Indexes for table `hm2_holidays`
--
ALTER TABLE `hm2_holidays`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_news`
--
ALTER TABLE `hm2_news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_online`
--
ALTER TABLE `hm2_online`
  ADD KEY `d2` (`ip`);

--
-- Indexes for table `hm2_pay_errors`
--
ALTER TABLE `hm2_pay_errors`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_pending_deposits`
--
ALTER TABLE `hm2_pending_deposits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hi1` (`user_id`,`status`,`ec`);

--
-- Indexes for table `hm2_plans`
--
ALTER TABLE `hm2_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_processings`
--
ALTER TABLE `hm2_processings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_referal`
--
ALTER TABLE `hm2_referal`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_savelog`
--
ALTER TABLE `hm2_savelog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_types`
--
ALTER TABLE `hm2_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_users`
--
ALTER TABLE `hm2_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hi1` (`status`);

--
-- Indexes for table `hm2_user_access_log`
--
ALTER TABLE `hm2_user_access_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `d_idx` (`date`),
  ADD KEY `ip_idx` (`ip`),
  ADD KEY `idip` (`id`,`date`,`ip`);

--
-- Indexes for table `hm2_user_balances`
--
ALTER TABLE `hm2_user_balances`
  ADD KEY `hi1` (`user_id`),
  ADD KEY `hi2` (`user_id`,`ec`,`type`);

--
-- Indexes for table `hm2_user_notices`
--
ALTER TABLE `hm2_user_notices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hm2_wires`
--
ALTER TABLE `hm2_wires`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hm2_coins_transactions`
--
ALTER TABLE `hm2_coins_transactions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_deposits`
--
ALTER TABLE `hm2_deposits`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_deposit_addresses`
--
ALTER TABLE `hm2_deposit_addresses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_fchk`
--
ALTER TABLE `hm2_fchk`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_groups`
--
ALTER TABLE `hm2_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_history`
--
ALTER TABLE `hm2_history`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_holidays`
--
ALTER TABLE `hm2_holidays`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_news`
--
ALTER TABLE `hm2_news`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_pay_errors`
--
ALTER TABLE `hm2_pay_errors`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_pending_deposits`
--
ALTER TABLE `hm2_pending_deposits`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_plans`
--
ALTER TABLE `hm2_plans`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `hm2_processings`
--
ALTER TABLE `hm2_processings`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1006;

--
-- AUTO_INCREMENT for table `hm2_referal`
--
ALTER TABLE `hm2_referal`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_savelog`
--
ALTER TABLE `hm2_savelog`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `hm2_types`
--
ALTER TABLE `hm2_types`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `hm2_users`
--
ALTER TABLE `hm2_users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hm2_user_access_log`
--
ALTER TABLE `hm2_user_access_log`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hm2_user_notices`
--
ALTER TABLE `hm2_user_notices`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hm2_wires`
--
ALTER TABLE `hm2_wires`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
