output "vpc_id" {
  description = "ID of the Lustre lab VPC"
  value       = aws_vpc.lustre_lab.id
}

output "cluster_subnet_id" {
  description = "ID of the cluster subnet"
  value       = aws_subnet.cluster.id
}

output "cluster_security_group_id" {
  description = "ID of the cluster security group"
  value       = aws_security_group.cluster.id
}

output "mgs_instance_id" {
  value = aws_instance.mgs.id
}

output "oss1_instance_id" {
  value = aws_instance.oss1.id
}

output "client1_instance_id" {
  value = aws_instance.client1.id
}
