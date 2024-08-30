output "database" {
  value = aws_db_instance.postgres.endpoint
}

output "username" {
  value = aws_db_instance.postgres.username
}

output "password" {
  value = aws_db_instance.postgres.password
}

output "connection_string" {
  value = "host=${aws_db_instance.postgres.endpoint};username=${aws_db_instance.postgres.username};password=${aws_db_instance.postgres.password}"
}