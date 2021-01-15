# Module: setup/main.tf
# Sets up IAM related resources

# Create codebuild artifact s3 bucket
resource "aws_s3_bucket" "codebuild_bucket" {
  bucket        = var.codebuild_s3_bucket
  acl           = "private"
  force_destroy = true
}

# Create IAM role for codebuilds
resource "aws_iam_role" "codebuild_role" {
  name = var.codebuild_service_role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


# Create IAM policy for codebuilds
resource "aws_iam_role_policy" "codebuild_policy" {
  name = var.codebuild_service_role
  #role = aws_iam_role.codebuild_role.id
  role = aws_iam_role.codebuild_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
				"s3:GetBucketAcl",
        "s3:PutObject",
				"secretsmanager:DescribeSecret",
				"secretsmanager:GetSecretValue"
      ],
      "Resource": ["*"]
    }
  ]
}
POLICY
}

# Create codepipeline artifact s3 bucket
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = var.codepipeline_s3_bucket
  acl           = "private"
  force_destroy = true
}

# Create IAM role for codepipeline
resource "aws_iam_role" "codepipeline_role" {
  name = var.codepipeline_iam_role_policy

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Create IAM policy for pipeline
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = var.codepipeline_iam_role_policy
  role = aws_iam_role.codepipeline_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": ["*"]
    }
  ]
}
POLICY
}

