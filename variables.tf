variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "django-eks"
}

variable "environment" {
  description = "Environment (e.g., prod, dev)"
  type        = string
}
