variable "cluster_name" {
  default = "wp-cluster"
}

variable "region" {
  default = "us-east-1"
}
variable "container_name" {
  default = "wp-container"
}
variable "container_cpu" {
  default = 128
}

variable "container_memory" {
  default = 128
}
variable "desire_count" {
  default = 2
}

variable "container_image" {
  default = "wordpress:apache"
}

variable "container_port" {
  default = 80
}


variable "mount_points" {
  default = ""
}

variable "stream_prefix" {
  default = "wp"
}


variable "database" {
  default = {
    "username" = "admin",
    "password" = "password"
  }
}
