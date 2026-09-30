-- Connectors that are occupied right now and when each is expected to be free again.
-- To look at one station only, add for example:
--   AND c.chargingStation_companyName = 'YourOperator'
SELECT c.connectorID,
       c.chargingStation_companyName,
       c.chargingStation_latitude,
       c.chargingStation_longtitude,
       o.occupiedEstimatedUntil
FROM connector c
JOIN occupiedconnector o ON c.connectorID = o.OccupiedConnectorID
WHERE c.availability = -1
  AND o.occupiedUntil IS NULL
ORDER BY o.occupiedEstimatedUntil;
