# Module: codepipeline/variables.tf

variable "cp_name" {
  description = "Name of codepipeline"
}

variable "codepipeline_s3_bucket" {
  description = "Name of s3 bucket used for artifacts"
}

variable "codepipeline_iam_role_policy_arn" {
  description = "IAM policy arn"
}

variable "github_token" {
  description = "Github OAuth token"
}

variable "github_branch" {
  description = "Name of github branch for CodePipeline"
}

variable "github_repo" {
  description = "Github repo name"
}

variable "github_owner" {
  description = "Github repo owner"
}

variable "codebuild_stages" {
  type        = list(any)
  description = "Codebuild stages for the pipeline"
  default     = []
}

