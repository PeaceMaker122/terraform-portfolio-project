# Terraform Portfolio Project

A portfolio website built with Next.js and deployed to AWS using Terraform. The project demonstrates Infrastructure as Code (IaC) principles by provisioning and managing all AWS resources through Terraform configuration files.

## What This Project Does

The Next.js site is exported as a static site and hosted on AWS using an S3 bucket and a CloudFront distribution. Terraform handles all the infrastructure — from the S3 bucket and its access policies to the CloudFront distribution that serves the site over HTTPS.

## Architecture

```
User → CloudFront Distribution → S3 Bucket (static site)
```

- **Next.js** — static site generator (`output: 'export'`), produces HTML/CSS/JS files ready for S3
- **S3** — stores and serves the static site files
- **CloudFront** — CDN that sits in front of S3, enforces HTTPS, and improves global load times
- **Origin Access Identity (OAI)** — restricts direct S3 access so all traffic goes through CloudFront
- **Remote Terraform state** — state file stored in a separate S3 bucket with DynamoDB table for state locking

## Project Structure

```
terraform-portfolio-project/
├── nextjs-blog/                  # Next.js static website
│   ├── pages/
│   │   └── index.js              # Main page
│   ├── styles/                   # CSS modules
│   ├── public/                   # Static assets
│   ├── next.config.js            # Next.js config (static export)
│   └── terraform-nextjs/         # Terraform configuration
│       ├── main.tf               # S3 bucket + CloudFront resources
│       ├── output.tf             # Outputs: bucket endpoint, CloudFront URL
│       └── state.tf              # Remote backend (S3 + DynamoDB)
└── README.md
```

## Prerequisites

- [Node.js](https://nodejs.org/) (see `.nvmrc` for version)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- AWS CLI configured with appropriate credentials
- An S3 bucket and DynamoDB table for Terraform remote state (created manually — see `state.tf`)

## Getting Started

### 1. Build the Next.js site

```bash
cd nextjs-blog
npm install
npm run build
```

This generates the static output in the `out/` directory.

### 2. Provision the infrastructure

```bash
cd nextjs-blog/terraform-nextjs
terraform init
terraform plan
terraform apply
```

### 3. Deploy the site

Upload the contents of the `out/` directory to the S3 bucket:

```bash
aws s3 sync ../out s3://nextjs-portfolio-website-bucket
```

### 4. Access the site

After `terraform apply`, the CloudFront URL is printed as an output:

```bash
terraform output cloudfront_url
```

## Tearing Down

To destroy all AWS resources managed by Terraform:

```bash
cd nextjs-blog/terraform-nextjs
terraform destroy
```

> Note: The remote state S3 bucket and DynamoDB table are created manually and are not managed by Terraform, so they won't be affected by `terraform destroy`.
