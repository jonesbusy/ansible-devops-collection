output "public_ip" {
    value = module.ec2_instance.public_ip
}

output "private_ip" {
    value = module.ec2_instance.private_ip
}

output "instance_id" {
    value = module.ec2_instance.id
}