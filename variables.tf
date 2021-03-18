variable "region" {
  default     = "us-east-1"
}
variable "aws_autoscaling_group" {
  type = map 
  default = {
    min_size           = 2
    max_size           = 2
    min_elb_capacity   = 1
  }
}
variable "version_container" {
  default     = "latest"
}

variable "database" {
  type      = map
  default   = {
      name       = 
      username   = 
      password   = 
      port       = 3306 
  }
}

variable "s3_bucket" {
  type        = map
  default     = {
      bucket     = "docker-devops-images"
      acl        = "private"
  }
}

variable "DjangoApp" {
  type        = map
  default     = {
      secret_key            = 
      aws_access_key_id     = 
      aws_secret_access_key = 
      region                = 
      output                = 
      user_django           = 
      email_django          = 
      pass_django           = 

  }
}

