resource "google_sql_database_instance" "database_instance" {
  name = "database-instance"
  database_version = "POSTGRES_13"
  region = "us-central1"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL"
  }
}

resource "google_sql_database" "capstone_database" {
  name = "capstone-database"
  instance = google_sql_database_instance.database_instance.name

  charset = "UTF8"
  collation = "en_US.UTF8"
}