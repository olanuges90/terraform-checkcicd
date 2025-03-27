output "alb_dns_name" {
  value = aws_lb.flask_nfl_lb.dns_name
}

output "ecs_service_name" {
  value = aws_ecs_service.flask_nfl_service.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.flask_nfl_cluster.name
}
