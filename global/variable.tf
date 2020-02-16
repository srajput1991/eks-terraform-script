variable "bucket-name" {
  default = "helm-eks-tf-remote"
}

variable "dynamo-db" {
  default = "terraform-state-lock-dynamo"
}
