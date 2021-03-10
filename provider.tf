provider "azurerm" {
  features {}
  #subscription_id = "208fa6bb-143c-4bbd-995e-e4e524978ba3"
  /*
  subscription_id = "${var.subscriptionId}"  
  client_id       = "${var.clientId}"
  client_secret   = "${var.clientSecret}"
  tenant_id       = "${var.tenantId}"
  */
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id  
  
}

