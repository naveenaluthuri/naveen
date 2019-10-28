variable "ENV" {}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "PUBLIC_SUBNETS" {
  type = "list"
}

variable "VPC_ID" {}

variable "PATH_TO_PUBLIC_KEY" {
  default = "/home/nani/keys/id_rsa.pub"
}
