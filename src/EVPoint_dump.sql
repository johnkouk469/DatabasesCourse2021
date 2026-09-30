-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema evpointdb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `evpointdb` ;

-- -----------------------------------------------------
-- Schema evpointdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `evpointdb` DEFAULT CHARACTER SET utf8 ;
USE `evpointdb` ;

-- -----------------------------------------------------
-- Table `evpointdb`.`car`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`car` (
  `licenseNumber` CHAR(7) NOT NULL,
  `name` VARCHAR(25) NULL DEFAULT NULL,
  `photo` BLOB NULL DEFAULT NULL,
  `notes` VARCHAR(512) NULL DEFAULT NULL,
  PRIMARY KEY (`licenseNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`chargingstation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`chargingstation` (
  `companyName` VARCHAR(25) NOT NULL,
  `latitude` DECIMAL(8,6) NOT NULL,
  `longtitude` DECIMAL(8,6) NOT NULL,
  PRIMARY KEY (`companyName`, `latitude`, `longtitude`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`connector`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`connector` (
  `connectorID` INT NOT NULL,
  `connectorType` ENUM('Tesla TYPE 2', 'TYPE 2', 'CCS2') NULL DEFAULT NULL,
  `availability` INT NULL DEFAULT NULL,
  `chargingStation_companyName` VARCHAR(25) NOT NULL,
  `chargingStation_latitude` DECIMAL(8,6) NOT NULL,
  `chargingStation_longtitude` DECIMAL(8,6) NOT NULL,
  PRIMARY KEY (`connectorID`),
  INDEX `fk_Connector_chargingStation1_idx` (`chargingStation_companyName` ASC, `chargingStation_latitude` ASC, `chargingStation_longtitude` ASC) VISIBLE,
  CONSTRAINT `fk_Connector_chargingStation1`
    FOREIGN KEY (`chargingStation_companyName` , `chargingStation_latitude` , `chargingStation_longtitude`)
    REFERENCES `evpointdb`.`chargingstation` (`companyName` , `latitude` , `longtitude`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`health`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`health` (
  `healthTimeStamp` TIMESTAMP(3) NOT NULL,
  `engineHealth` DECIMAL(6,3) NULL DEFAULT NULL,
  `batteryHealth` DECIMAL(6,3) NULL DEFAULT NULL,
  `tirePressure` DECIMAL(6,3) NULL DEFAULT NULL,
  `tireCondition` DECIMAL(6,3) NULL DEFAULT NULL,
  `batteryPercentage` DECIMAL(6,3) NULL DEFAULT NULL,
  `Car_licenseNumber` CHAR(7) NOT NULL,
  PRIMARY KEY (`healthTimeStamp`, `Car_licenseNumber`),
  INDEX `fk_Health_Car1_idx` (`Car_licenseNumber` ASC) VISIBLE,
  CONSTRAINT `fk_Health_Car1`
    FOREIGN KEY (`Car_licenseNumber`)
    REFERENCES `evpointdb`.`car` (`licenseNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`occupiedconnector`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`occupiedconnector` (
  `OccupiedConnectorID` INT NOT NULL,
  `connectedCarLN` CHAR(7) NOT NULL,
  `occupiedFrom` TIMESTAMP(3) NULL DEFAULT NULL,
  `occupiedUntil` TIMESTAMP(3) NULL DEFAULT NULL,
  `occupiedEstimatedUntil` TIMESTAMP(3) NULL DEFAULT NULL,
  PRIMARY KEY (`OccupiedConnectorID`, `connectedCarLN`),
  INDEX `carLicenseNumber_idx` (`connectedCarLN` ASC) VISIBLE,
  CONSTRAINT `carLicenseNumber`
    FOREIGN KEY (`connectedCarLN`)
    REFERENCES `evpointdb`.`car` (`licenseNumber`),
  CONSTRAINT `occupiedConnectorID`
    FOREIGN KEY (`OccupiedConnectorID`)
    REFERENCES `evpointdb`.`connector` (`connectorID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`rsa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`rsa` (
  `phoneNumber` INT NOT NULL,
  `name` VARCHAR(25) NULL DEFAULT NULL,
  `longtitude` DECIMAL(8,6) NULL DEFAULT NULL,
  `latitude` DECIMAL(8,6) NULL DEFAULT NULL,
  PRIMARY KEY (`phoneNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`user` (
  `userID` CHAR(6) NOT NULL,
  `phoneNumber` INT UNSIGNED NULL DEFAULT NULL,
  `longtitude` DECIMAL(8,6) NULL DEFAULT NULL,
  `latitude` DECIMAL(8,6) NULL DEFAULT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE INDEX `phoneNumber_UNIQUE` (`phoneNumber` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`user_calls_rsa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`user_calls_rsa` (
  `User_userID` CHAR(6) NOT NULL,
  `RSA_phoneNumber` INT NOT NULL,
  `timestamp` TIMESTAMP(6) NOT NULL,
  `callerLattitude` DECIMAL(8,6) NULL DEFAULT NULL,
  `callerLongtitude` DECIMAL(8,6) NULL DEFAULT NULL,
  PRIMARY KEY (`User_userID`, `RSA_phoneNumber`, `timestamp`),
  INDEX `fk_User_has_RSA_RSA1_idx` (`RSA_phoneNumber` ASC) VISIBLE,
  INDEX `fk_User_has_RSA_User1_idx` (`User_userID` ASC) VISIBLE,
  CONSTRAINT `fk_User_has_RSA_RSA1`
    FOREIGN KEY (`RSA_phoneNumber`)
    REFERENCES `evpointdb`.`rsa` (`phoneNumber`),
  CONSTRAINT `fk_User_has_RSA_User1`
    FOREIGN KEY (`User_userID`)
    REFERENCES `evpointdb`.`user` (`userID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`user_drives_car`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`user_drives_car` (
  `car_licenseNumber` CHAR(7) NOT NULL,
  `user_userID` CHAR(6) NOT NULL,
  PRIMARY KEY (`car_licenseNumber`, `user_userID`),
  INDEX `fk_car_has_user_user1_idx` (`user_userID` ASC) VISIBLE,
  CONSTRAINT `fk_car_has_user_car1`
    FOREIGN KEY (`car_licenseNumber`)
    REFERENCES `evpointdb`.`car` (`licenseNumber`),
  CONSTRAINT `fk_car_has_user_user1`
    FOREIGN KEY (`user_userID`)
    REFERENCES `evpointdb`.`user` (`userID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`user_owns_car`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`user_owns_car` (
  `User_userID` CHAR(6) NOT NULL,
  `Car_licenseNumber` CHAR(7) NOT NULL,
  PRIMARY KEY (`User_userID`, `Car_licenseNumber`),
  INDEX `fk_User_has_Car_Car1_idx` (`Car_licenseNumber` ASC) VISIBLE,
  INDEX `fk_User_has_Car_User_idx` (`User_userID` ASC) VISIBLE,
  CONSTRAINT `fk_User_has_Car_Car1`
    FOREIGN KEY (`Car_licenseNumber`)
    REFERENCES `evpointdb`.`car` (`licenseNumber`),
  CONSTRAINT `fk_User_has_Car_User`
    FOREIGN KEY (`User_userID`)
    REFERENCES `evpointdb`.`user` (`userID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`user_reviews_chargingstation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`user_reviews_chargingstation` (
  `User_userID` CHAR(6) NOT NULL,
  `chargingStation_companyName` VARCHAR(25) NOT NULL,
  `chargingStation_latitude` DECIMAL(8,6) NOT NULL,
  `chargingStation_longtitude` DECIMAL(8,6) NOT NULL,
  `stars` INT NULL DEFAULT NULL,
  `comment` VARCHAR(512) NULL DEFAULT NULL,
  `date` DATE NOT NULL,
  PRIMARY KEY (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `date`),
  INDEX `fk_User_has_chargingStation_chargingStation1_idx` (`chargingStation_companyName` ASC, `chargingStation_latitude` ASC, `chargingStation_longtitude` ASC) VISIBLE,
  INDEX `fk_User_has_chargingStation_User1_idx` (`User_userID` ASC) VISIBLE,
  CONSTRAINT `fk_User_has_chargingStation_chargingStation1`
    FOREIGN KEY (`chargingStation_companyName` , `chargingStation_latitude` , `chargingStation_longtitude`)
    REFERENCES `evpointdb`.`chargingstation` (`companyName` , `latitude` , `longtitude`),
  CONSTRAINT `fk_User_has_chargingStation_User1`
    FOREIGN KEY (`User_userID`)
    REFERENCES `evpointdb`.`user` (`userID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `evpointdb` ;

-- -----------------------------------------------------
-- Placeholder table for view `evpointdb`.`nearRSA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`nearRSA` (`id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `evpointdb`.`nearAvailConnectors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`nearAvailConnectors` (`connectorID` INT, `connectorType` INT, `availability` INT, `chargingStation_companyName` INT, `chargingStation_latitude` INT, `chargingStation_longtitude` INT);

-- -----------------------------------------------------
-- Placeholder table for view `evpointdb`.`chargingStationMeanStars`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`chargingStationMeanStars` (`companyName` INT, `latitude` INT, `longtitude` INT);

-- -----------------------------------------------------
-- View `evpointdb`.`nearRSA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evpointdb`.`nearRSA`;
USE `evpointdb`;
CREATE  OR REPLACE VIEW `nearRSA` AS 
select userID, rsa.phoneNumber as rsaNumber
from user join rsa
where ( user.latitude > rsa.latitude - 0.1 )
and ( user.latitude < rsa.latitude + 0.1 )
and ( user.longtitude > rsa.longtitude - 0.1 )
and ( user.longtitude < rsa.longtitude + 0.1 );

-- -----------------------------------------------------
-- View `evpointdb`.`nearAvailConnectors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evpointdb`.`nearAvailConnectors`;
USE `evpointdb`;
-- "Near" means within 0.05 degrees (about 5 km) of the user.
CREATE  OR REPLACE VIEW `nearAvailConnectors` AS
select userID, connectorID, chargingStation_companyName, chargingStation_latitude, chargingStation_longtitude, connectorType
from user join connector
where ( user.latitude > chargingStation_latitude - 0.05 )
and ( user.latitude < chargingStation_latitude + 0.05 )
and ( user.longtitude > chargingStation_longtitude - 0.05 )
and ( user.longtitude < chargingStation_longtitude + 0.05 )
and availability = 1;

-- -----------------------------------------------------
-- View `evpointdb`.`chargingStationMeanStars`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `evpointdb`.`chargingStationMeanStars`;
USE `evpointdb`;
CREATE  OR REPLACE VIEW `chargingStationMeanStars` AS
select chargingStation_companyName, chargingStation_latitude, chargingStation_longtitude, avg(stars) as meanStars
from evpointdb.user_reviews_chargingstation join evpointdb.chargingstation 
on chargingStation_companyName = companyName and chargingStation_latitude = latitude and chargingStation_longtitude = longtitude
group by chargingStation_companyName, chargingStation_latitude, chargingStation_longtitude
order by meanStars desc;
-- BEGIN SAMPLE DATA (generated by tools/build_sample_data.py)
--
-- Charging stations and connectors: snapshot of Open Charge Map data
-- (https://openchargemap.org), taken 2026-09-30, CC BY 4.0. Each station keeps the licence of its
-- original data provider. Users, cars, health readings, roadside assistance, reviews and
-- occupancy below are FICTIONAL sample data.
--
-- connector.availability: 1 = available, -1 = occupied, 0 = out of service
-- occupiedconnector.occupiedUntil is NULL while a session is still running.

INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('MKP4642', 'Nissan Leaf', NULL, 'Daily commute');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('PHP9223', 'Tesla Model 3', NULL, 'Company car');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('TTP7858', 'Renault Zoe', NULL, 'Family car');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('XAA5535', 'Hyundai Kona Electric', NULL, 'Weekend trips');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('MXY8041', 'VW ID.3', NULL, 'Car sharing');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('AXA9148', 'Kia EV6', NULL, 'Second car');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('XBE9731', 'Peugeot e-208', NULL, NULL);
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('IBK6279', 'Fiat 500e', NULL, 'Daily commute');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('YXB7605', 'MG4', NULL, 'Company car');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('AZA9285', 'BMW i3', NULL, 'Family car');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('HMX9387', 'Skoda Enyaq', NULL, 'Weekend trips');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('YNB4319', 'Opel Corsa-e', NULL, 'Car sharing');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('TYO9718', 'Dacia Spring', NULL, 'Second car');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('TEH6725', 'Mini Cooper SE', NULL, NULL);

INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.974582', '23.746079');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.985259', '23.731049');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.991863', '23.732266');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.947745', '23.713091');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.983310', '23.766292');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.938807', '23.638973');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Site owner', '37.989493', '23.746706');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Site owner', '38.074666', '23.821280');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Site owner', '38.059823', '23.808575');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Unknown operator', '37.991309', '23.771042');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Site owner', '37.978633', '23.672724');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.984147', '23.760348');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Blink Charging', '37.943495', '23.700667');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Blink Charging', '38.040394', '23.803774');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Blink Charging', '37.990939', '23.723983');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Unknown operator', '37.972960', '23.751378');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Unknown operator', '37.967733', '23.725634');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '38.048086', '23.804939');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.932169', '23.685910');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Blink Charging', '37.974218', '23.734367');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Site owner', '37.950207', '23.707629');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Blink Charging', '37.977550', '23.649730');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Tesla', '38.035028', '23.790994');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('FORTISIS', '37.931527', '23.646914');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Unknown operator', '38.035543', '23.748438');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Unknown operator', '38.033788', '23.770233');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Motionbox', '37.979976', '23.745449');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Unknown operator', '37.945602', '23.701871');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Unknown operator', '38.022049', '23.834366');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`) VALUES ('Unknown operator', '37.938357', '23.669211');

INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100001', 'CCS2', '1', 'FORTISIS', '37.974582', '23.746079');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100002', 'CCS2', '1', 'FORTISIS', '37.974582', '23.746079');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100003', 'TYPE 2', '1', 'FORTISIS', '37.974582', '23.746079');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100004', 'TYPE 2', '1', 'FORTISIS', '37.974582', '23.746079');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100005', 'CCS2', '-1', 'FORTISIS', '37.985259', '23.731049');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100006', 'CCS2', '1', 'FORTISIS', '37.985259', '23.731049');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100007', 'TYPE 2', '1', 'FORTISIS', '37.985259', '23.731049');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100008', 'TYPE 2', '1', 'FORTISIS', '37.985259', '23.731049');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100009', 'TYPE 2', '1', 'FORTISIS', '37.991863', '23.732266');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100010', 'TYPE 2', '-1', 'FORTISIS', '37.991863', '23.732266');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100011', 'TYPE 2', '1', 'FORTISIS', '37.947745', '23.713091');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100012', 'TYPE 2', '1', 'FORTISIS', '37.947745', '23.713091');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100013', 'TYPE 2', '1', 'FORTISIS', '37.983310', '23.766292');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100014', 'TYPE 2', '1', 'FORTISIS', '37.983310', '23.766292');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100015', 'TYPE 2', '-1', 'FORTISIS', '37.938807', '23.638973');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100016', 'TYPE 2', '1', 'FORTISIS', '37.938807', '23.638973');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100017', 'TYPE 2', '1', 'Site owner', '37.989493', '23.746706');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100018', 'TYPE 2', '1', 'Site owner', '38.074666', '23.821280');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100019', 'TYPE 2', '1', 'Site owner', '38.059823', '23.808575');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100020', 'TYPE 2', '-1', 'Unknown operator', '37.991309', '23.771042');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100021', 'TYPE 2', '1', 'Unknown operator', '37.991309', '23.771042');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100022', 'TYPE 2', '1', 'Site owner', '37.978633', '23.672724');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100023', 'TYPE 2', '1', 'FORTISIS', '37.984147', '23.760348');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100024', 'TYPE 2', '1', 'FORTISIS', '37.984147', '23.760348');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100025', 'TYPE 2', '-1', 'Blink Charging', '37.943495', '23.700667');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100026', 'TYPE 2', '1', 'Blink Charging', '37.943495', '23.700667');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100027', 'TYPE 2', '1', 'Blink Charging', '38.040394', '23.803774');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100028', 'TYPE 2', '1', 'Blink Charging', '38.040394', '23.803774');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100029', 'TYPE 2', '1', 'Blink Charging', '37.990939', '23.723983');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100030', 'TYPE 2', '-1', 'Blink Charging', '37.990939', '23.723983');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100031', 'TYPE 2', '1', 'Unknown operator', '37.972960', '23.751378');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100032', 'TYPE 2', '1', 'Unknown operator', '37.967733', '23.725634');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100033', 'TYPE 2', '1', 'FORTISIS', '38.048086', '23.804939');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100034', 'TYPE 2', '1', 'FORTISIS', '38.048086', '23.804939');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100035', 'TYPE 2', '-1', 'FORTISIS', '37.932169', '23.685910');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100036', 'TYPE 2', '1', 'FORTISIS', '37.932169', '23.685910');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100037', 'TYPE 2', '1', 'Blink Charging', '37.974218', '23.734367');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100038', 'TYPE 2', '1', 'Blink Charging', '37.974218', '23.734367');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100039', 'TYPE 2', '1', 'Site owner', '37.950207', '23.707629');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100040', 'TYPE 2', '-1', 'Blink Charging', '37.977550', '23.649730');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100041', 'TYPE 2', '1', 'Blink Charging', '37.977550', '23.649730');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100042', 'CCS2', '1', 'Tesla', '38.035028', '23.790994');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100043', 'CCS2', '1', 'Tesla', '38.035028', '23.790994');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100044', 'TYPE 2', '1', 'FORTISIS', '37.931527', '23.646914');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100045', 'TYPE 2', '-1', 'FORTISIS', '37.931527', '23.646914');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100046', 'TYPE 2', '1', 'Unknown operator', '38.035543', '23.748438');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100047', 'TYPE 2', '1', 'Unknown operator', '38.035543', '23.748438');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100048', 'TYPE 2', '1', 'Unknown operator', '38.033788', '23.770233');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100049', 'TYPE 2', '1', 'Motionbox', '37.979976', '23.745449');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100050', 'CCS2', '-1', 'Unknown operator', '37.945602', '23.701871');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100051', 'CCS2', '1', 'Unknown operator', '38.022049', '23.834366');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100052', 'CCS2', '1', 'Unknown operator', '38.022049', '23.834366');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100053', 'TYPE 2', '1', 'Unknown operator', '38.022049', '23.834366');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100054', 'TYPE 2', '1', 'Unknown operator', '38.022049', '23.834366');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100055', 'TYPE 2', '-1', 'Unknown operator', '37.938357', '23.669211');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('100056', 'TYPE 2', '1', 'Unknown operator', '37.938357', '23.669211');

INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-27 19:18:00', '97.634', '94.249', '30.963', '90.195', '15.651', 'AXA9148');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-28 10:32:00', '91.006', '83.875', '34.239', '60.946', '46.049', 'AXA9148');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-22 21:08:00', '80.252', '80.418', '34.864', '89.461', '58.035', 'AZA9285');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-24 13:12:00', '80.112', '84.952', '35.497', '94.969', '61.557', 'AZA9285');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-26 21:22:00', '90.796', '72.482', '37.665', '64.018', '44.858', 'AZA9285');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-20 17:57:00', '75.198', '64.689', '32.858', '93.461', '66.101', 'HMX9387');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-27 09:56:00', '73.221', '96.672', '34.439', '97.298', '45.487', 'HMX9387');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-20 21:50:00', '80.504', '88.034', '37.385', '82.179', '52.999', 'IBK6279');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-24 21:35:00', '89.255', '96.061', '35.600', '89.210', '33.085', 'IBK6279');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-28 06:23:00', '92.299', '96.786', '33.815', '83.705', '87.733', 'IBK6279');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-26 11:22:00', '79.556', '60.512', '30.359', '68.380', '92.483', 'MKP4642');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-30 04:50:00', '95.283', '89.807', '33.300', '96.436', '13.762', 'MKP4642');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-22 07:00:00', '93.706', '81.806', '34.242', '66.677', '77.243', 'MXY8041');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-23 20:08:00', '91.010', '72.937', '33.281', '76.783', '64.162', 'MXY8041');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-20 15:57:00', '93.429', '84.412', '35.662', '74.400', '73.959', 'PHP9223');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-24 01:36:00', '86.727', '65.189', '32.373', '85.991', '70.062', 'PHP9223');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-23 22:41:00', '86.288', '81.173', '35.675', '88.480', '24.784', 'TEH6725');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-27 03:27:00', '78.279', '71.888', '30.057', '66.637', '60.847', 'TEH6725');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-24 10:56:00', '94.964', '95.769', '34.154', '85.506', '75.868', 'TTP7858');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-26 11:04:00', '93.419', '83.246', '31.364', '81.326', '54.804', 'TTP7858');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-20 14:06:00', '94.042', '62.348', '34.890', '70.268', '75.427', 'TYO9718');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-20 17:19:00', '88.253', '80.801', '32.934', '92.541', '74.759', 'TYO9718');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-23 22:19:00', '95.125', '74.173', '37.474', '92.500', '43.407', 'XAA5535');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-28 22:03:00', '70.964', '97.492', '32.677', '63.454', '75.083', 'XAA5535');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-23 02:08:00', '80.158', '75.466', '36.941', '96.187', '27.118', 'XBE9731');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-28 19:34:00', '82.011', '94.043', '33.443', '79.743', '78.359', 'XBE9731');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-21 19:02:00', '70.474', '66.655', '36.916', '69.324', '52.311', 'YNB4319');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-23 02:54:00', '95.633', '84.224', '36.422', '77.312', '89.501', 'YNB4319');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-25 19:35:00', '76.396', '69.992', '36.349', '79.961', '81.115', 'YNB4319');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-24 10:41:00', '75.233', '96.294', '37.143', '69.949', '52.000', 'YXB7605');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2026-09-28 17:12:00', '84.605', '73.040', '32.545', '73.341', '41.982', 'YXB7605');

INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100005', 'MXY8041', '2026-09-30 12:37:00', NULL, '2026-09-30 14:19:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100010', 'TYO9718', '2026-09-30 13:40:00', NULL, '2026-09-30 14:31:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100015', 'TEH6725', '2026-09-30 13:45:00', NULL, '2026-09-30 15:19:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100020', 'XBE9731', '2026-09-30 12:52:00', NULL, '2026-09-30 14:16:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100025', 'AXA9148', '2026-09-30 13:33:00', NULL, '2026-09-30 15:10:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100030', 'MKP4642', '2026-09-30 13:49:00', NULL, '2026-09-30 14:16:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100035', 'TTP7858', '2026-09-30 13:38:00', NULL, '2026-09-30 14:41:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100040', 'YNB4319', '2026-09-30 13:33:00', NULL, '2026-09-30 15:13:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100045', 'YXB7605', '2026-09-30 12:30:00', NULL, '2026-09-30 15:14:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100050', 'AZA9285', '2026-09-30 13:08:00', NULL, '2026-09-30 15:20:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100055', 'PHP9223', '2026-09-30 13:41:00', NULL, '2026-09-30 14:14:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100039', 'YNB4319', '2026-09-29 19:01:00', '2026-09-29 21:01:00', '2026-09-29 21:05:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100043', 'TTP7858', '2026-09-21 14:16:00', '2026-09-21 15:51:00', '2026-09-21 15:48:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100051', 'PHP9223', '2026-09-26 08:48:00', '2026-09-26 09:58:00', '2026-09-26 09:58:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100032', 'AXA9148', '2026-09-20 13:17:00', '2026-09-20 15:31:00', '2026-09-20 15:24:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100053', 'YNB4319', '2026-09-28 17:53:00', '2026-09-28 20:03:00', '2026-09-28 19:55:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100054', 'IBK6279', '2026-09-29 09:16:00', '2026-09-29 09:58:00', '2026-09-29 10:08:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100048', 'TYO9718', '2026-09-27 19:32:00', '2026-09-27 21:10:00', '2026-09-27 21:18:00');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('100006', 'AZA9285', '2026-09-23 16:05:00', '2026-09-23 17:27:00', '2026-09-23 17:31:00');

INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('210555101', 'Attica Roadside Help', '23.727500', '37.983800');
INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('210555102', 'Piraeus Tow and Assist', '23.647000', '37.942000');
INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('210555103', 'Northern Suburbs Assist', '23.808000', '38.056000');
INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('210555104', 'Saronic Coast Assist', '23.753000', '37.865000');
INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('231055105', 'Thessaloniki Road Aid', '22.940000', '40.630000');
INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('261055106', 'Patras Road Rescue', '21.735000', '38.245000');

INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('015265', '691234568', '23.742732', '37.985386');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('012546', '692345679', '23.742054', '37.982941');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('056352', '693456780', '23.653355', '37.955965');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('169872', '696546875', '23.827625', '38.056274');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('161099', '695646872', '23.663330', '37.981555');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('368057', '693685438', '23.701846', '37.951544');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('368145', '695378876', '23.739022', '37.988002');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('204118', '694120311', '23.798572', '38.054146');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('219377', '697338204', '23.693090', '37.937667');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('233904', '698450917', '23.809930', '38.049166');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('251560', '691577320', '23.768680', '38.031215');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('287731', '692684433', '23.701011', '37.936551');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('301846', '693791546', '22.951925', '40.631021');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('342209', '694806659', '21.729823', '38.253427');

INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('015265', '210555101', '2026-09-15 18:11:00', '37.983727', '23.741254');
INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('012546', '210555101', '2026-09-11 05:57:00', '37.981841', '23.742328');
INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('056352', '210555101', '2026-09-15 20:59:00', '37.957348', '23.650996');
INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('169872', '210555103', '2026-09-10 20:19:00', '38.058217', '23.827151');
INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('161099', '210555101', '2026-09-26 11:41:00', '37.982620', '23.662376');
INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('368057', '210555101', '2026-09-20 08:54:00', '37.954364', '23.703028');

INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('MKP4642', '015265');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('PHP9223', '012546');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('TTP7858', '056352');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('XAA5535', '169872');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('MXY8041', '161099');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('AXA9148', '368057');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('XBE9731', '368145');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('IBK6279', '204118');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('YXB7605', '219377');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('AZA9285', '233904');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('HMX9387', '251560');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('YNB4319', '287731');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('TYO9718', '301846');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('TEH6725', '342209');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('XAA5535', '161099');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('IBK6279', '219377');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('AZA9285', '056352');

INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('015265', 'MKP4642');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('012546', 'PHP9223');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('056352', 'TTP7858');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('169872', 'XAA5535');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('161099', 'MXY8041');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('368057', 'AXA9148');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('368145', 'XBE9731');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('204118', 'IBK6279');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('219377', 'YXB7605');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('233904', 'AZA9285');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('251560', 'HMX9387');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('287731', 'YNB4319');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('301846', 'TYO9718');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('342209', 'TEH6725');

INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('015265', 'FORTISIS', '37.984147', '23.760348', '3', 'Average station', '2026-08-13');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('015265', 'Blink Charging', '37.977550', '23.649730', '4', 'Rarely a queue', '2026-07-19');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('012546', 'FORTISIS', '38.048086', '23.804939', '2', 'Hard to find the entrance', '2026-09-11');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('012546', 'Blink Charging', '37.990939', '23.723983', '2', 'Slower than I hoped', '2026-07-21');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('012546', 'Site owner', '37.989493', '23.746706', '4', 'Easy to find, good speed', '2026-09-03');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('012546', 'Blink Charging', '38.040394', '23.803774', '4', 'Easy to find, good speed', '2026-08-31');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('056352', 'Unknown operator', '37.967733', '23.725634', '4', 'Easy to find, good speed', '2026-09-18');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('056352', 'Site owner', '37.950207', '23.707629', '4', 'Rarely a queue', '2026-07-27');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('056352', 'Blink Charging', '37.977550', '23.649730', '4', 'Fast and reliable', '2026-09-28');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('169872', 'Tesla', '38.035028', '23.790994', '5', 'Excellent, always available', '2026-09-04');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('169872', 'Unknown operator', '38.035543', '23.748438', '3', 'Okay for a quick top-up', '2026-09-04');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('169872', 'Unknown operator', '37.967733', '23.725634', '2', 'Slower than I hoped', '2026-06-28');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('161099', 'Blink Charging', '37.990939', '23.723983', '4', 'Rarely a queue', '2026-06-17');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('161099', 'Tesla', '38.035028', '23.790994', '2', 'Hard to find the entrance', '2026-09-09');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('368057', 'Site owner', '37.978633', '23.672724', '5', 'Best station in the area', '2026-08-14');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('368057', 'Site owner', '37.989493', '23.746706', '5', 'Fast charging and easy payment', '2026-08-16');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('368057', 'Blink Charging', '38.040394', '23.803774', '3', 'Works fine', '2026-08-19');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('368057', 'Site owner', '37.950207', '23.707629', '4', 'Fast and reliable', '2026-07-04');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('368145', 'Blink Charging', '38.040394', '23.803774', '5', 'Best station in the area', '2026-08-31');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('368145', 'FORTISIS', '37.991863', '23.732266', '2', 'Slower than I hoped', '2026-08-22');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('368145', 'FORTISIS', '37.985259', '23.731049', '1', 'Did not suit my needs', '2026-07-16');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('368145', 'Blink Charging', '37.977550', '23.649730', '3', 'Average station', '2026-08-14');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('204118', 'Unknown operator', '38.033788', '23.770233', '3', 'Average station', '2026-08-21');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('204118', 'FORTISIS', '37.983310', '23.766292', '2', 'Often busy in the evening', '2026-09-18');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('204118', 'Unknown operator', '37.972960', '23.751378', '2', 'Often busy in the evening', '2026-06-27');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('204118', 'Tesla', '38.035028', '23.790994', '4', 'Easy to find, good speed', '2026-07-19');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('219377', 'FORTISIS', '37.932169', '23.685910', '3', 'Works fine', '2026-07-10');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('219377', 'Blink Charging', '38.040394', '23.803774', '5', 'Excellent, always available', '2026-09-28');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('233904', 'Blink Charging', '37.990939', '23.723983', '3', 'Okay for a quick top-up', '2026-07-01');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('233904', 'Site owner', '37.978633', '23.672724', '2', 'Often busy in the evening', '2026-09-23');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('251560', 'Blink Charging', '37.943495', '23.700667', '4', 'Rarely a queue', '2026-08-28');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('251560', 'Unknown operator', '37.991309', '23.771042', '2', 'Hard to find the entrance', '2026-07-18');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('287731', 'Unknown operator', '37.967733', '23.725634', '4', 'Rarely a queue', '2026-06-21');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('287731', 'Site owner', '37.989493', '23.746706', '4', 'Easy to find, good speed', '2026-07-08');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('287731', 'FORTISIS', '37.984147', '23.760348', '4', 'Fast and reliable', '2026-07-07');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('287731', 'Unknown operator', '38.035543', '23.748438', '5', 'Fast charging and easy payment', '2026-07-09');

-- END SAMPLE DATA

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
