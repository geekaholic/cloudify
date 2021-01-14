# Module: setup/variables.tf

variable "codebuild_s3_bucket" {
  description = "Name of s3 bucket to create"
}

variable "codebuild_service_role" {
  description = "Name of IAM role policy to create"
}

variable "codepipeline_s3_bucket" {
  description = "Name of s3 bucket to create"
}

variable "codepipeline_iam_role_policy" {
  description = "Name of IAM role policy to create"
}
