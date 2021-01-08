# Module: codepipeline/variables.tf

variable "cb_name" {
  description = "CodeBuild project name"
}

variable "iam_role_pol" {
  description = "IAM role policy for codebuild"
}

variable "codebuild_bucket" {
  description = "Codebuild artifact s3 bucket"
}

variable "env_vars" {
  type        = list(any)
  description = "Codebuild env vars"
  default     = []
}

variable "compute_type" {
  description = "EC2 instance type"
  default     = "BUILD_GENERAL1_SMALL"
}

variable "docker_image" {
  description = "Docker image used for codebuild env"
  default     = "aws/codebuild/standard:2.0"
}

variable "buildspec" {
  description = "Codebuild buildspec"
  default     = ""
}
