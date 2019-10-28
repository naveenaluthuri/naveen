resource "aws_internet_gateway" "manager-gw" {
  vpc_id = "${aws_vpc.manager.id}"
  tags {
    Name      = "instance-${var.ENV}"
  }
}