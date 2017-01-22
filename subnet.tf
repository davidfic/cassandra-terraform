/*// Public Subnets
resource "aws_subnet" "az1-pub-sn" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.az1_pub_subnet_cidr}"
  availability_zone = "${join(",", data.aws_availability_zones.available.names)}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.environment}-pub-${var.az1}"
    Env = "${var.environment}"
  }
}*/
