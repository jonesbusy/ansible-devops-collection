# DNS records
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.route53_zone_delaye_ch.zone_id
  name    = var.record
  type    = "A"
  ttl     = "30"
  records = [
    module.ec2_instance.public_ip
  ]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "= 3.3.0"
  name = var.name
  ami                    = var.ami
  associate_public_ip_address = true
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [data.aws_security_group.security_group.id]
  subnet_id              = data.aws_subnet.subnet.id
  tags = {}
}