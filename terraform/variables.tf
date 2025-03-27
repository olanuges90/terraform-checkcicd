variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ecs_cpu" {
  description = "The number of CPU units for the ECS task"
  type        = string
  default     = "256"
}

variable "ecs_memory" {
  description = "The amount of memory for the ECS task"
  type        = string
  default     = "512"
}

variable "container_image" {
  description = "ECR container image URL"
  type        = string
}

variable "api_gateway_stage" {
  description = "The stage name for the API Gateway"
  type        = string
  default     = "prod"
}
