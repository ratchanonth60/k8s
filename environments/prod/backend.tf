terraform {
  backend "s3" {
    bucket         = "django-eta-s3"
    key            = "prod/eks/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
  }
}
