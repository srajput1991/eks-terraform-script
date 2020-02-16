data "aws_ami" "eks_node_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.12-v20190614"]
  }
}
