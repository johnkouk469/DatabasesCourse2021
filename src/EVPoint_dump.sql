-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema EVPointDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `EVPointDB` ;

-- -----------------------------------------------------
-- Schema EVPointDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `EVPointDB` DEFAULT CHARACTER SET utf8 ;
USE `EVPointDB` ;

-- -----------------------------------------------------
-- Table `EVPointDB`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`User` (
  `userID` CHAR(6) NOT NULL,
  `phoneNumber` INT(10) UNSIGNED NULL,
  `longtitude` DECIMAL(2,2) NULL,
  `latitude` DECIMAL(2,2) NULL,
  PRIMARY KEY (`userID`),
  UNIQUE INDEX `phoneNumber_UNIQUE` (`phoneNumber` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`Car`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`Car` (
  `licenseNumber` CHAR(7) NOT NULL,
  `name` VARCHAR(25) NULL,
  `photo` BLOB NULL,
  `notes` VARCHAR(512) NULL,
  PRIMARY KEY (`licenseNumber`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`Health`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`Health` (
  `healthTimeStamp` TIMESTAMP(6) NOT NULL,
  `engineHealth` DECIMAL(3,3) NULL,
  `batteryHealth` DECIMAL(3,3) NULL,
  `tirePressure` DECIMAL(3,3) NULL,
  `tireCondition` DECIMAL(3,3) NULL,
  `batteryPercentage` DECIMAL(3,3) NULL,
  `Healthcol` VARCHAR(45) NULL,
  `Car_licenseNumber` CHAR(7) NOT NULL,
  PRIMARY KEY (`healthTimeStamp`, `Car_licenseNumber`),
  INDEX `fk_Health_Car1_idx` (`Car_licenseNumber` ASC) VISIBLE,
  CONSTRAINT `fk_Health_Car1`
    FOREIGN KEY (`Car_licenseNumber`)
    REFERENCES `EVPointDB`.`Car` (`licenseNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`chargingStation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`chargingStation` (
  `companyName` VARCHAR(25) NOT NULL,
  `latitude` DECIMAL(2,2) NOT NULL,
  `longtitude` DECIMAL(2,2) NOT NULL,
  `meanStars` DECIMAL(1,1) NULL,
  PRIMARY KEY (`companyName`, `latitude`, `longtitude`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`Connector`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`Connector` (
  `connectorID` INT(6) NOT NULL,
  `connectorType` ENUM('TESLATYPE2.TYPE2.CCS') NULL,
  `availability` INT(1) NULL,
  `Connectorcol` VARCHAR(45) NULL,
  `chargingStation_companyName` VARCHAR(25) NOT NULL,
  `chargingStation_latitude` DECIMAL(2,2) NOT NULL,
  `chargingStation_longtitude` DECIMAL(2,2) NOT NULL,
  PRIMARY KEY (`connectorID`),
  INDEX `fk_Connector_chargingStation1_idx` (`chargingStation_companyName` ASC, `chargingStation_latitude` ASC, `chargingStation_longtitude` ASC) VISIBLE,
  CONSTRAINT `fk_Connector_chargingStation1`
    FOREIGN KEY (`chargingStation_companyName` , `chargingStation_latitude` , `chargingStation_longtitude`)
    REFERENCES `EVPointDB`.`chargingStation` (`companyName` , `latitude` , `longtitude`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`RSA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`RSA` (
  `phoneNumber` INT(10) NOT NULL,
  `name` VARCHAR(25) NULL,
  `longtitude` DECIMAL(2,2) NULL,
  `latitude` DECIMAL(2,2) NULL,
  PRIMARY KEY (`phoneNumber`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`User_owns_Car`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`User_owns_Car` (
  `User_userID` CHAR(6) NOT NULL,
  `Car_licenseNumber` CHAR(7) NOT NULL,
  PRIMARY KEY (`User_userID`, `Car_licenseNumber`),
  INDEX `fk_User_has_Car_Car1_idx` (`Car_licenseNumber` ASC) VISIBLE,
  INDEX `fk_User_has_Car_User_idx` (`User_userID` ASC) VISIBLE,
  CONSTRAINT `fk_User_has_Car_User`
    FOREIGN KEY (`User_userID`)
    REFERENCES `EVPointDB`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_has_Car_Car1`
    FOREIGN KEY (`Car_licenseNumber`)
    REFERENCES `EVPointDB`.`Car` (`licenseNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`User_reviews_chargingStation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`User_reviews_chargingStation` (
  `User_userID` CHAR(6) NOT NULL,
  `chargingStation_companyName` VARCHAR(25) NOT NULL,
  `chargingStation_latitude` DECIMAL(2,2) NOT NULL,
  `chargingStation_longtitude` DECIMAL(2,2) NOT NULL,
  `stars` INT(1) NULL,
  `comment` VARCHAR(512) NULL,
  `date` DATE NULL,
  PRIMARY KEY (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`),
  INDEX `fk_User_has_chargingStation_chargingStation1_idx` (`chargingStation_companyName` ASC, `chargingStation_latitude` ASC, `chargingStation_longtitude` ASC) VISIBLE,
  INDEX `fk_User_has_chargingStation_User1_idx` (`User_userID` ASC) VISIBLE,
  CONSTRAINT `fk_User_has_chargingStation_User1`
    FOREIGN KEY (`User_userID`)
    REFERENCES `EVPointDB`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_has_chargingStation_chargingStation1`
    FOREIGN KEY (`chargingStation_companyName` , `chargingStation_latitude` , `chargingStation_longtitude`)
    REFERENCES `EVPointDB`.`chargingStation` (`companyName` , `latitude` , `longtitude`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`OccupiedConnector`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`OccupiedConnector` (
  `OccupiedConnectorID` INT(6) NOT NULL,
  `connectedCarLN` CHAR(7) NOT NULL,
  `occupiedFrom` TIMESTAMP(6) NULL,
  `occupiedUntil` TIMESTAMP(6) NULL,
  `occupiedEstimatedUntil` TIMESTAMP(6) NULL,
  PRIMARY KEY (`OccupiedConnectorID`, `connectedCarLN`),
  INDEX `carLicenseNumber_idx` (`connectedCarLN` ASC) VISIBLE,
  CONSTRAINT `carLicenseNumber`
    FOREIGN KEY (`connectedCarLN`)
    REFERENCES `EVPointDB`.`Car` (`licenseNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `occupiedConnectorID`
    FOREIGN KEY (`OccupiedConnectorID`)
    REFERENCES `EVPointDB`.`Connector` (`connectorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`User_calls_RSA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`User_calls_RSA` (
  `User_userID` CHAR(6) NOT NULL,
  `RSA_phoneNumber` INT(10) NOT NULL,
  `timestamp` TIMESTAMP(6) NULL,
  `callerLattitude` DECIMAL(2,2) NULL,
  `callerLongtitude` DECIMAL(2,2) NULL,
  PRIMARY KEY (`User_userID`, `RSA_phoneNumber`),
  INDEX `fk_User_has_RSA_RSA1_idx` (`RSA_phoneNumber` ASC) VISIBLE,
  INDEX `fk_User_has_RSA_User1_idx` (`User_userID` ASC) VISIBLE,
  CONSTRAINT `fk_User_has_RSA_User1`
    FOREIGN KEY (`User_userID`)
    REFERENCES `EVPointDB`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_has_RSA_RSA1`
    FOREIGN KEY (`RSA_phoneNumber`)
    REFERENCES `EVPointDB`.`RSA` (`phoneNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EVPointDB`.`timestamps`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`timestamps` (
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL);


-- -----------------------------------------------------
-- Table `EVPointDB`.`timestamps_1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`timestamps_1` (
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL);


-- -----------------------------------------------------
-- Table `EVPointDB`.`timestamps_2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EVPointDB`.`timestamps_2` (
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
