# Create a new repository
resource "github_repository" "terraform" {
  name        = "terraform-laboratory"
  description = "Repository created and managed by Terraform, for Arquitics"
  
  # Set repository visibility
  visibility = "public"
  
  
  # Enable automated security features
  vulnerability_alerts = true
  
  # Configure branch protection
  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  
  # Configure template, I'm using AWS terraform template
  template {
    owner      = "aws-ia"
    repository = "terraform-repo-template"
  }
}

# Configure branch protection for main branch
resource "github_branch_protection" "main" {
  repository_id = github_repository.terraform.node_id
  pattern       = "main"
  
  # Require pull request reviews
  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews          = true
    require_code_owner_reviews     = true
  }
  
  # Require status checks to pass before merging
  required_status_checks {
    strict = true
    contexts = ["continuous-integration/github-actions"]
  }
  
  # Prevent force pushes
  enforce_admins = true
  
  # Require linear history
  required_linear_history = true
}

