# This block configures Terraform itself, including the backend where the state is stored.
terraform {
  cloud {
    organization = "neelesh-cloud"
    workspaces {
      name = "gcp-prod-infra"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    # We also need to add the random provider since it's being used.
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# This new variable block receives the sensitive JSON key from Terraform Cloud.
variable "gcp_credentials_json" {
  type        = string
  description = "The GCP service account key JSON, passed in as a variable."
  sensitive   = true
}

# This updated provider block now uses the variable for authentication.
provider "google" {
  project     = "neelesh-project-468111"
  credentials = var.gcp_credentials_json # This line uses the credentials variable
}

# This resource defines a Google Cloud Storage bucket.
resource "google_storage_bucket" "website_bucket" {
  # The name must be globally unique, so we add a random suffix.
  name     = "my-unique-website-bucket-${random_id.suffix.hex}"
  location = "US" # You can choose any valid location.

  # This setting is useful for demos, allowing easy deletion.
  force_destroy = true
}

# This resource generates a random string to ensure the bucket name is unique.
resource "random_id" "suffix" {
  byte_length = 8
}
