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
  `meanStars` DECIMAL(3,2) NULL DEFAULT NULL,
  PRIMARY KEY (`companyName`, `latitude`, `longtitude`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `evpointdb`.`connector`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evpointdb`.`connector` (
  `connectorID` INT NOT NULL,
  `connectorType` ENUM('Tesla TYPE 2','TYPE 2','CCS2') NULL DEFAULT NULL,
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
  `timestamp` TIMESTAMP(6) NULL DEFAULT NULL,
  `callerLattitude` DECIMAL(8,6) NULL DEFAULT NULL,
  `callerLongtitude` DECIMAL(8,6) NULL DEFAULT NULL,
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
  `chargingStation_latitude` DECIMAL(8,6) NOT NULL,
  `chargingStation_longtitude` DECIMAL(8,6) NOT NULL,
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
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('XEE1547', 'Tesla Plaid', load_file('C:\Users\harry\Downloads\200923113237_Tesla-Model-S-plaid-1.jpg'), '“Hype 400+km/h”');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('ZYZ4647', 'Pyraulos', load_file('C:\Users\harry\Downloads\bloodhound_rtq_2.jpg'), '“Το αυτοκινητάκι μου”');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('IKA7801', 'Ducati', load_file('C:\Users\harry\Downloads\1946_Ducati_DU4_01.jpg'), '“Τα εσκασα”');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('AZI9803', 'Kouvas', load_file('C:\Users\harry\Downloads\300px-Citroen-pony.jpg'), '“for sale”');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('ΗΜΖ9889', 'Trakteri', load_file('C:\Users\harry\Downloads\34203761_0_n.jpg'), '“fvghukfui”');
INSERT INTO `evpointdb`.`car` (`licenseNumber`, `name`, `photo`, `notes`) VALUES ('ΝΚΗ2478', 'ThsMarias', load_file('C:\Users\harry\Downloads\maria.jpg'), '“Το θέλει στις 6μ.μ. στο γραφείο μόλις τελειώσει την δουλειά”');


INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`, `meanStars`) VALUES ('Tesla', '40.640534', '50.643326', '4.25');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`, `meanStars`) VALUES ('Ev box', '80.367344', '34.235643', '3.76');
INSERT INTO `evpointdb`.`chargingstation` (`companyName`, `latitude`, `longtitude`, `meanStars`) VALUES ('Virta', '35.464354', '63.655754', '4.63');

INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('045675', 'Tesla TYPE 2', '-1', 'Tesla', '50.623544', '40.646534');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('013554', 'TYPE 2', '1', 'Ev box', '34.243453', '80.354766');
INSERT INTO `evpointdb`.`connector` (`connectorID`, `connectorType`, `availability`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`) VALUES ('357752', 'CCS2', '1', 'Virta', '63.622335', '35.465786');

INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2021-11-25 12:30:00', '080.435', '090.342', '034.456', '087.034', '078.034', 'XEE1547');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2021-11-17 15:00:01', '089.367', '085.923', '055.456', '090.325', '021.546', 'AZI9803');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2021-11-18 22:00:00', '090.745', '056.246', '032.211', '070.432', '034.615', 'ΝΚΗ2478');
INSERT INTO `evpointdb`.`health` (`healthTimeStamp`, `engineHealth`, `batteryHealth`, `tirePressure`, `tireCondition`, `batteryPercentage`, `Car_licenseNumber`) VALUES ('2021-11-19 16:30:00', '060.624', '045.235', '035.092', '060.654', '089.561', 'IKA7801');

INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('045675', 'XEE1547', '2021-12-22 10:32:32', '2021-12-22 11:35:35', '2021-12-22 11:30:23');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('133554', 'ZYZ4647', '2021-12-23 15:24:53', '2021-12-23 16:50:23', '2021-12-23 16:48:45');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('357752', 'AZI9803', '2021-12-24 12:53:23', '2021-12-24 15:23:45', '2021-12-24 15:25:23');
INSERT INTO `evpointdb`.`occupiedconnector` (`OccupiedConnectorID`, `connectedCarLN`, `occupiedFrom`, `occupiedUntil`, `occupiedEstimatedUntil`) VALUES ('514234', 'ΝΚΗ2478', '2021-12-25 18:23:25', '2021-12-25 20:30:55', '2021-12-25 20:29:44');

INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('231024509', 'RED ASSISTANCE', '37.955127', '23.649335');
INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('231024543', 'KAMZELIS', '40.685302', '22.938323');
INSERT INTO `evpointdb`.`rsa` (`phoneNumber`, `name`, `longtitude`, `latitude`) VALUES ('231024556', 'KYRALEKOS', '40.763412', '23.526123');

INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('015265', '691234568', '37.451234', '23.429335');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('012546', '692345679', '36.564215', '21.456455');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('056352', '693456780', '40.124556', '23.000624');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('169872', '696546875', '40.624651', '22.954123');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('161099', '695646872', '38.235498', '22.845214');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('368057', '693685438', '38.665213', '21.745698');
INSERT INTO `evpointdb`.`user` (`userID`, `phoneNumber`, `longtitude`, `latitude`) VALUES ('368145', '695378876', '39.455682', '21.422103');

INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('015265', '231024509', '2021-11-21 11:35:35', '23.425325', '37.451234');
INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('169872', '231024509', '2021-11-12 09:35:12', '22.954252', '40.621245');
INSERT INTO `evpointdb`.`user_calls_rsa` (`User_userID`, `RSA_phoneNumber`, `timestamp`, `callerLattitude`, `callerLongtitude`) VALUES ('368057', '231024509', '2021-11-24 23:13:34', '23.214553', '40.124125');

INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('XEE1547', '015265');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('ZYZ4647', '056352');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('XEE1547', '368057');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('AZI9803', '169872');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('IKA7801', '012546');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('ΝΚΗ2478', '368145');
INSERT INTO `evpointdb`.`user_drives_car` (`car_licenseNumber`, `user_userID`) VALUES ('ΗΜΖ9889', '161099');


INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('015265', 'XEE1547');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('161099', 'ΗΜΖ9889');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('169872', 'AZI9803');
INSERT INTO `evpointdb`.`user_owns_car` (`User_userID`, `Car_licenseNumber`) VALUES ('056352', 'ZYZ4647');

UPDATE `evpointdb`.`chargingstation` SET `companyName` = 'Virta' WHERE (`companyName` = 'Virta') and (`latitude` = '63.655754') and (`longtitude` = '35.464354');
UPDATE `evpointdb`.`chargingstation` SET `companyName` = 'Tesla' WHERE (`companyName` = 'Ev box') and (`latitude` = '50.643326') and (`longtitude` = '40.640534');
UPDATE `evpointdb`.`chargingstation` SET `companyName` = 'Ev box' WHERE (`companyName` = 'Tesla') and (`latitude` = '34.235643') and (`longtitude` = '80.367344');


INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('056352', 'Tesla', '50.643326', '40.640534', '2', 'slow', '2021-12-22');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('169872', 'Ev box', '34.235643', '80.367344', '1', '-', '2021-12-22');
INSERT INTO `evpointdb`.`user_reviews_chargingstation` (`User_userID`, `chargingStation_companyName`, `chargingStation_latitude`, `chargingStation_longtitude`, `stars`, `comment`, `date`) VALUES ('161099', 'Virta', '63.655754', '35.464354', '3', 'good', '2021-12-22');


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;




