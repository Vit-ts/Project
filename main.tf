provider "aws" {
  region     = var.region 
} 
############################################################
data "aws_availability_zones" "available" {}
###########################################################
data "aws_db_instance" "name_database" {
  db_instance_identifier = aws_db_instance.database.identifier
}
##########################################################
resource "aws_security_group" "DjangoApp" {
  name = "DjangoApp Security Group"

  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic SecurityGroup"
  }
}
#########################################################
resource "aws_launch_configuration" "DjangoApp" {
  name            = "DjangoApp-LC"
  image_id        = "ami-038f1ca1bd58a5790"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.DjangoApp.id]
  user_data       = templatefile("user_data.sh", {
    endpoint              = aws_db_instance.database.address
    backet_name           = aws_s3_bucket.ImagesBacket.id
    database_pass         = aws_db_instance.database.password
    database_user         = aws_db_instance.database.username
    database_name         = aws_db_instance.database.name
    secret_key            = var.DjangoApp.secret_key
    aws_access_key_id     = var.DjangoApp.aws_access_key_id
    aws_secret_access_key = var.DjangoApp.aws_secret_access_key
    region                = var.DjangoApp.region
    output                = var.DjangoApp.output
    user_django           = var.DjangoApp.user_django
    email_django          = var.DjangoApp.email_django
    pass_django           = var.DjangoApp.pass_django
    version               = var.version_container
  })

  key_name  = "jenkins"

  lifecycle {
    create_before_destroy = true
  }
}
###############################################################
resource "aws_elb" "DjangoApp" {
  name                = "DjangoApp-ELB"
  availability_zones  = [data.aws_availability_zones.available.names[0]]

  security_groups     = [aws_security_group.DjangoApp.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 8
    timeout             = 2
    target              = "HTTP:80/"
    interval            = 5
  }
  tags = {
    Name = "DjangoApp-ELB"
  }

}
####################################################################
resource "aws_default_subnet" "default_subnet" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
####################################################################
resource "aws_autoscaling_group" "DjangoApp" {
  name                 = "AUTOSCALING_GROUP-Django"
  launch_configuration = aws_launch_configuration.DjangoApp.name
  min_size             = var.aws_autoscaling_group.min_size
  max_size             = var.aws_autoscaling_group.max_size
  min_elb_capacity     = var.aws_autoscaling_group.min_elb_capacity
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_subnet.id]
  load_balancers       = [aws_elb.DjangoApp.name]

  dynamic "tag" {
    for_each = {
      Name   = "DjangoApp in ASG"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}
###################################################################
resource "aws_s3_bucket" "ImagesBacket" {
  bucket = var.s3_bucket.bucket
  acl    = var.s3_bucket.acl
}
##################################################################
resource "aws_security_group" "database" {
  name = "Database Security Group"

  ingress {
    from_port   = var.database.port
    to_port     = var.database.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "MySQL SecurityGroup"
  }
}


resource "aws_db_instance" "database" {

 identifier = "dbmysql"

  engine                = "mysql"
  engine_version        = "5.7.31"
  instance_class        = "db.t2.micro"
  allocated_storage     = 5
  max_allocated_storage = 30
  
  name     = var.database.name
  username = var.database.username
  password = var.database.password
  port     = var.database.port

  vpc_security_group_ids = [aws_security_group.database.id]

}

