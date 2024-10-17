# Main Load Balancer
resource "aws_alb" "microservices_main" {
  name            = "${var.student_id}-lb"
  subnets         = var.public_subnet_ids
  security_groups = var.lb_sg_ids
}

# This tells the load balancer to listen on a specific port and forward traffic to a target group
resource "aws_alb_listener" "alb_main_listener" {
  load_balancer_arn = aws_alb.microservices_main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = "404"
    }
  }
}

# This is the target group that the load balancer will forward traffic to
resource "aws_alb_target_group" "nestjs_app" {
  name        = "${var.student_id}-nestjs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 3
    path                = "/nestjs/${var.health_check_path}"
    unhealthy_threshold = 2
  }
}

resource "aws_alb_target_group" "springboot_app" {
  name        = "${var.student_id}-springboot-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 3
    path                = "/springboot/${var.health_check_path}"
    unhealthy_threshold = 2
  }
}

# This is rules that specify the routing logic for the load balancer.
# This routes all traffic with the path "/nestjs/*" to the nestjs target group
# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
resource "aws_lb_listener_rule" "nestjs_forward" {
  listener_arn = aws_alb_listener.alb_main_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.nestjs_app.arn
  }

  condition {
    path_pattern {
      values = ["/nestjs/*"]
    }
  }

}

# This routes all traffic with the path "/springboot/*" to the springboot target group
resource "aws_lb_listener_rule" "springboot_forward" {
  listener_arn = aws_alb_listener.alb_main_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.springboot_app.arn
  }

  condition {
    path_pattern {
      values = ["/springboot/*"]
    }
  }

}
