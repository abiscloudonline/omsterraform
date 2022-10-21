terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
resource "aws_vpc" "ecs-vpc" {
  cidr_block = "${var.cidr}"

  tags = {
    Name = "ecs-vpc"
  }
}
# PUBLIC SUBNETS
resource "aws_subnet" "pub-subnets" {
  #count                   = length(var.azs)
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  availability_zone       = "us-east-1a"
  cidr_block              = "145.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnets"
  }
}

resource "aws_subnet" "pub-subnets1" {
  #count                   = length(var.azs)
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  availability_zone       = "us-east-1b"
  cidr_block              = "145.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnets1"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "i-gateway" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"

  tags = {
    Name = "ecs-igtw"
  }
}
variable "cidr" {
  type    = string
  default = "145.0.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "us-east-1a"
  ]
}

variable "subnets-ip" {
  type = list(string)
  default = [
    "145.0.1.0/24"
  ]

}
# TABLE FOR PUBLIC SUBNETS
resource "aws_route_table" "pub-table" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"
}

resource "aws_route" "pub-route" {
  route_table_id         = "${aws_route_table.pub-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.i-gateway.id}"
}

resource "aws_route_table_association" "as-pub" {
  #count          = length(var.azs)
  route_table_id = aws_route_table.pub-table.id
  subnet_id      = aws_subnet.pub-subnets.id
}

resource "aws_route_table_association" "as-pub1" {
  #count          = length(var.azs)
  route_table_id = aws_route_table.pub-table.id
  subnet_id      = aws_subnet.pub-subnets1.id
}

resource "aws_security_group" "sg2" {
  name        = "nginx-alb"
  description = "Port 80"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    description      = "Allow Port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg2.id]
  subnets            = ["${aws_subnet.pub-subnets.id}","${aws_subnet.pub-subnets1.id}"]

}
resource "aws_lb_target_group" "tg-group" {
  name        = "tg-group"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.ecs-vpc.id}"
  target_type = "ip"

}
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = "${aws_lb.app-lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
  }
}

locals{

    application_name ="tf-fargate-intro"
    launch_type     = "FARGATE"
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "tf-fargate-intro"
  #name =local.application-name

}
resource "aws_ecs_task_definition" "task" {
  family                   = "tf-fargate-intro"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${aws_iam_role.ecs_tasks_execution_role.arn}"

  container_definitions = jsonencode([
    {
      name   = "tf-fargate-intro"
      image  = "nginx:latest" #URI
      cpu    = 256
      memory = 512
      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "svc" {
  name            = "nginx"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.id}"
 # deployment_maximum_percent = 200
  # deployment_minimum_healthy_percent = 0
  desired_count   = 1
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = ["${aws_subnet.pub-subnets.id}"]
    #subnets          = ["subnet-022309e3f6ce48769"]
   security_groups  = ["${aws_security_group.sg2.id}"]
   #security_groups  = ["sg-04c8d1372d2bc8b8c"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
    container_name   = "tf-fargate-intro"
    container_port   = "80"
  }
}
#data "aws_iam_role" "ecs-task" {
  #name = "ecsTaskExecutionRole"
#}

output "alb" {
    value = aws_lb.app-lb.dns_name
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = "${aws_iam_role.ecs_tasks_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
