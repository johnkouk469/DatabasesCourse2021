-- Best-rated charging station within about 0.75 degrees of each user.
-- Uses the chargingStationMeanStars view; requires MySQL 8.0+ (window functions).
SELECT userID,
       chargingStation_companyName,
       chargingStation_latitude,
       chargingStation_longtitude,
       meanStars AS rating
FROM (
  SELECT u.userID,
         s.chargingStation_companyName,
         s.chargingStation_latitude,
         s.chargingStation_longtitude,
         s.meanStars,
         ROW_NUMBER() OVER (PARTITION BY u.userID ORDER BY s.meanStars DESC) AS rn
  FROM `user` u
  JOIN chargingStationMeanStars s
    ON  u.latitude   BETWEEN s.chargingStation_latitude   - 0.75 AND s.chargingStation_latitude   + 0.75
    AND u.longtitude BETWEEN s.chargingStation_longtitude - 0.75 AND s.chargingStation_longtitude + 0.75
) ranked
WHERE rn = 1;
