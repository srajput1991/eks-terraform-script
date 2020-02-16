output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "vpc_public_subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
}
