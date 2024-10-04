variable "prefix" {
  description = "Prefix of DB"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID of microservice"
  type        = string
}

variable "db_subnet_group_name" {
  description = "name of the micro public db subnet group"
  type        = string
}

variable "mysql_root_password" {
  description = "Password for the root user of the MySQL database"
  type        = string
}
