terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "my-resource-group"
    storage_account_name = "leerndstoragename"
    container_name       = "devops-intern-leernd007"
    key                  = "terraform.tfstate"
    subscription_id      = "e3c4cde0-a72a-47a5-b1d0-71dfbe79f59c"
  }
}
provider "azurerm" {
  features {}
  subscription_id = "e3c4cde0-a72a-47a5-b1d0-71dfbe79f59c"
}

resource "azurerm_resource_group" "leernd007_resource_group" {
  name     = "my-resource-group"
  location = "Germany West Central"
}

resource "azurerm_container_group" "leernd007_container_group" {
  name                = "devops-intern-leernd007" #container group name
  location            = azurerm_resource_group.leernd007_resource_group.location
  resource_group_name = azurerm_resource_group.leernd007_resource_group.name
  os_type             = "Linux"

  container {
    name   = "postgres"
    image  = "postgres:11"
    cpu    = "0.5"
    memory = "1.5"

    environment_variables = {
      POSTGRES_USER             = "postgres_user"
      POSTGRES_PASSWORD         = "postgres_password"
      POSTGRES_DB               = "postgres"
      POSTGRES_HOST_AUTH_METHOD = "trust"
    }

    volume {
      name       = "leernd-volume"
      mount_path = "/var/lib/postgresql/data"
      empty_dir  = true
    }
    ports {
      port     = 5432
      protocol = "TCP"
    }
  }


  container {
    name   = "backend"
    image  = "leerndregistryname.azurecr.io/be_devops:latest"
    cpu    = "0.5"
    memory = "1.5"

    environment_variables = {
      DB_USER     = "postgres_user"
      DB_PASSWORD = "postgres_password"
      DB_NAME     = "postgres"
      DB_ENDPOINT = "postgres"
    }

    ports {
      port     = 8000
      protocol = "TCP"
    }
  }

  container {
    name   = "frontend"
    image  = "leerndregistryname.azurecr.io/fe_devops:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  image_registry_credential {
    username = "LeerndRegistryName"
    password = "18gyh/VhflBvnBfixTkh/NdiNKak2b8wqhB9qN206R+ACRDcjEZj"
    server   = "leerndregistryname.azurecr.io" // for docker hub private repository
  }
}