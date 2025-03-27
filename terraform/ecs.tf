# ECS Cluster
resource "aws_ecs_cluster" "flask_nfl_cluster" {
  name = "flask-nfl-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "flask_nfl_task" {
  family                   = "flask-nfl-task"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # CPU and Memory at the task level
  cpu                       = "256"    # CPU for the task in units of 1024 (1 vCPU = 1024)
  memory                    = "512"    # Memory for the task in MiB (512 MB)
  
  container_definitions = jsonencode([{
    name      = "flask-nfl-container"
    image     = "<account_id>.dkr.ecr.us-east-1.amazonaws.com/flask-nfl-app:latest"  # Replace with your Docker image URL
    cpu       = 256                  # CPU for the container
    memory    = 512                  # Memory for the container
    portMappings = [
      {
        containerPort = 8080
        hostPort      = 8080
        protocol      = "tcp"
      }
    ]
  }])
}

# ECS Service
resource "aws_ecs_service" "flask_nfl_service" {
  name            = "flask-nfl-service"
  cluster         = aws_ecs_cluster.flask_nfl_cluster.id  # Reference to ECS Cluster
  task_definition = aws_ecs_task_definition.flask_nfl_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups = [aws_security_group.sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask_nfl_target_group.arn  # Reference to the target group
    container_name   = "flask-nfl-container"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.flask_nfl_listener  # Ensure the load balancer listener is created first
  ]
}
resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory

  container_definitions = jsonencode([
    {
      name  = "flask-container"
      image = var.container_image
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/flask-service"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "flask"
        }
      }
    }
  ])
}
