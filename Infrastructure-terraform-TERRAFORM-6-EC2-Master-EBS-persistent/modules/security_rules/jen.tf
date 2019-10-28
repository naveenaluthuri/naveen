resource "aws_security_group_rule" "jenk" {
  type        = "${lookup(var.security_group_rules, "rule_4_type")}"
  from_port   = "${lookup(var.security_group_rules, "rule_4_from_port")}"
  to_port     = "${lookup(var.security_group_rules, "rule_4_to_port")}"
  protocol    = "${lookup(var.security_group_rules, "rule_4_protocol")}"
  cidr_blocks = ["${var.ip_value}"]
  security_group_id = "${var.security_group_id}"
}
