terraform {
    required_providers {
       github = {
        source="integrations/github"
        version="5.39.0"
       }
    }
}

provider "github" {
    owner = "k2etest"
    token = var.gh_token
}