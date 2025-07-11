# #Create Sec Group
# resource "aws_security_group" "allow_https" {

#   name        = "allow_https"
#   description = "allow_https and http"
#   vpc_id      = "vpc-06c83f64a6095b1fc"

#   ingress {
#     description = "Allow http"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow https"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow ssh"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "allow_https"
#   }
# }


# # AWS Instance


# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "web-host" {
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t2.medium"
#   availability_zone      = var.availability_zone
#   vpc_security_group_ids = [aws_security_group.allow_https.id]
#   subnet_id              = "subnet-0f392b8fe081af12e"
#   iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo apt update -y
#               sudo add-apt-repository ppa:ondrej/apache2 -y
#               sudo apt update -y
#               sudo apt install apache2 -y
#               sudo ufw enable
#               sudo ufw allow 80/tcp # Allow HTTP traffic
#               sudo ufw allow 443/tcp # Allow HTTPS traffic
#               sudo ufw allow 22/tcp # Allow SSH traffic
#               sudo ufw reload 
#               sudo echo "<html><body><h1>Gidday Mate; Wassup ?</h1></body></html>" > /var/www/html/index.html
#               sudo systemctl start apache2
#               sudo systemctl enable apache2
#               EOF


#   tags = {
#     Name                             = "web-server"
#     env                              = "dev"
#     costgroup                        = "sre"
#     owner                            = "sre"
#     cloud-custodian-managed-shutdown = "true"
#     cloud-custodian-managed-schedule = "true"
#     "Patch Group"                    = "SRE"

#   }
# }

# resource "aws_eip" "lb" {
#   instance = aws_instance.web-host.id
#   vpc      = true
#   tags = {
#     Name = "web-server"
#   }
# }

# resource "aws_iam_role" "ssm-role" {
#   name               = "ssm_web_role"
#   path               = "/"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# resource "aws_iam_instance_profile" "ssm_profile" {
#   name = "web_ssm_profile-002"
#   role = aws_iam_role.ssm-role.name
# }

# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role_policy_attachment" "aws-managed" {
#   for_each = toset([
#     "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
#     "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
#   ])

#   role       = aws_iam_role.ssm-role.name
#   policy_arn = each.value
# }

# output "aws_eip" {
#   description = "elastic ip address"
#   value       = aws_eip.lb.public_ip
# }