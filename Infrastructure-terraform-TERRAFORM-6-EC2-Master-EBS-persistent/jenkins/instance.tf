resource "aws_security_group" "access-jenkins" {
 name = "access-jenkins"
 description = "allow ssh access"
 vpc_id = "${module.vpc.vpc-id}"
 tags {
    Name         = "allow-ssh"
    Environmnent = "${var.ENV}"
  }
}

# #EBS volume for ec2 instance
# resource "aws_ebs_volume" "jenkins" {
#   availability_zone = "${lookup(var.aws_availability_zones, var.aws_region)}"
#   size              = 20

#   tags = {
#     Name = "jenkins-master"
#   }
# }

# #attech volume to jenkins master to use jenkins
# resource "aws_volume_attachment" "ebs_att" {
#   device_name = "/dev/xvda"
#   volume_id   = "${aws_ebs_volume.jenkins.id}"
#   instance_id = "${aws_instance.jenkins.id}"
#   skip_destroy  = true
# }

#eip creation and attach to ec2 instance
resource "aws_eip" "lb" {
  instance = "${aws_instance.jenkins.id}"
  vpc      = true
}


# Todo: For multiple containers, will need to interate on:
resource "aws_instance" "jenkins" {
  ami           = "ami-54d2a63b"
  instance_type = "${var.aws_instance_type}"
  iam_instance_profile = "${module.iam.iam_instance_profile}" 
  subnet_id = "${module.vpc.manager_aws_subnet}"
  # instance_tenancy = "default"
  associate_public_ip_address = true
  disable_api_termination = true
  volume_tags {
    Name         = "${var.ENV}-Master"
    Environmnent = "${var.ENV}"
  }

  tags {
    Name         = "${var.ENV}-Master"
    Environmnent = "${var.ENV}"
  }
  vpc_security_group_ids = ["${aws_security_group.access-jenkins.id}"]
  # security_groups = ["${aws_security_group.access-jenkins.id}"]
  # security_groups = [ "access-jenkins" ]
  
  root_block_device {
    volume_size = 20
    delete_on_termination = false
  }

  # Copy publick key to instance.
  key_name = "${aws_key_pair.jenkins1.key_name}"
  
  connection {
    type = "ssh"
    user = "ubuntu"
    port = 22
    host = "${aws_instance.jenkins.public_ip}"
    private_key = "${file("${var.key_pair["private_key_file_path"]}")}"    
    timeout = "3m"
    agent = false
  }
  # provisioner "file" {
  #       source = "docker/"
  #       destination = "~/"
  #   }

    provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install openjdk-8-jdk -y",
      "wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt update -y",
      "sudo apt install jenkins -y",
      "sudo ufw allow 8080",
    ]
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum update -y",
  #     "sudo amazon-linux-extras install docker -y",
  #     "sudo service docker start",
  #     "sudo usermod -a -G docker ec2-user",
  #     "sudo usermod -a -G docker $USER",
  #     "sudo yum update -y",
  #   ]
  # }
  # # provisioner "remote-exec" {
  # #   inline = [
  # #     "chmod +x /tmp/init.sh",
  # #     "/tmp/init.sh",
  # #   ]
  # # }
  # provisioner "remote-exec" {
  #   inline = [
  #     "docker info",
  #     "docker pull jenkins/jenkins",
  #     "mkdir $PWD/jenkins_home",
  #     "chown 1000 $PWD/jenkins_home",
  #     "sudo chown 1000 /var/run/docker.sock",
  #     # "docker run -d -p 8080:8080 -p 50000:50000 -v $PWD/jenkins_home:/var/jenkins_home:z --privileged -t jenkins/jenkins",
  #     "docker run -d -p 8080:8080 -p 50000:50000 -v $PWD/jenkins_home:/var/jenkins_home:z -v $(which docker):/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/apache-maven-3.6.1:/var/lib/apachemaven-3.6.1 -v /usr/lib/jvm/jre-1.8.0:/usr/lib/jvm/jre-1.8.0 -v /usr/lib64/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7 -v /var/lib/docker/tmp:/var/lib/docker/tmp -t jenkins/jenkins",
  #     "sudo mv $PWD/jenkins_home /var/",
  #     "sudo chown 1000 /var/jenkins_home",
  #   ]
  # }
  # provisioner "remote-exec" {
  #   inline = [
  #    "sudo usermod -aG docker $USER",
  #    "sudo usermod -aG root $USER",
  #    "sudo chmod 664 /var/run/docker.sock",
  #   ]
  # }
#  provisioner "remote-exec" {
#     inline = [
#      "sudo cat /var/jenkins_home/secrets/initialAdminPassword",
#     ]
#   }
}


# resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
#   scheduled_action_name = "scale-out-during-business-hours"
#   min_size              = 1
#   max_size              = 1
#   desired_capacity      = 2
#   recurrence            = "0 9 * * *"
# }

# resource "aws_autoscaling_schedule" "scale_in_at_night" {
#   scheduled_action_name = "scale-in-at-night"
#   min_size              = 0
#   max_size              = 0
#   desired_capacity      = 1
#   recurrence            = "0 17 * * *"
# }

# Output the security group Id to be used to add rules.
output "jenkins_security_group" {
  value = "${aws_security_group.access-jenkins.id}"
}

output "jenkins_aws_instance" {
  value = "${aws_instance.jenkins.public_ip}"
}
