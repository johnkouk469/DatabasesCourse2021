-- For each user: the best-rated charging station that has an available connector nearby.
-- "Nearby" comes from the nearAvailConnectors view (within 0.05 degrees, about 5 km).
-- Stations without any review are not ranked. Requires MySQL 8.0+ (window functions).
SELECT userID,
       chargingStation_companyName,
       chargingStation_latitude,
       chargingStation_longtitude,
       meanStars AS rating
FROM (
  SELECT n.userID,
         n.chargingStation_companyName,
         n.chargingStation_latitude,
         n.chargingStation_longtitude,
         s.meanStars,
         ROW_NUMBER() OVER (PARTITION BY n.userID ORDER BY s.meanStars DESC) AS rn
  FROM nearAvailConnectors n
  JOIN chargingStationMeanStars s
    ON  s.chargingStation_companyName = n.chargingStation_companyName
    AND s.chargingStation_latitude    = n.chargingStation_latitude
    AND s.chargingStation_longtitude  = n.chargingStation_longtitude
) ranked
WHERE rn = 1;
