terraform {
  required_version = ">= 1.2.7"

  required_providers {
    f5xc = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.11"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}