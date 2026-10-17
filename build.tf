resource "google_service_account" "builder" {
  account_id   = "chat-tf-builder"
  display_name = "Chat build and deployment"

  depends_on = [google_project_service.apis]
}

resource "google_artifact_registry_repository" "images" {
  location      = var.region
  repository_id = "chat-service-tf-repo"
  format        = "DOCKER"

  depends_on = [google_project_service.apis]
}

resource "google_artifact_registry_repository_iam_member" "builder" {
  location   = google_artifact_registry_repository.images.location
  repository = google_artifact_registry_repository.images.name

  role   = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.builder.email}"
}

resource "google_project_iam_member" "builder_logs" {
  project = var.project_id

  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.builder.email}"
}