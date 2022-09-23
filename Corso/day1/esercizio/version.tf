terraform {
  required_version = ">= 0.15"

  required_providers {
    random = {
      source = "hashicorp/random"
      # ~ incrementa solo l'ultima parte del semantic indicato
      version = "~> 3.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.2.0"
    }    
  }
}

provider "random" {
  # Configuration options
}

