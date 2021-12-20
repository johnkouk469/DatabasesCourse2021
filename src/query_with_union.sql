select userID, connectorType
from evpointdb.nearavailconnectors
where connectorType = "CCS2"
union
select userID, connectorType
from evpointdb.nearavailconnectors
where connectorType = "Tesla TYPE 2"