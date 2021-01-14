# cloudify - main.tf

locals {
  codebuild_stages = [
    {
      name             = "Build"
      category         = "Build"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      project_name     = "${var.ns_prefix_use1}-cb-build"
    }
  ]
}

data "template_file" "buildspec" {
  template = file("buildspec.yml")
  vars = {
    DOCKER_IMG = var.github_repo
		AWS_REGION = "us-east-1"
		REGISTRY_URL = aws_ecr_repository.ecr.repository_url
  }
}

# Create a VPC network with internet access
module "vpc-network" {
  source       = "../modules/vpc-network"
  cidr_block   = "10.0.0.0/16"
  vpc_tag_name = "east-vpc-1"
  providers = {
    aws = aws.use1
  }
}

# Setup resources such as IAM and S3 buckets
module "setup" {
  source                       = "../modules/setup"
  codebuild_s3_bucket          = "${var.ns_prefix_use1}-cb-s3"
  codebuild_service_role       = "${var.ns_prefix_use1}-cb-iampol"
  codepipeline_s3_bucket       = "${var.ns_prefix_use1}-cp-s3"
  codepipeline_iam_role_policy = "${var.ns_prefix_use1}-cp-iampol"
  providers = {
    aws = aws.use1
  }
}

# Create ECR for pushing docker images
resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  provider             = aws.use1

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create codebuilds needed for codepipeline
module "codebuild" {
  source           = "../modules/codebuild"
  depends_on       = [module.setup]
  cb_name          = "${var.ns_prefix_use1}-cb-build"
  service_role_arn = module.setup.codebuild_service_role_arn
  codebuild_bucket = module.setup.codebuild_s3_bucket
  buildspec        = data.template_file.buildspec.rendered
  providers = {
    aws = aws.use1
  }
}

# Create codepipeline
module "codepipeline" {
  source                           = "../modules/codepipeline"
  depends_on                       = [module.setup]
  cp_name                          = "${var.ns_prefix_use1}-cp"
  codepipeline_s3_bucket           = module.setup.codepipeline_s3_bucket
  codepipeline_iam_role_policy_arn = module.setup.codepipeline_iam_role_policy_arn
  github_token                     = var.github_token
  github_owner                     = var.github_owner
  github_repo                      = var.github_repo
  github_branch                    = var.github_branch
  codebuild_stages                 = local.codebuild_stages
  providers = {
    aws = aws.use1
  }
}
