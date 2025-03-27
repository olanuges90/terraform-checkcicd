# Security Group for ALB
resource "aws_security_group" "sg" {
  name        = "flask-nfl-lb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow incoming HTTP traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outgoing traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Load Balancer
resource "aws_lb" "flask_nfl_lb" {
  name                        = "flask-nfl-lb"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.sg.id]  # Reference to the security group
  subnets                     = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]  # Reference to public subnets
  enable_deletion_protection  = false
}

# Target Group with IP target type
resource "aws_lb_target_group" "flask_nfl_target_group" {
  name         = "flask-nfl-target-group"
  port         = 8080
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id
  target_type  = "ip"  # Use "ip" target type for awsvpc network mode
}

# Listener
resource "aws_lb_listener" "flask_nfl_listener" {
  load_balancer_arn = aws_lb.flask_nfl_lb.arn
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_nfl_target_group.arn
  }
}




