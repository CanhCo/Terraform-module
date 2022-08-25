resource "aws_db_instance" "database" {
  allocated_storage      = 20 #bắt buộc (GB)
  engine                 = "postgres"
  engine_version         = "12.7"
  instance_class         = "db.t2.micro"
  identifier             = "${var.project}-db-instance" 
  name                   = "terraform" #tên của CSDL cần tạo khi CSDL đc tạo, nếu không chỉ định, sẽ k có CSDL được tạo trong phiên bản CSDL
  username               = "chipt"
  password               = "phamthaochi"
  db_subnet_group_name   = var.vpc.database_subnet_group
  vpc_security_group_ids = [var.sg.db]
  skip_final_snapshot    = true #không tạo DBSnapshot
}