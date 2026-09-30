-- Health readings of the car(s) driven by user 012546.
SELECT *
FROM health
WHERE Car_licenseNumber IN (SELECT car_licenseNumber
                            FROM user_drives_car
                            WHERE user_userID = '012546');
