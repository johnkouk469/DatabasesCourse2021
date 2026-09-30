# EVPointDB

Relational database design and MySQL implementation for **EVPoint**, a mobile
web service that helps electric-vehicle drivers find charging stations, monitor
their car's health and call roadside assistance.

Course project for *Databases* (9th semester, School of Electrical and Computer
Engineering, Aristotle University of Thessaloniki, 2021), Group 39.

## Schema

![EVPointDB schema](Assets/EVPointDB_schema.png)

The database `evpointdb` has 11 tables and 3 views.

- **Tables:** `user`, `car`, `user_drives_car`, `user_owns_car`, `health`,
  `chargingstation`, `connector`, `occupiedconnector`,
  `user_reviews_chargingstation`, `rsa` (roadside assistance) and `user_calls_rsa`.
- **Views:** `chargingStationMeanStars` (average review rating per station),
  `nearAvailConnectors` (available connectors near each user) and `nearRSA`
  (roadside assistance near each user).

The ER and relational diagrams are in `EVP_ER.drawio` and `EVP_RD.drawio`
(open with [diagrams.net](https://app.diagrams.net)). The MySQL Workbench model
is `src/EVPoint.mwb`.

## Repository layout

| Path | Contents |
|---|---|
| `src/EVPoint_dump.sql` | Schema, views and sample data |
| `src/users.sql` | Example users, roles and privileges |
| `src/*_query.sql`, `src/best_near_connector.sql` | Example queries |
| `src/EVPoint.mwb` | MySQL Workbench model |
| `EVP_ER.drawio`, `EVP_RD.drawio` | ER and relational diagrams |
| `Assets/` | Schema image used in this README |

## Requirements

MySQL 8.0 or newer, and a MySQL account that can create databases. MariaDB is
not supported: the dump uses MySQL 8 collations.

## Setup

Run these from the repository root. The same commands work on Windows
(PowerShell or cmd), macOS and Linux, because they avoid shell redirection
(`<`), which PowerShell does not support:

```
mysql -u <your_user> -p --default-character-set=utf8mb4 -e "source src/EVPoint_dump.sql"
```

Then check that it loaded:

```
mysql -u <your_user> -p evpointdb -e "SHOW FULL TABLES;"
```

Notes:

- **The dump drops and recreates `evpointdb`.** Any existing database with that
  name is deleted.
- **Linux / WSL:** on a default Ubuntu install, MySQL's `root` account logs in
  through the operating system, not a password. Use `sudo mysql ...` (no `-u`
  or `-p`), or create your own user first.
- **Non-English text:** keep `--default-character-set=utf8mb4`. The sample data
  contains Greek license plates and notes.
- **Car photos:** the dump loads photos with `load_file()` from paths that don't
  exist on your machine, so the photo column is empty (`NULL`). This does not
  affect the queries.
- **GUI alternative:** in MySQL Workbench, use *File → Run SQL Script...* and
  choose `src/EVPoint_dump.sql`.

## Running the example queries

```
mysql -u <your_user> -p evpointdb -e "source src/available_connectors_query.sql"
```

| Script | What it answers |
|---|---|
| `available_connectors_query.sql` | Which connectors are available, and where |
| `estimatedUntil_query.sql` | When an occupied connector at a given station is expected to free up |
| `health_query.sql` | Health telemetry of the car belonging to a given user |
| `notReviewedStation_query.sql` | Charging stations nobody has reviewed yet |
| `best_near_connector.sql` | Best-rated station near each user |
| `query_with_union.sql` | Users near an available CCS2 or Tesla TYPE 2 connector |

## Users and privileges

`src/users.sql` creates example accounts and roles (administrator, staff,
developer, user, associate company). Run it after loading the dump, because it
grants privileges on `evpointdb`.

All accounts and passwords in this repository are fictional placeholders made
up for a university assignment. They were never used anywhere else. Set your own
before using the script on a real server.

## Known limitations

- The sample data is small and synthetic. Some queries return only one or two
  rows.
- The example accounts in `users.sql` can only connect from `localhost`.
- "Near" is a bounding box in degrees of latitude and longitude, not a real
  distance.
- Credentials are written directly in `users.sql` because this is a course
  example. In a real project, keep credentials out of the repository, for
  example in environment variables or a git-ignored config file.
