resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier = "${var.prefix}-example"
  engine             = "aurora-mysql"
  engine_mode        = "provisioned" # only v1 is serverless, serverless_v2 must be `provisioned`, v2 is not true serverless 
  engine_version     = "3.05.2"      # compatible with mysql8.0
  database_name      = "demodb"
  master_username    = "root"
  master_password    = "password"
  storage_encrypted  = false # set this to false for aurora serverless, default true

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
}
