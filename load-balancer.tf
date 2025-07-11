# # # Create a security group for the NLB
# # resource "aws_security_group" "nlb_security_group" {
# #   name        = "nlb-security-group"
# #   description = "Security group for nlb"
# #   vpc_id      = "vpc-06c83f64a6095b1fc"
# #   ingress {
# #     from_port   = 80
# #     to_port     = 80
# #     protocol    = "tcp"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }
# # }

# # Create a target group
# resource "aws_lb_target_group" "target_group" {
#   name     = "http-target-group1"
#   vpc_id   = "vpc-06c83f64a6095b1fc"
#   port     = 80
#   protocol = "TCP"

#   health_check {
#     protocol            = "HTTP"
#     interval            = 15
#     timeout             = 14
#     healthy_threshold   = 2
#     unhealthy_threshold = 2

#   }

#   depends_on = [
#     aws_instance.web-host
#   ]
# }

# # Register the EC2 instance with the target group
# resource "aws_lb_target_group_attachment" "target_group_attachment" {
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id        = aws_instance.web-host.id
#   depends_on = [
#     aws_lb_target_group.target_group
#   ]
# }

# # Create a network load balancer
# resource "aws_lb" "network_load_balancer" {
#   name               = "http-network-load-balancer"
#   subnets            = ["subnet-0f392b8fe081af12e"]
#   security_groups    = [aws_security_group.allow_https.id]
#   internal           = false
#   load_balancer_type = "network"

#   depends_on = [
#     aws_lb_target_group_attachment.target_group_attachment
#   ]

# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.network_load_balancer.arn
#   port              = "80"
#   protocol          = "TCP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }
#   depends_on = [
#     aws_lb_target_group_attachment.target_group_attachment
#   ]
# }
# output "load_balancer_dns" {
#   description = "load_balancer_dns"
#   value       = aws_lb.network_load_balancer.dns_name
# }