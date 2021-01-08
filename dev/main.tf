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
  codebuild_iam_role_policy    = "${var.ns_prefix_use1}-cb-iampol"
  codepipeline_s3_bucket       = "${var.ns_prefix_use1}-cp-s3"
  codepipeline_iam_role_policy = "${var.ns_prefix_use1}-cp-iampol"
  providers = {
    aws = aws.use1
  }
}

# Create codebuilds needed for codepipeline
module "codebuild" {
  source           = "../modules/codebuild"
	depends_on = [module.setup]
  cb_name          = "${var.ns_prefix_use1}-cb-build"
  iam_role_pol     = module.setup.codebuild_iam_role_policy_arn
  codebuild_bucket = module.setup.codebuild_s3_bucket
  providers = {
    aws = aws.use1
  }
}

# Create codepipeline
module "codepipeline" {
  source                           = "../modules/codepipeline"
	depends_on = [module.setup]
  cp_name                          = "${var.ns_prefix_use1}-cp"
  codepipeline_s3_bucket           = module.setup.codepipeline_s3_bucket
  codepipeline_iam_role_policy_arn = module.setup.codepipeline_iam_role_policy_arn
  github_token                     = var.github_token
  github_owner                     = "geekaholic"
  github_repo                      = "first-lang"
  github_branch                    = "master"
  codebuild_stages                 = local.codebuild_stages
  providers = {
    aws = aws.use1
  }
}
