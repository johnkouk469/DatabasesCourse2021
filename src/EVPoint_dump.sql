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
  `latitude` DECIMAL(2,2) NOT NULL,
  `longtitude` DECIMAL(2,2) NOT NULL,
  `meanStars` DECIMAL(1,1) NULL DEFAULT NULL,
  PRIMARY KEY (`companyName`, `latitude`, `longtitude`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`connector`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`connector` (
  `connectorID` INT NOT NULL,
  `connectorType` ENUM('TESLA-TYPE2,TYPE2,CCS') NULL DEFAULT NULL,
  `availability` INT NULL DEFAULT NULL,
  `chargingStation_companyName` VARCHAR(25) NOT NULL,
  `chargingStation_latitude` DECIMAL(2,2) NOT NULL,
  `chargingStation_longtitude` DECIMAL(2,2) NOT NULL,
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
  `healthTimeStamp` TIMESTAMP(6) NOT NULL,
  `engineHealth` DECIMAL(3,3) NULL DEFAULT NULL,
  `batteryHealth` DECIMAL(3,3) NULL DEFAULT NULL,
  `tirePressure` DECIMAL(3,3) NULL DEFAULT NULL,
  `tireCondition` DECIMAL(3,3) NULL DEFAULT NULL,
  `batteryPercentage` DECIMAL(3,3) NULL DEFAULT NULL,
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
  `occupiedFrom` TIMESTAMP(6) NULL DEFAULT NULL,
  `occupiedUntil` TIMESTAMP(6) NULL DEFAULT NULL,
  `occupiedEstimatedUntil` TIMESTAMP(6) NULL DEFAULT NULL,
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
  `longtitude` DECIMAL(2,2) NULL DEFAULT NULL,
  `latitude` DECIMAL(2,2) NULL DEFAULT NULL,
  PRIMARY KEY (`phoneNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`user` (
  `userID` CHAR(6) NOT NULL,
  `phoneNumber` INT UNSIGNED NULL DEFAULT NULL,
  `longtitude` DECIMAL(2,2) NULL DEFAULT NULL,
  `latitude` DECIMAL(2,2) NULL DEFAULT NULL,
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
  `timestamp` TIMESTAMP(6) NULL DEFAULT NULL,
  `callerLattitude` DECIMAL(2,2) NULL DEFAULT NULL,
  `callerLongtitude` DECIMAL(2,2) NULL DEFAULT NULL,
  PRIMARY KEY (`User_userID`, `RSA_phoneNumber`),
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
  `chargingStation_latitude` DECIMAL(2,2) NOT NULL,
  `chargingStation_longtitude` DECIMAL(2,2) NOT NULL,
  `stars` INT NULL DEFAULT NULL,
  `comment` VARCHAR(512) NULL DEFAULT NULL,
  `date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`),
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
    REFERENCES `evpointdb`.`car` (`licenseNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_car_has_user_user1`
    FOREIGN KEY (`user_userID`)
    REFERENCES `evpointdb`.`user` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
