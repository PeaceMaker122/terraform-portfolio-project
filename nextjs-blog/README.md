This is a starter template for [Learn Next.js](https://nextjs.org/learn).




# Next.js Portfolio Website with Terraform Deployment

## 📹 Project Overview Video
I created a [Loom video](https://www.loom.com/share/6df7053567f44ac080db4c0c44f1d0ae?sid=554e81bd-5d74-4a69-b934-1255c9204d98) walking through:
- Project structure and configuration files
- Component organization and reusability
- Static assets management
- Styling approach and implementation

---

# Below is a very detailed outline of the complete project from beginning to end. What I did to start the project and all the way until the end of accessing the website via the CloudFound URL in the web browser to view the deployed Next.js portfolio site.


## 📋 Project Details

### Client Profile
**Client:** James Smith  
**Role:** Freelance Web Designer  
**Project:** Portfolio Website Deployment  

### Project Description
A modern, responsive single-page portfolio website built with Next.js, requiring robust and scalable cloud hosting with global reach and optimal performance.

### Our Role
Implementation of AWS infrastructure using Terraform IaC principles for deployment and hosting.

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

## 📝 Implementation Guide

### 1. Project Setup

#### 1.1 GitHub Repository Setup
```bash
# Create and clone repository
git clone https://github.com/<your-username>/terraform-portfolio-project.git
cd terraform-portfolio-project
```

#### 1.2 Next.js Installation
```bash
# Create Next.js project
npx create-next-app@latest nextjs-blog --use-npm --example "https://github.com/vercel/next-learn/tree/main/basics/learn-starter"

# Start development server
cd blog
npm run dev
```

#### 1.3 Configuration
Create `next.config.js`:
```javascript
const nextConfig = {
  output: 'export',
}

module.exports = nextConfig
```

#### 1.4 Build Process
```bash
npm run build
```

### 2. Version Control

```bash
git init
git add .
git commit -m "Initial commit of Next.js portfolio starter kit"
git remote add origin https://github.com/<your-username>/terraform-portfolio-project.git
git push -u origin master
```

### 3. Terraform Infrastructure

#### 3.1 Project Structure
```bash
mkdir terraform-nextjs
cd terraform-nextjs
```

#### 3.2 Key Terraform Components

1. **S3 Bucket Configuration**
```hcl
resource "aws_s3_bucket" "website" {
  bucket = "your-unique-bucket-name"
  
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  
  tags = {
    Name = "Portfolio Website"
    Environment = "Production"
  }
}
```

2. **CloudFront Distribution**
```hcl
resource "aws_cloudfront_distribution" "website_distribution" {
  // ... existing CloudFront configuration ...
}
```

3. **Output Configuration**
```hcl
output "cloudfront_url" {
  value = aws_cloudfront_distribution.website_distribution.domain_name
}
```

### 4. Deployment

```bash
# Initialize Terraform
terraform init
terraform plan
terraform apply

# Upload website files
aws s3 sync ../blog/out s3://your-bucket-name
```

### 5. 🌐 Website Access
```bash
# Get deployment URL
terraform output cloudfront_url
```

## ⚠️ Important Notes
- Always verify paths and bucket names before deployment
- Refer to official Terraform AWS documentation for latest updates
- Follow AWS best practices for security and optimization

---

_This project template is based on [Learn Next.js](https://nextjs.org/learn)_