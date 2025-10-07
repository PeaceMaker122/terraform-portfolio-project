

# The S3 bucket "nextjs-portfolio-website-bucket" is used to store the Terraform state file securely and enable remote state management.
# The Terraform state file is used to keep track of the resources managed by Terraform.
# the state file is stored in a separarate s3 bucket to ensure that it is not accidentally deleted or modified.
# The DynamoDB table "terraform-locks" is used to manage state locking to prevent concurrent modifications, ensuring that only one user can make changes to the infrastructure at a time.

terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-peacemaker"
    key    = "global/s3/terraform.tfstate"
    region = "af-south-1"
    dynamodb_table = "terraform-locks"
    
  }
}



# Why do we use a remote backend?

# 1. Collaboration: A remote backend allows multiple team members to work on the same infrastructure
# 2. State Management: It provides a centralized way to manage and store the Terraform state file.
# 3. Locking: Remote backends can offer state locking, preventing concurrent modifications.
# 4. Security: Storing the state file remotely can enhance security by restricting access to sensitive information, if local storage is compromised.
# 5. Backup and Recovery: Remote backends often include features for backup and recovery of the state file.
# 6. Scalability: As infrastructure grows, remote backends can handle larger state files more efficiently than local storage.


# Note: Make sure to create the S3 bucket and DynamoDB table before using this configuration.
# Note: This configuration assumes you have already created the S3 bucket and DynamoDB table in the specified region.
# Note: Make sure to name the S3 bucket and DynamoDB table exactly what it is named in the code - when creating it MANUALLY.


# Note: Manually create your S3 bucket and DynamoDB table to avoid the resources being created by Infrastructure as Code. In case we end up deleting our infrastructure accidentally - the state file is not lost.


# ALWAYS name your Terraform files based on their purpose. For example, use names like main.tf, variables.tf, outputs.tf, and providers.tf to organize your configuration files effectively.
