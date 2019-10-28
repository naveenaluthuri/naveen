
resource "aws_subnet" "subnet-manager" {
  cidr_block = "${var.subcidr}"
  vpc_id = "${aws_vpc.manager.id}"
  availability_zone = "${var.azs}"
}


output "manager_aws_subnet" {
  value = "${aws_subnet.subnet-manager.id}"
}



resource "aws_route_table" "route-table-manager" {
  vpc_id = "${aws_vpc.manager.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.manager-gw.id}"
  }
  tags {
    Name         = "instance-${var.ENV}"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-manager.id}"
  route_table_id = "${aws_route_table.route-table-manager.id}"
}
