provider "aws" {
  region = "af-south-1"
  
}

# S3 Bucket for Hosting Next.js Portfolio Website

resource "aws_s3_bucket" "website" {
  bucket = "nextjs-portfolio-website-bucket"
  
  website {
    index_document = "index.html"
    # For single-page applications (SPAs) like Next.js, set error_document to "index.html"
    # so that all routes are handled by the client-side router, enabling proper navigation.
    error_document = "index.html"
  }
  
  tags = {
    Name = "Portfolio Website"
    Environment = "Production"
  }
}

# Ownership Controls to enforce bucket owner full control

resource "aws_s3_bucket_ownership_controls" "website_ownership_controls" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Public Access Block Configuration to allow public access for website hosting

resource "aws_s3_bucket_public_access_block" "website_public_access_block" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# S3 Bucket ACL to make the bucket objects publicly readable

resource "aws_s3_bucket_acl" "website_acl" {

  depends_on = [aws_s3_bucket_public_access_block.website_public_access_block, aws_s3_bucket_ownership_controls.website_ownership_controls]
  bucket    = aws_s3_bucket.website.id
  acl       = "public-read"
}

# S3 Bucket Policy for Next.js Portfolio Website

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# CloudFront Distribution for Next.js Portfolio Website

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.website.website_endpoint
    origin_id   = "S3-Website"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      # S3 website endpoints only support HTTP, not HTTPS, so "http-only" is required here.
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  enabled             = true
  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
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
    Name = "Portfolio CloudFront"
    Environment = "Production"
  }
}
