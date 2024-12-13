module "core" {
  # Source of the core module. This points to the directory where the module's configuration is defined.
  # In this case, it's the "./core" directory relative to the current Terraform working directory.
  source = "./core"
  
  # AWS region where resources will be created. This value is passed to the core module.
  region = var.region
  
  # AWS Access Key for authenticating to AWS.
  # It is sensitive and should be managed securely.
  access_key = var.access_key
  
  # AWS Secret Key for secure authentication to AWS.
  # It is sensitive and should not be exposed in logs or outputs.
  secret_key = var.secret_key
  
  # The name of the EKS cluster.
  # This is passed to the core module to configure resources dependent on the EKS cluster.
  cluster_name = var.cluster_name
  
  # Grafana user for accessing the Grafana dashboard.
  # The username is passed from the variables and is used for authentication in Grafana.
  grafana_user = var.grafana_user
  
  # Grafana password for user authentication.
  # This password is sensitive and should be handled carefully.
  grafana_password = var.grafana_password
  
  # PostgreSQL password for the Gameplay database.
  # This password is sensitive and is used to connect to the database securely.
  gameplay_postgres_password = var.gameplay_postgres_password
  
  # Name of the Gameplay PostgreSQL database.
  # This name is passed to the core module to configure PostgreSQL-related resources.
  gameplay_postgres_database = var.gameplay_postgres_database
  
  # Specifies the dependencies for this module. 
  # Ensures that the `module.eks` (EKS module) is created before `module.core` is applied.
  depends_on = [module.eks]
}