# Module: codepipeline/main.tf
# Sets up a code pipeline, using passed in codebuilds

#data "aws_s3_bucket" "codepipeline_bucket" {
#  bucket = var.codepipeline_s3_bucket
#}

resource "aws_codepipeline" "codepipeline" {
  name     = var.cp_name
  role_arn = var.codepipeline_iam_role_policy_arn

  artifact_store {
    #location = data.aws_s3_bucket.codepipeline_bucket.bucket
    location = var.codepipeline_s3_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OAuthToken           = var.github_token
        Owner                = var.github_owner
        Repo                 = var.github_repo
        Branch               = var.github_branch
        PollForSourceChanges = true
      }
    }
  }

  dynamic "stage" {
    for_each = [for s in var.codebuild_stages : {
      name             = s.name
      category         = s.category
      input_artifacts  = s.input_artifacts
      output_artifacts = s.output_artifacts
      project_name     = s.project_name
    }]

    content {
      name = stage.value.name

      action {
        name             = stage.value.name
        category         = stage.value.category
        owner            = "AWS"
        provider         = "CodeBuild"
        input_artifacts  = stage.value.input_artifacts
        output_artifacts = stage.value.output_artifacts
        version          = "1"

        configuration = {
          ProjectName = stage.value.project_name
        }
      }
    }
  }
}
