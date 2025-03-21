# Makefile for Django on EKS with Terraform
# Variables
REGION ?= ap-southeast-1
CLUSTER_NAME ?= django-eks-prod
ACCOUNT_ID ?= 108782052573  # แทนที่ด้วย AWS Account ID ของคุณ
ECR_REPO ?= $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/mydjangoapp
TAG ?= latest
ENV ?= prod

# Terraform directories
TF_DIR = environments/$(ENV)

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make init            - Initialize Terraform"
	@echo "  make plan            - Plan Terraform changes"
	@echo "  make apply           - Apply Terraform changes"
	@echo "  make destroy         - Destroy Terraform resources"
	@echo "  make build           - Build Docker image"
	@echo "  make push            - Push Docker image to ECR"
	@echo "  make deploy          - Deploy Django to EKS"
	@echo "  make kubeconfig      - Update kubeconfig for EKS"
	@echo "  make all             - Run init, apply, build, push, deploy"

# Terraform commands
.PHONY: init
init:
	cd $(TF_DIR) && terraform init

.PHONY: plan
plan:
	cd $(TF_DIR) && terraform plan

.PHONY: apply
apply:
	cd $(TF_DIR) && terraform apply -auto-approve

.PHONY: destroy
destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve

# Docker commands
.PHONY: build
build:
	docker build -t mydjangoapp:$(TAG) .

.PHONY: push
push:
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com
	docker tag mydjangoapp:$(TAG) $(ECR_REPO):$(TAG)
	docker push $(ECR_REPO):$(TAG)

# Kubernetes commands
.PHONY: kubeconfig
kubeconfig:
	aws eks --region $(REGION) update-kubeconfig --name $(CLUSTER_NAME)

.PHONY: deploy
deploy: kubeconfig
	kubectl apply -f django-deployment.yaml
	kubectl apply -f django-service.yaml

# Full workflow
.PHONY: all
all: init apply build push deploy
