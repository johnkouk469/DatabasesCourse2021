CREATE USER 'kostas'@'localhost' IDENTIFIED BY 'zavarakatranemia';
CREATE USER 'tesla_consultant'@'localhost' IDENTIFIED BY 'elonmuskforever';
CREATE USER 'arbi'@'localhost' IDENTIFIED BY 'denxerwposopianeitodatsun';
CREATE USER 'maria'@'localhost' IDENTIFIED BY 'mySQLiSForNoobs';
CREATE USER 'kostakis'@'localhost' IDENTIFIED BY 'wannabeBackendManager123';


GRANT ALL PRIVILEGES ON evpointdb.* TO 'kostas'@'localhost';

CREATE ROLE 'stuff' ;
GRANT SELECT,INSERT,UPDATE,DROP ON evpointdb.* TO 'stuff';
GRANT 'stuff' TO 'kostakis'@'localhost';

CREATE ROLE 'developer';

GRANT SELECT,INSERT,UPDATE ON evpointdb.* TO 'developer';
REVOKE SELECT,INSERT,UPDATE ON evpointdb.user FROM 'developer';
GRANT 'developer' TO 'maria'@'localhost';

CREATE ROLE 'User';
GRANT SELECT on evpointdb.chargingstationmeanstars  TO 'User';
GRANT SELECT on evpointdb.nearavailconnectors TO 'User';
GRANT SELECT on evpointdb.nearrsa TO 'User';
GRANT 'User' TO 'arbi'@'localhost';

CREATE ROLE 'Associate Company';
GRANT SELECT,INSERT ON evpointdb.chargingstation TO 'Associate Company';
GRANT SELECT,INSERT ON evpointdb.connector TO 'Associate Company';
GRANT 'Associate Company' TO 'tesla_consultant'@'localhost';






