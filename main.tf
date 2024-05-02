terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.27.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "training-416401"
  region = "us-central1"
  credentials = "training-416401-151621fcb8a1.json"
}

resource "google_storage_bucket" "static_site" {
  name          = "armageddon-static-site"
  location      = "US"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  cors {
    origin          = ["*"]
    method          = ["GET"]
    response_header = ["Content-Type"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  bucket = google_storage_bucket.static_site.name
  source = "index.html"
  content_type = "text/html"
}
output "website_url" {
  value = "http://${google_storage_bucket.static_site.name}.storage.googleapis.com"
}

