output "id" {
  description = "The id of the provisioned VPC"
  # FIX: missing required value for the output id. It should output the provisioned VPC as mentioned in the description.
  value       = aws_vpc.application_vpc.id

}

output "public_subnets" {
  description = "A list of the public subnets under the provisioned VPC"
  value       = aws_subnet.public_subnets.*.id
}

output "private_subnets" {
  description = "A list of private subnets under the provisioned VPC"
  value       = aws_subnet.private_subnets.*.id
}
