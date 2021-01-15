# Module: codebuild/main.tf
# Sets up a codebuild task

# Create codebuild task
resource "aws_codebuild_project" "codebuild_project" {
  name         = var.cb_name
  service_role = var.service_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = var.codebuild_bucket
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.docker_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = [for v in var.env_vars : {
        name  = v.name
        value = v.value
      }]
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.cb_name}-lg-group"
      stream_name = "${var.cb_name}-lg-stream"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }
}
