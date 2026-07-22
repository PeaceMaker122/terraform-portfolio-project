# Next.js Portfolio Website with Terraform Deployment

A modern, responsive portfolio website built with Next.js and deployed to AWS using Infrastructure as Code (IaC) principles with Terraform.

## 📹 Project Overview Video

I created a [Loom video](https://www.loom.com/share/6df7053567f44ac080db4c0c44f1d0ae?sid=554e81bd-5d74-4a69-b934-1255c9204d98) walking through:
- Project structure and configuration files
- Component organization and reusability
- Static assets management
- Styling approach and implementation

---

## 📋 Project Details

**Client:** James Smith  
**Role:** Freelance Web Designer  
**Project:** Portfolio Website Deployment

### Project Description

A single-page portfolio website requiring robust, scalable cloud hosting with global reach and optimal performance. The site is built with Next.js and exported as a static site, hosted on AWS via S3 and served globally through CloudFront.

### Our Role

Full implementation of AWS cloud infrastructure using Terraform IaC — from provisioning the S3 bucket and CloudFront distribution to managing remote state with S3 and DynamoDB.

---

## 🎯 Requirements

| Requirement | Description |
|-------------|-------------|
| High Availability | Worldwide access with minimal downtime |
| Scalability | Efficient handling of traffic spikes |
| Cost Optimization | Balanced performance and cost management |
| Performance | Fast loading times globally |

## 🚀 Project Objectives

1. Deploy Next.js website on AWS
2. Implement Infrastructure as Code using Terraform
3. Configure AWS CloudFront for global content delivery
4. Implement security best practices
5. Maintain code on GitHub

---

## 🏗️ Architecture

```
User → CloudFront Distribution → S3 Bucket (static site)
```

| Component | Role |
|-----------|------|
| **Next.js** | Static site generator (`output: 'export'`), produces HTML/CSS/JS ready for S3 |
| **S3** | Stores and serves the static site files |
| **CloudFront** | CDN that enforces HTTPS and improves global load times |
| **Origin Access Identity (OAI)** | Restricts direct S3 access so all traffic routes through CloudFront |
| **Remote Terraform State** | State file stored in a separate S3 bucket, with DynamoDB for state locking |

---

## 💡 Next.js Overview

### Core Features

| Feature | Description |
|---------|-------------|
| SSR | Server-side rendering for each request |
| SSG | Static site generation at build time |
| API Routes | Built-in serverless function support |
| File Routing | Intuitive file-based navigation |
| Styling Support | Integrated CSS and Sass capabilities |
| Code Splitting | Optimized JavaScript loading |

### Use Cases
- 🎨 Static Websites (Portfolios, Blogs)
- 🛍️ E-Commerce Platforms
- 🏢 Corporate Websites
- 📊 Web Applications
- 📝 Content Management Systems

---

## 📁 Project Structure

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

---

## 🛠️ Prerequisites

- [Node.js](https://nodejs.org/) (see `.nvmrc` for version)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- AWS CLI configured with appropriate credentials
- An S3 bucket and DynamoDB table for Terraform remote state (created manually — see `state.tf`)

---

## 📝 Implementation Guide

### 1. Project Setup

#### 1.1 GitHub Repository

```bash
git clone https://github.com/PeaceMaker122/terraform-portfolio-project.git
cd terraform-portfolio-project
```

#### 1.2 Next.js Installation

```bash
npx create-next-app@latest nextjs-blog --use-npm --example "https://github.com/vercel/next-learn/tree/main/basics/learn-starter"
cd nextjs-blog
npm run dev
```

#### 1.3 Static Export Configuration

Add the following to `next.config.js` to enable static export:

```javascript
const nextConfig = {
  output: 'export',
}

module.exports = nextConfig
```

#### 1.4 Build the Site

```bash
npm run build
```

This generates the static output in the `out/` directory, ready to upload to S3.

---

### 2. Terraform Infrastructure

#### 2.1 Key Terraform Components

**S3 Bucket** — hosts the static site files:

```hcl
resource "aws_s3_bucket" "website" {
  bucket = "nextjs-portfolio-website-bucket"

  tags = {
    Name        = "Portfolio Website"
    Environment = "Production"
  }
}
```

**CloudFront Distribution** — serves the site globally over HTTPS:

```hcl
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "S3-Website"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"
  # ... full configuration in main.tf
}
```

**Outputs** — printed after `terraform apply`:

```hcl
output "cloudfront_url" {
  value = aws_cloudfront_distribution.website_distribution.domain_name
}
```

#### 2.2 Remote State

State is stored remotely in S3 with DynamoDB locking. Create the S3 bucket and DynamoDB table manually before running Terraform — this ensures the state file is never accidentally destroyed with the rest of the infrastructure.

```hcl
terraform {
  backend "s3" {
    bucket         = "your-state-bucket-name"
    key            = "global/s3/terraform.tfstate"
    region         = "af-south-1"
    dynamodb_table = "your-lock-table-name"
  }
}
```

---

### 3. Deployment

#### 3.1 Provision the infrastructure

```bash
cd nextjs-blog/terraform-nextjs
terraform init
terraform plan
terraform apply
```

#### 3.2 Upload the site to S3

```bash
aws s3 sync ../out s3://nextjs-portfolio-website-bucket
```

#### 3.3 Access the site

```bash
terraform output cloudfront_url
```

Open the returned URL in your browser to view the live deployed site.

---

## 🗑️ Tearing Down

To destroy all Terraform-managed AWS resources:

```bash
cd nextjs-blog/terraform-nextjs
terraform destroy
```

> **Note:** The remote state S3 bucket and DynamoDB table are created manually and are not managed by Terraform — they will not be affected by `terraform destroy`.

---

## ⚠️ Important Notes

- Always verify bucket names and paths before deployment
- Refer to the [Terraform AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) for the latest resource configurations
- Follow AWS best practices for security and cost optimization

---

*This project uses the [Learn Next.js](https://nextjs.org/learn) starter template as its base.*
