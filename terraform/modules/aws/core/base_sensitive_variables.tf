### Databases
# PostgreSQL database configuration for gameplay
# The variable stores the name of the PostgreSQL database used for gameplay purposes. 
variable "gameplay_postgres_database" {
  description = "The Gameplay PostgreSQL database name"  # Description of the database name variable
  type        = string  # The variable type is string, as it stores the name of the database
  sensitive   = true  # Marks the value as sensitive to avoid exposure in logs
}

# PostgreSQL password configuration for gameplay
# The variable stores the password for the Gameplay PostgreSQL database. It is sensitive to maintain security.
variable "gameplay_postgres_password" {
  description = "The Gameplay PostgreSQL password"  # Describes the password variable for the PostgreSQL database
  type        = string  # The variable type is string as it holds a password
  sensitive   = true  # Marks the password as sensitive
}

# Grafana user configuration
# Stores the Grafana user credentials for logging into the Grafana dashboard.
variable "grafana_user" {
  type        = string  # The variable type is string, storing the username for Grafana login
  description = "Grafana user"  # Describes the user variable for Grafana access
  sensitive   = true  # The username is marked as sensitive to avoid exposure
}

# Grafana password configuration
# Stores the Grafana password for the user specified in the previous variable.
variable "grafana_password" {
  type        = string  # The variable type is string, as it stores the password
  description = "Grafana password"  # Describes the password variable for Grafana access
  sensitive   = true  # The password is marked as sensitive to protect security
}