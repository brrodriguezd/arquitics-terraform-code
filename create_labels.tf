# Create repository labels
resource "github_issue_label" "labels" {
  for_each    = toset(["dev", "prod", "feature"])
  repository  = github_repository.terraform.name
  name        = each.key
  color       = each.key == "p1" ? "ff0000" : (each.key == "p2" ? "ffff00" : "00ff00")
  description = "Priority ${each.key}"
}
