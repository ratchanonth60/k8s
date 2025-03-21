# 🚀 Django on EKS with Terraform

Welcome to **Django on EKS with Terraform**! This project is your sleek, modern toolkit for deploying a Django application on Amazon Elastic Kubernetes Service (EKS) using Terraform. Tailored for the `ap-southeast-1` (Singapore) region, it spins up a VPC, an EKS cluster, and Kubernetes manifests to get your Django app live with style and scalability.

---

## 🗂️ Project Structure
```bash
django-eks-terraform/
├── modules/                # 🛠️ Reusable Terraform Modules
│   ├── vpc/               # VPC Configuration
│   └── eks/               # EKS Cluster Setup
├── environments/          # 🌍 Environment-Specific Configs
│   ├── prod/             # Production Environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── dev/              # Development Environment (Optional)
├── Dockerfile            # 🐳 Docker Setup for Django
├── django-deployment.yaml # 📦 Kubernetes Deployment Manifest
├── django-service.yaml   # 🌐 Kubernetes Service Manifest
├── Makefile              # ⚙️ Automation Magic
├── requirements.txt      # 📋 Python Dependencies
└── README.md             # 📖 You’re Here!

```
---

## ⚡ Prerequisites

Before you blast off, ensure these tools are in your arsenal:

| Tool            | Version      | Download Link                              |
|-----------------|--------------|--------------------------------------------|
| **Terraform**   | >= 1.0.0     | [terraform.io/downloads](https://www.terraform.io/downloads.html) |
| **AWS CLI**     | >= 2.0.0     | [aws.amazon.com/cli](https://aws.amazon.com/cli/) |
| **kubectl**     | >= 1.20      | [kubernetes.io/docs/tasks/tools](https://kubernetes.io/docs/tasks/tools/) |
| **Docker**      | >= 20.10     | [docs.docker.com/get-docker](https://docs.docker.com/get-docker/) |
| **Make**        | Any          | [gnu.org/software/make](https://www.gnu.org/software/make/) |

- An **AWS Account** with credentials configured via `aws configure`.

---

## 🛠️ Setup Instructions

### 1. Clone the Repo
```bash
git clone <repository-url>
cd django-eks-terraform
```
---
### 2. Configure AWS Credentials
```bash
Power up your AWS CLI with the right permissions:
aws configure
```
---
### 3. Prep Your Django App
- Add your Django dependencies to requirements.txt (e.g., django, gunicorn).
- Tweak the Dockerfile to match your Django project.
Here’s a slick Dockerfile template:
```bash
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mydjangoapp.wsgi:application"]
```
---

### 4. Set Up Terraform Backend
We’re using an S3 bucket (django-eta-s3) and DynamoDB (terraform-locks) for state management in ap-southeast-1. Verify they’re ready:
- S3 Bucket: django-eta-s3
- DynamoDB Table: terraform-locks
If they don’t exist, summon them:
```bash
aws s3 mb s3://django-eta-s3 --region ap-southeast-1
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region ap-southeast-1
```
Backend config (environments/prod/backend.tf):
```bash
terraform {
  backend "s3" {
    bucket         = "django-eta-s3"
    key            = "prod/eks/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
  }
}
```
---
### 5. Plug in Your AWS Account ID
Edit the Makefile with your AWS Account ID:
```bash
ACCOUNT_ID ?= <your-aws-account-id>
```

---

## 🎮 Usage

### 🔥 With Makefile (The Cool Way)
The `Makefile` is your control panel. Here’s your command lineup:

| Command         | Description                           |
|-----------------|---------------------------------------|
| `make init`     | Initialize Terraform                  |
| `make apply`    | Deploy the EKS Cluster                |
| `make build`    | Build the Docker Image                |
| `make push`     | Push the Image to ECR                 |
| `make deploy`   | Deploy Django to EKS                  |
| `make all`      | Run the Full Workflow                 |
| `make destroy`  | Tear Everything Down                  |
| `make help`     | Show All Commands                     |

Launch everything in one go:
```bash
make all

```
---

### 6. Configuration
Terraform Variables
Tweak environments/prod/terraform.tfvars to customize your setup:
```bash
region             = "ap-southeast-1"
cluster_name       = "django-eks-prod"
environment        = "prod"
vpc_cidr           = "10.0.0.0/16"
azs                = ["ap-southeast-1a", "ap-southeast-1b"]
private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
cluster_version    = "1.29"
node_min_size      = 1
node_max_size      = 3
node_desired_size  = 2
node_instance_types = ["t3.medium"]
```
Kubernetes Manifests
Update django-deployment.yaml and django-service.yaml with your app details (e.g., image URL, ports).

---

### 7: Best Practices
- 🔒 Security: Use IAM Roles for Service Accounts (IRSA) for pod permissions.
- 📊 Monitoring: Hook up CloudWatch or Prometheus/Grafana for insights.
- 🤖 CI/CD: Automate with GitHub Actions or your favorite pipeline.
- 💾 Database: Pair with AWS RDS for a robust PostgreSQL backend.
- 💸 Cost Control: Destroy resources when idle (make destroy).

---
### 8: Troubleshooting
🐞 Troubleshooting
- Terraform Errors: Double-check backend.tf (bucket/region) and ensure terraform-locks exists.
- Deployment Hiccups: Verify the ECR image URL in django-deployment.yaml.
- Connectivity: Confirm kubectl is linked with aws eks update-kubeconfig.
---

### 9: Contributing
🤝 Contributing
Got ideas? Submit issues or pull requests to level up this project!

---
📜 License
Licensed under the MIT License. Build, deploy, and conquer!
