CREATE TABLE IF NOT EXISTS `kd_bans` (
  `author` varchar(40) DEFAULT NULL,
  `player` varchar(40) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `ip` varchar(25) DEFAULT NULL,
  `discord` varchar(40) DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `ban_time` int(50) NOT NULL,
  `exp_time` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;