# Module: setup/outputs.tf

output "codebuild_service_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "codebuild_s3_bucket" {
  value = aws_s3_bucket.codebuild_bucket.bucket
}

output "codepipeline_iam_role_policy_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "codepipeline_s3_bucket" {
  value = aws_s3_bucket.codepipeline_bucket.bucket
}
