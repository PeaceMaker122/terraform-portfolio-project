provider "aws" {
  region = "af-south-1"
}

# Configure the AWS Provider
# Write Terraform resource code to create desired AWS resources.
# Initialize the AWS provider to interact with AWS services.                                                        (Terraform Init)
# Plan Terraform configurations to ensure they are syntactically correct and to see what actions will be taken.     (Terraform Plan)
# Apply the Terraform configurations to create, update, or delete resources in your AWS environment.                (Terraform Apply)
# Destroy the Terraform-managed infrastructure when it is no longer needed.                                         (Terraform Destroy)


# S3 Bucket for Hosting Next.js Portfolio Website

resource "aws_s3_bucket" "website" {
  bucket = "nextjs-portfolio-website-bucket"

  tags = {
    Name        = "Portfolio Website"
    Environment = "Production"
  }
}

# Block all public access — traffic must go through CloudFront only

resource "aws_s3_bucket_public_access_block" "website_public_access_block" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# S3 Bucket Policy — grants read access to CloudFront via OAC only

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id

  depends_on = [aws_s3_bucket_public_access_block.website_public_access_block]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website_distribution.arn
          }
        }
      }
    ]
  })
}

# Origin Access Control (OAC) — modern replacement for OAI
# Scopes CloudFront access to this specific S3 bucket

resource "aws_cloudfront_origin_access_control" "website_oac" {
  name                              = "OAC for Next.js Portfolio Website"
  description                       = "Origin Access Control for Next.js Portfolio S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution for Next.js Portfolio Website

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-Website"
    origin_access_control_id = aws_cloudfront_origin_access_control.website_oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for Next.js Portfolio Website"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Website"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "Portfolio CloudFront"
    Environment = "Production"
  }
}
