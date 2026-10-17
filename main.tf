terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

variable "project_id" {
  description = "Google Cloud project where resources will be created."
  type        = string
}

variable "region" {
  type    = string
  default = "asia-south1"
}

provider "google" {
  project = var.project_id
  region  = var.region
}


resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
  ])

  service            = each.value
  disable_on_destroy = false
}


resource "google_service_account" "runtime" {
  account_id   = "chat-tf-runtime"
  display_name = "Chat application runtime"

  depends_on = [google_project_service.apis]
}

variable "secret_id" {
  type    = string
  default = "chat-terraform-openai-key"
}

variable "secret_version" {
  type    = string
  default = "1"
}

resource "google_secret_manager_secret_iam_member" "runtime" {
  secret_id = var.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.runtime.email}"
}
