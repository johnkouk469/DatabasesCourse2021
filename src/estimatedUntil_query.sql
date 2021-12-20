select connectorID, occupiedEstimatedUntil
from connector join occupiedconnector on connectorID = OccupiedConnectorID
where (chargingStation_companyName = "Tesla") 
and (chargingStation_latitude = 50.623544 )
and (chargingStation_longtitude = 40.646534);