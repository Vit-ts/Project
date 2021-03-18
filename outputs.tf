output "DjangoApp_loadbalancer_url" {
  value = aws_elb.DjangoApp.dns_name
}

output "Database_ENDPOINT" {
  value = aws_db_instance.database.address
}
