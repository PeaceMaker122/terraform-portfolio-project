
# The S3 bucket "sadgwryhhg" is used to store the Terraform state file securely and enable remote state management.
# The Terraform state file is used to keep track of the resources managed by Terraform.
# The state file is stored in a separate S3 bucket to ensure that it is not accidentally deleted or modified.
# S3 native state locking (use_lockfile = true) is used to prevent concurrent modifications, ensuring that only
# one user can make changes to the infrastructure at a time. This replaces the legacy DynamoDB locking approach,
# which was deprecated in Terraform 1.11.

terraform {
  backend "s3" {
    bucket       = "sadgwryhhg"
    key          = "global/s3/terraform.tfstate"
    region       = "af-south-1"
    use_lockfile = true
  }
}



# Why do we use a remote backend?

# 1. Collaboration: A remote backend allows multiple team members to work on the same infrastructure.
# 2. State Management: It provides a centralized way to manage and store the Terraform state file.
# 3. Locking: Remote backends offer state locking, preventing concurrent modifications.
# 4. Security: Storing the state file remotely enhances security by restricting access to sensitive information.
# 5. Backup and Recovery: Remote backends include features for backup and recovery of the state file.
# 6. Scalability: As infrastructure grows, remote backends handle larger state files more efficiently than local storage.


# Note: Make sure to create the S3 bucket before using this configuration.
# Note: This configuration assumes you have already created the S3 bucket in the specified region.
# Note: Make sure to name the S3 bucket exactly as it is named in the code when creating it MANUALLY.


# Note: Manually create your S3 bucket to avoid the resource being managed by Infrastructure as Code.
# In case infrastructure is accidentally destroyed, the state file will not be lost.


# ALWAYS name your Terraform files based on their purpose. For example, use names like main.tf, variables.tf, outputs.tf, and providers.tf to organize your configuration files effectively.
