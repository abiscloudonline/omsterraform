resource "aws_subnet" "pub-subnets" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "ap-south-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnets"
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "ap-south-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnets"
  }
}

resource "aws_internet_gateway" "i-gateway" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "igtw"
  }
}
