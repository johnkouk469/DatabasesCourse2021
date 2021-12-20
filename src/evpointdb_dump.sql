DROP SCHEMA IF EXISTS `evpointdb`;
CREATE SCHEMA `evpointdb`;
USE `evpointdb`;

-- MySQL dump 10.13  Distrib 8.0.27, for Win64 (x86_64)
--
-- Host: localhost    Database: evpointdb
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `car`
--

DROP TABLE IF EXISTS `car`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car` (
  `licenseNumber` char(7) NOT NULL,
  `name` varchar(25) DEFAULT NULL,
  `photo` blob,
  `notes` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`licenseNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chargingstation`
--

DROP TABLE IF EXISTS `chargingstation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chargingstation` (
  `companyName` varchar(25) NOT NULL,
  `latitude` decimal(8,6) NOT NULL,
  `longtitude` decimal(8,6) NOT NULL,
  PRIMARY KEY (`companyName`,`latitude`,`longtitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `chargingstationmeanstars`
--

DROP TABLE IF EXISTS `chargingstationmeanstars`;
/*!50001 DROP VIEW IF EXISTS `chargingstationmeanstars`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `chargingstationmeanstars` AS SELECT 
 1 AS `chargingStation_companyName`,
 1 AS `chargingStation_latitude`,
 1 AS `chargingStation_longtitude`,
 1 AS `meanStars`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `connector`
--

DROP TABLE IF EXISTS `connector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `connector` (
  `connectorID` int NOT NULL,
  `connectorType` enum('Tesla TYPE 2','TYPE 2','CCS2') DEFAULT NULL,
  `availability` int DEFAULT NULL,
  `chargingStation_companyName` varchar(25) NOT NULL,
  `chargingStation_latitude` decimal(8,6) NOT NULL,
  `chargingStation_longtitude` decimal(8,6) NOT NULL,
  PRIMARY KEY (`connectorID`),
  KEY `fk_Connector_chargingStation1_idx` (`chargingStation_companyName`,`chargingStation_latitude`,`chargingStation_longtitude`),
  CONSTRAINT `fk_Connector_chargingStation1` FOREIGN KEY (`chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) REFERENCES `chargingstation` (`companyName`, `latitude`, `longtitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `health`
--

DROP TABLE IF EXISTS `health`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health` (
  `healthTimeStamp` timestamp(3) NOT NULL,
  `engineHealth` decimal(6,3) DEFAULT NULL,
  `batteryHealth` decimal(6,3) DEFAULT NULL,
  `tirePressure` decimal(6,3) DEFAULT NULL,
  `tireCondition` decimal(6,3) DEFAULT NULL,
  `batteryPercentage` decimal(6,3) DEFAULT NULL,
  `Car_licenseNumber` char(7) NOT NULL,
  PRIMARY KEY (`healthTimeStamp`,`Car_licenseNumber`),
  KEY `fk_Health_Car1_idx` (`Car_licenseNumber`),
  CONSTRAINT `fk_Health_Car1` FOREIGN KEY (`Car_licenseNumber`) REFERENCES `car` (`licenseNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `nearavailconnectors`
--

DROP TABLE IF EXISTS `nearavailconnectors`;
/*!50001 DROP VIEW IF EXISTS `nearavailconnectors`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `nearavailconnectors` AS SELECT 
 1 AS `userID`,
 1 AS `connectorID`,
 1 AS `chargingStation_companyName`,
 1 AS `chargingStation_latitude`,
 1 AS `chargingStation_longtitude`,
 1 AS `connectorType`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `nearrsa`
--

DROP TABLE IF EXISTS `nearrsa`;
/*!50001 DROP VIEW IF EXISTS `nearrsa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `nearrsa` AS SELECT 
 1 AS `userID`,
 1 AS `rsaNumber`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `occupiedconnector`
--

DROP TABLE IF EXISTS `occupiedconnector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occupiedconnector` (
  `OccupiedConnectorID` int NOT NULL,
  `connectedCarLN` char(7) NOT NULL,
  `occupiedFrom` timestamp(3) NULL DEFAULT NULL,
  `occupiedUntil` timestamp(3) NULL DEFAULT NULL,
  `occupiedEstimatedUntil` timestamp(3) NULL DEFAULT NULL,
  PRIMARY KEY (`OccupiedConnectorID`,`connectedCarLN`),
  KEY `carLicenseNumber_idx` (`connectedCarLN`),
  CONSTRAINT `carLicenseNumber` FOREIGN KEY (`connectedCarLN`) REFERENCES `car` (`licenseNumber`),
  CONSTRAINT `occupiedConnectorID` FOREIGN KEY (`OccupiedConnectorID`) REFERENCES `connector` (`connectorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rsa`
--

DROP TABLE IF EXISTS `rsa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rsa` (
  `phoneNumber` int NOT NULL,
  `name` varchar(25) DEFAULT NULL,
  `longtitude` decimal(8,6) DEFAULT NULL,
  `latitude` decimal(8,6) DEFAULT NULL,
  PRIMARY KEY (`phoneNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userID` char(6) NOT NULL,
  `phoneNumber` int unsigned DEFAULT NULL,
  `longtitude` decimal(8,6) DEFAULT NULL,
  `latitude` decimal(8,6) DEFAULT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `phoneNumber_UNIQUE` (`phoneNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_calls_rsa`
--

DROP TABLE IF EXISTS `user_calls_rsa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_calls_rsa` (
  `User_userID` char(6) NOT NULL,
  `RSA_phoneNumber` int NOT NULL,
  `timestamp` timestamp(6) NOT NULL,
  `callerLattitude` decimal(8,6) DEFAULT NULL,
  `callerLongtitude` decimal(8,6) DEFAULT NULL,
  PRIMARY KEY (`User_userID`,`RSA_phoneNumber`,`timestamp`),
  KEY `fk_User_has_RSA_RSA1_idx` (`RSA_phoneNumber`),
  KEY `fk_User_has_RSA_User1_idx` (`User_userID`),
  CONSTRAINT `fk_User_has_RSA_RSA1` FOREIGN KEY (`RSA_phoneNumber`) REFERENCES `rsa` (`phoneNumber`),
  CONSTRAINT `fk_User_has_RSA_User1` FOREIGN KEY (`User_userID`) REFERENCES `user` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_drives_car`
--

DROP TABLE IF EXISTS `user_drives_car`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_drives_car` (
  `car_licenseNumber` char(7) NOT NULL,
  `user_userID` char(6) NOT NULL,
  PRIMARY KEY (`car_licenseNumber`,`user_userID`),
  KEY `fk_car_has_user_user1_idx` (`user_userID`),
  CONSTRAINT `fk_car_has_user_car1` FOREIGN KEY (`car_licenseNumber`) REFERENCES `car` (`licenseNumber`),
  CONSTRAINT `fk_car_has_user_user1` FOREIGN KEY (`user_userID`) REFERENCES `user` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_owns_car`
--

DROP TABLE IF EXISTS `user_owns_car`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_owns_car` (
  `User_userID` char(6) NOT NULL,
  `Car_licenseNumber` char(7) NOT NULL,
  PRIMARY KEY (`User_userID`,`Car_licenseNumber`),
  KEY `fk_User_has_Car_Car1_idx` (`Car_licenseNumber`),
  KEY `fk_User_has_Car_User_idx` (`User_userID`),
  CONSTRAINT `fk_User_has_Car_Car1` FOREIGN KEY (`Car_licenseNumber`) REFERENCES `car` (`licenseNumber`),
  CONSTRAINT `fk_User_has_Car_User` FOREIGN KEY (`User_userID`) REFERENCES `user` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_reviews_chargingstation`
--

DROP TABLE IF EXISTS `user_reviews_chargingstation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_reviews_chargingstation` (
  `User_userID` char(6) NOT NULL,
  `chargingStation_companyName` varchar(25) NOT NULL,
  `chargingStation_latitude` decimal(8,6) NOT NULL,
  `chargingStation_longtitude` decimal(8,6) NOT NULL,
  `stars` int DEFAULT NULL,
  `comment` varchar(512) DEFAULT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`User_userID`,`chargingStation_companyName`,`chargingStation_latitude`,`chargingStation_longtitude`,`date`),
  KEY `fk_User_has_chargingStation_chargingStation1_idx` (`chargingStation_companyName`,`chargingStation_latitude`,`chargingStation_longtitude`),
  KEY `fk_User_has_chargingStation_User1_idx` (`User_userID`),
  CONSTRAINT `fk_User_has_chargingStation_chargingStation1` FOREIGN KEY (`chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) REFERENCES `chargingstation` (`companyName`, `latitude`, `longtitude`),
  CONSTRAINT `fk_User_has_chargingStation_User1` FOREIGN KEY (`User_userID`) REFERENCES `user` (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `chargingstationmeanstars`
--

/*!50001 DROP VIEW IF EXISTS `chargingstationmeanstars`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `chargingstationmeanstars` AS select `user_reviews_chargingstation`.`chargingStation_companyName` AS `chargingStation_companyName`,`user_reviews_chargingstation`.`chargingStation_latitude` AS `chargingStation_latitude`,`user_reviews_chargingstation`.`chargingStation_longtitude` AS `chargingStation_longtitude`,avg(`user_reviews_chargingstation`.`stars`) AS `meanStars` from (`user_reviews_chargingstation` join `chargingstation` on(((`user_reviews_chargingstation`.`chargingStation_companyName` = `chargingstation`.`companyName`) and (`user_reviews_chargingstation`.`chargingStation_latitude` = `chargingstation`.`latitude`) and (`user_reviews_chargingstation`.`chargingStation_longtitude` = `chargingstation`.`longtitude`)))) group by `user_reviews_chargingstation`.`chargingStation_companyName`,`user_reviews_chargingstation`.`chargingStation_latitude`,`user_reviews_chargingstation`.`chargingStation_longtitude` order by `meanStars` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nearavailconnectors`
--

/*!50001 DROP VIEW IF EXISTS `nearavailconnectors`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nearavailconnectors` AS select `user`.`userID` AS `userID`,`connector`.`connectorID` AS `connectorID`,`connector`.`chargingStation_companyName` AS `chargingStation_companyName`,`connector`.`chargingStation_latitude` AS `chargingStation_latitude`,`connector`.`chargingStation_longtitude` AS `chargingStation_longtitude`,`connector`.`connectorType` AS `connectorType` from (`user` join `connector`) where ((`user`.`latitude` > (`connector`.`chargingStation_latitude` - 0.75)) and (`user`.`latitude` < (`connector`.`chargingStation_latitude` + 0.75)) and (`user`.`longtitude` > (`connector`.`chargingStation_longtitude` - 0.75)) and (`user`.`longtitude` < (`connector`.`chargingStation_longtitude` + 0.75)) and (`connector`.`availability` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nearrsa`
--

/*!50001 DROP VIEW IF EXISTS `nearrsa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nearrsa` AS select `user`.`userID` AS `userID`,`rsa`.`phoneNumber` AS `rsaNumber` from (`user` join `rsa`) where ((`user`.`latitude` > (`rsa`.`latitude` - 0.1)) and (`user`.`latitude` < (`rsa`.`latitude` + 0.1)) and (`user`.`longtitude` > (`rsa`.`longtitude` - 0.1)) and (`user`.`longtitude` < (`rsa`.`longtitude` + 0.1))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-12-20  3:16:35
