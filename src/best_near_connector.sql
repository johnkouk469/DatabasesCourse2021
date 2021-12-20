select userID, chargingStation_companyName, chargingStation_latitude, chargingStation_longtitude, max(meanStars) as rating
from user join chargingstationmeanstars
where ( user.latitude > chargingStation_latitude - 0.75 )
and ( user.latitude < chargingStation_latitude + 0.75 )
and ( user.longtitude > chargingStation_longtitude - 0.75 )
and ( user.longtitude < chargingStation_longtitude + 0.75 )