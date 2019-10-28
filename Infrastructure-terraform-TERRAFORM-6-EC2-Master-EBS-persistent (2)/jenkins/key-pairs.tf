resource "aws_key_pair" "jenkins1" {  
  key_name = "${var.key_pair["key_name"]}"
  public_key = "${file("${var.key_pair["public_key_file_path"]}")}"  
}