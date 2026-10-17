project_id        = "project-4c0b47fc-203d-4c2e-a87"
region            = "asia-south1"
github_owner      = "PrachiSShirke"
github_repository = "chat-service"

# Terraform creates this dedicated image repository.
repository_id = "chat-service-tf-repo"

# Existing secret containing only the API key, without OPENAI_API_KEY=.
secret_id      = "chat-terraform-openai-key"
secret_version = "1"

# Optional initial app image. Default: placeholder until the trigger runs.
# image = "asia-south1-docker.pkg.dev/project-4c0b47fc-203d-4c2e-a87/chat-service/app:tag"