SELECT *
FROM health
WHERE Car_licenseNumber = (SELECT licenseNumber
							FROM user_drives_car JOIN car ON car_licenseNumber = licenseNumber
							WHERE User_userID = 012546 )