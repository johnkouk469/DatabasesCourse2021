select userID, connectorType
from evpointdb.nearAvailConnectors
where connectorType = "CCS2"
union
select userID, connectorType
from evpointdb.nearAvailConnectors
where connectorType = "Tesla TYPE 2"