

# The S3 bucket "nextjs-portfolio-website-bucket" is used to store the Terraform state file securely and enable remote state management.

terraform {
  backend "s3" {
    bucket = "nextjs-portfolio-website-bucket"
    key    = "global/s3/terraform.tfstate"
    region = "af-south-1"
    dynamodb_table = "terraform-locks"
    
  }
}