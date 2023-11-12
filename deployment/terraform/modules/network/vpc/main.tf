resource "aws_vpc" "main_cloud" {
  cidr_block = "10.0.0.0/16"
}

### Subnets ###

resource "aws_subnet" "webserver_subnet" {
  vpc_id            = aws_vpc.main_cloud.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "db_backup_subnet" {
  vpc_id            = aws_vpc.main_cloud.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "petclinic_db_subnet" {
  name       = "petclinic_db_subnet"
  subnet_ids = [aws_subnet.webserver_subnet.id, aws_subnet.db_backup_subnet.id]
}


### Security groups ###

resource "aws_security_group" "sg_allow_all_egress" {
  name        = "allow_all_egress"
  description = "Allows all egress traffic"
  vpc_id      = aws_vpc.main_cloud.id

  egress {
    description = "any coming from instance"
    protocol    = "-1"

    to_port     = 0
    from_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_allow_http" {
  name        = "allow_http"
  description = "Allows ingress TCP traffic to port 80"
  vpc_id      = aws_vpc.main_cloud.id

  ingress {
    description = "http to instance"
    protocol    = "tcp"

    to_port     = 80
    from_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "http from instance"
    protocol    = "tcp"

    to_port     = 80
    from_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "sg_allow_ssh" {
  name        = "allow_ssh"
  description = "Allows TCP traffic to and from port 22"
  vpc_id      = aws_vpc.main_cloud.id

  ingress {
    description = "ssh to instance"
    protocol    = "tcp"

    to_port     = 22
    from_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ssh from instance"
    protocol    = "tcp"

    to_port     = 22
    from_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_database" {
  name        = "database_sg"
  description = "Allows all egress traffic and ingress mysql port traffic from within the subnets"
  vpc_id      = aws_vpc.main_cloud.id

  egress {
    description = "all egress tcp"
    protocol    = "tcp"
    to_port     = 0
    from_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "incoming tcp from subnets"
    protocol    = "tcp"
    to_port     = 3306
    from_port   = 3306
    cidr_blocks = [aws_subnet.webserver_subnet.cidr_block, aws_subnet.db_backup_subnet.cidr_block]
  }
}

resource "aws_security_group" "sg_all_within_subnet" {
  vpc_id = aws_vpc.main_cloud.id
  description = "Allows free ingress and egress traffic within the subnets"
  ingress {
    description = "to subnet"
    protocol    = -1
    to_port     = 0
    from_port   = 0
    cidr_blocks = [aws_subnet.webserver_subnet.cidr_block, aws_subnet.db_backup_subnet.cidr_block]

  }
  egress {
    description = "from subnet"
    protocol    = -1
    to_port     = 0
    from_port   = 0
    cidr_blocks = [aws_subnet.webserver_subnet.cidr_block, aws_subnet.db_backup_subnet.cidr_block]

  }
}

### Routing ###

resource "aws_internet_gateway" "gateway_main" {
  vpc_id = aws_vpc.main_cloud.id
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_cloud.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_main.id
  }
}

resource "aws_route_table_association" "main_rt_to_main_subnet" {
  route_table_id = aws_route_table.main_route_table.id
  subnet_id      = aws_subnet.webserver_subnet.id
}

resource "aws_eip" "lb_eip" {}