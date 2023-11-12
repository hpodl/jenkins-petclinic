resource "aws_lb" "webserver_nlb_fe" {
  name               = "webserver-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = var.security_group_ids

  subnet_mapping {
    subnet_id     = var.subnet_id
    allocation_id = var.lb_eip_id
  }
}

resource "aws_lb_target_group" "webservers_tg" {
  vpc_id      = var.vpc_id
  name        = "webservers-target-group"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
}

resource "aws_lb_listener" "webserver_lb_listener" {
  load_balancer_arn = aws_lb.webserver_nlb_fe.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webservers_tg.arn
  }
}