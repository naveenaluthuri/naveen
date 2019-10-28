
# Create an IAM role for the docker host.
resource "aws_iam_role" "jenkins_iam_role" {
  name = "master-${var.ENV}"
  assume_role_policy = "${var.role}"
}

# Attach policy to the role.
resource "aws_iam_role_policy" "jenkins_iam_role_policy" {
  name = "master-${var.ENV}"
  role = "${aws_iam_role.jenkins_iam_role.id}"
  policy = "${var.policy}"
}

# Create instance profile, associate the new role.
resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name  = "master-${var.ENV}"
  role = "${aws_iam_role.jenkins_iam_role.name}"
}

# Output the profile to be attached to the instance.
output "iam_instance_profile" {
  value = "${aws_iam_instance_profile.jenkins_instance_profile.id}"
}


