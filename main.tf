# This block configures Terraform itself, including the backend where the state is stored.
terraform {
  cloud {
    # Replace with your actual TFC organization name.
    organization = "neelesh-cloud"

    # This connects the code to the specific TFC workspace you created earlier.
    workspaces {
      name = "gcp-production-infra"
    }
  }

  # This block specifies the cloud provider we are using (Google Cloud).
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Use a recent version
    }
  }
}

# This configures the Google Cloud provider with your project details.
provider "google" {
  # Replace with your actual GCP Project ID.
  project = "neelesh-project-468111"
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
