resource "aws_instance" "sd_ec2" {
    for_each = var.instances
    ami           = data.aws_ami.rhel_info.id
    instance_type = each.value
    vpc_security_group_ids = [var.allow_everything]
    #user_data = file("${path.module}//node_exporter/node_exporter.sh")

    tags = {
        Name = each.key
        Monitoring = "true"
    }
}
resource "aws_route53_record" "sd_r53" {
    for_each = aws_instance.sd_ec2
    zone_id = var.zone_id
    name    = "${each.key}.${var.domain_name}"
    type    = "A"
    ttl     = 1
    records = [aws_instance.sd_ec2.public_ip]
    allow_overwrite = true
}