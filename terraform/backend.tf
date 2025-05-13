
#main backend configurations for terraform state management
resource "aws_s3_bucket" "tf_state" {
    bucket = "aws-ec2-web-infra-bucket"

    tags = {
        Name = "aws-ec2-web-infra-bucket"
        Environment = "dev"
    }
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
    bucket = aws_s3_bucket.tf_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_public_access_block" "tf_state_public_access" {
    bucket = aws_s3_bucket.tf_state.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}