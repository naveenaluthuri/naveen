
variable "ENV" {
  default = "jenkins"
}
variable "key_pair" {
  default = {
    key_name = "jenkins1"
    public_key_file_path = "/home/nani/keys/id_rsa.pub"
    private_key_file_path = "/home/nani/keys/id_rsa"
  }
}



# Make sure this file has it's permissions set to 600 for all copies.
# Overrides details here: https://www.terraform.io/docs/configuration/override.html
# Without any of the following, Terraform will prompt for them.

variable "aws_region" {
  description = "AWS region to launch server(s)."
  # Availability zone.
  default     = "ap-south-1"
}

variable "aws_availability_zones" {
    default = {
        ap-south-1 = "ap-south-1a"
        ap-south-1 = "ap-south-1b"
        # ap-south-1 = "ap-south-1c"
    }
}




variable "security_group_rules" {
  default = {
    # SSH
    rule_0_type = "ingress"
    rule_0_from_port = 22
    rule_0_to_port = 22
    rule_0_protocol = "tcp"
    rule_0_cidr_block_0 = "0.0.0.0/0"
    # HTTP
    rule_1_type = "ingress"
    rule_1_from_port = 80
    rule_1_to_port = 80
    rule_1_protocol = "tcp"
    rule_1_cidr_block_0 = "0.0.0.0/0"
    # HTTP
    rule_3_type = "ingress"
    rule_3_from_port = 8080
    rule_3_to_port = 8080
    rule_3_protocol = "tcp"
    rule_3_cidr_block_0 = "0.0.0.0/0"
    
    # jenk
    rule_4_type = "ingress"
    rule_4_from_port = 50000
    rule_4_to_port = 50000
    rule_4_protocol = "tcp"
    rule_4_cidr_block_0 = "0.0.0.0/0"
    
    # Could lock this down further.
    rule_2_type = "egress"
    rule_2_from_port = 0
    rule_2_to_port = 0
    rule_2_protocol = "-1"
    rule_2_cidr_block_0 = "0.0.0.0/0"
  }
}


variable "private_key_file_path" {
  default = "/home/nani/keys/id_rsa"
}

variable "public_key_file_path" {
  default =  "/home/nani/keys/id_rsa.pub"
}


variable "aws_instance_type" {
  default = "t2.micro"
}

