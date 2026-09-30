-- Example users and roles for the EVPointDB course project.
-- All account names and passwords here are fictional placeholders and do not
-- protect anything. Replace 'change_me' with your own password before running
-- this on any real server.
-- Accounts are limited to 'localhost' for this local example.
-- Run src/EVPoint_dump.sql first: the grants refer to the evpointdb schema.

-- Makes the script safe to re-run.
DROP USER IF EXISTS 'kostas'@'localhost', 'tesla_consultant'@'localhost',
                    'arbi'@'localhost', 'maria'@'localhost', 'kostakis'@'localhost';
DROP ROLE IF EXISTS 'stuff', 'developer', 'User', 'Associate Company';

CREATE USER 'kostas'@'localhost' IDENTIFIED BY 'change_me';
CREATE USER 'tesla_consultant'@'localhost' IDENTIFIED BY 'change_me';
CREATE USER 'arbi'@'localhost' IDENTIFIED BY 'change_me';
CREATE USER 'maria'@'localhost' IDENTIFIED BY 'change_me';
CREATE USER 'kostakis'@'localhost' IDENTIFIED BY 'change_me';


GRANT ALL PRIVILEGES ON evpointdb.* TO 'kostas'@'localhost';

CREATE ROLE 'stuff' ;
GRANT SELECT,INSERT,UPDATE,DROP ON evpointdb.* TO 'stuff';
GRANT 'stuff' TO 'kostakis'@'localhost';

CREATE ROLE 'developer';

-- Developers can work with every table except `user` (personal data).
-- MySQL cannot REVOKE a table privilege that was granted on the whole schema,
-- so the privileges are granted table by table instead.
GRANT SELECT,INSERT,UPDATE ON evpointdb.car TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.chargingstation TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.connector TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.health TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.occupiedconnector TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.rsa TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.user_calls_rsa TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.user_drives_car TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.user_owns_car TO 'developer';
GRANT SELECT,INSERT,UPDATE ON evpointdb.user_reviews_chargingstation TO 'developer';
GRANT SELECT ON evpointdb.chargingStationMeanStars TO 'developer';
GRANT SELECT ON evpointdb.nearAvailConnectors TO 'developer';
GRANT SELECT ON evpointdb.nearRSA TO 'developer';
GRANT 'developer' TO 'maria'@'localhost';

CREATE ROLE 'User';
GRANT SELECT on evpointdb.chargingStationMeanStars  TO 'User';
GRANT SELECT on evpointdb.nearAvailConnectors TO 'User';
GRANT SELECT on evpointdb.nearRSA TO 'User';
GRANT 'User' TO 'arbi'@'localhost';

CREATE ROLE 'Associate Company';
GRANT SELECT,INSERT ON evpointdb.chargingstation TO 'Associate Company';
GRANT SELECT,INSERT ON evpointdb.connector TO 'Associate Company';
GRANT 'Associate Company' TO 'tesla_consultant'@'localhost';
