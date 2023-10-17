terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
  backend "azurerm" {
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.SUBSCRIPTION_ID
}

resource "azurerm_resource_group" "leernd007_resource_group" {
  name     = var.RESOURCE_GROUP
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
      POSTGRES_USER             = var.POSTGRES_USER
      POSTGRES_PASSWORD         = var.POSTGRES_PASSWORD
      POSTGRES_DB               = var.POSTGRES_DB
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
      DB_USER     = var.DB_USER
      DB_PASSWORD = var.DB_PASSWORD
      DB_NAME     = var.DB_NAME
      DB_ENDPOINT = var.DB_ENDPOINT
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
    username = var.USERNAME
    password = var.PASSWORD
    server   = var.SERVER
  }
}


resource "azurerm_virtual_network" "leernd_virtual_network" {
  name                = "leernd-network"
  resource_group_name = azurerm_resource_group.leernd007_resource_group.name
  location            = azurerm_resource_group.leernd007_resource_group.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.leernd007_resource_group.name
  virtual_network_name = azurerm_virtual_network.leernd_virtual_network.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_public_ip" "leernd_public_ip" {
  name                = "leernd-pip"
  resource_group_name = azurerm_resource_group.leernd007_resource_group.name
  location            = azurerm_resource_group.leernd007_resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.leernd_virtual_network.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.leernd_virtual_network.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.leernd_virtual_network.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.leernd_virtual_network.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.leernd_virtual_network.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.leernd_virtual_network.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.leernd_virtual_network.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "leernd-appgateway"
  resource_group_name = azurerm_resource_group.leernd007_resource_group.name
  location            = azurerm_resource_group.leernd007_resource_group.location

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 5
  }


  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.leernd_public_ip.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [azurerm_container_group.leernd007_container_group.ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 1
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

output "load_balancer_public_ip" {
  value = azurerm_public_ip.leernd_public_ip.ip_address
}
