resource "github_repository" "terraform-repo" {
  name = var.repo_name
  description = var.repo_description

  visibility = "public"

  auto_init = true
}

resource "github_branch" "development" {
    repository = github_repository.terraform-repo.name
    branch = "development"
}

// Makes 'development' default branch
resource "github_branch_default" "default" {
    repository = github_repository.terraform-repo.name
    branch = github_branch.development.branch
}

// Defines Branch Protection Rules for terraform-test repo
resource "github_branch_protection" "terraform-repo" {
    repository_id = github_repository.terraform-repo.node_id
    pattern = "development"

    enforce_admins = true

    required_status_checks {
      strict = true // Forces branch to be up to date prior to merging
    }

    required_pull_request_reviews {
      dismiss_stale_reviews = true // New commits will require new review
      required_approving_review_count = 1 // Needs approval before pull requests
      require_last_push_approval = true // Most recent pusher cannot approve most recent push
    }

    push_restrictions = [data.github_user.kim.node_id, data.github_user.smeet.node_id]

    allows_force_pushes = false
}