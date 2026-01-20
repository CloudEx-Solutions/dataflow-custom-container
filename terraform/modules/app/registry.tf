resource "google_project_service" "artifactregistry" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Create the Artifact Registry Repository
resource "google_artifact_registry_repository" "my_docker_repo" {
  location      = var.gcp_region
  repository_id = "docker-registry"
  description   = "Docker repository for Dataflow custom containers images"
  format        = "DOCKER"

  depends_on = [google_project_service.artifactregistry]
}

# Output the URL for use in CI/CD pipelines
output "repository_url" {
  value = "${google_artifact_registry_repository.my_docker_repo.location}-docker.pkg.dev/${google_artifact_registry_repository.my_docker_repo.project}/${google_artifact_registry_repository.my_docker_repo.repository_id}"
}
