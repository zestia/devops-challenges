resource "aws_s3_bucket" "devops_challenge" {
  bucket = "devops-challenge"

  tags = {
    Name        = "devops-chalenge"
    Environment = "test"
  }
}

resource "aws_s3_bucket_website_configuration" "devops_challenge" {
  bucket = aws_s3_bucket.devops_challenge.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

# Upload the website files to the S3 bucket
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}../site/", "**/*")

  bucket = aws_s3_bucket.devops_challenge.id
  source = each.value
  key    = each.value
}

# Set up the bucket policy to allow public access
resource "aws_s3_bucket_policy" "public_access_policy" {
  bucket = aws_s3_bucket.devops_challenge.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "s3:GetObject",
        Effect = "Allow",
        Resource = aws_s3_bucket.devops_challenge.arn,
        Principal = "*",
      },
    ],
  })
}