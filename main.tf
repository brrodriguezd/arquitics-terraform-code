terraform {
	required_providers {
		github = {
			source = "integrations/github"
			version = "~> 6.0"
		}
	}
}

# Configure the GitHub Provider
provider "github" {}

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
  
  # Initialize with README
  auto_init = true
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

# Create repository labels
resource "github_issue_label" "labels" {
  for_each    = toset(["dev", "prod", "feature"])
  repository  = github_repository.terraform.name
  name        = each.key
  color       = each.key == "p1" ? "ff0000" : (each.key == "p2" ? "ffff00" : "00ff00")
  description = "Priority ${each.key}"
}

