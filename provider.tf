provider "azurerm" {
  features {}
  subscription_id = var.subscriptionId
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

