resource "aws_security_group_rule" "https" {
  type        = "${lookup(var.security_group_rules, "rule_3_type")}"
  from_port   = "${lookup(var.security_group_rules, "rule_3_from_port")}"
  to_port     = "${lookup(var.security_group_rules, "rule_3_to_port")}"
  protocol    = "${lookup(var.security_group_rules, "rule_3_protocol")}"
  cidr_blocks = ["${var.ip_value}"]
  security_group_id = "${var.security_group_id}"
}
