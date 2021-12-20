select companyName, latitude, longtitude 
from chargingstation 
left join user_reviews_chargingstation
on companyName = chargingStation_companyName
and chargingStation_latitude = latitude
and chargingStation_longtitude = longtitude
where user_reviews_chargingstation.date is NULL