output "bucket_regional_domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.website_distribution.domain_name
}






# Output.tf is used to define the output values that will be displayed after the Terraform apply command is executed.
# Output values are useful for displaying important information about the resources that have been created or modified by Terraform.
# In this case, we are outputting the S3 bucket website endpoint and the CloudFront distribution domain name.
# This information can be used to access the deployed Next.js portfolio website.