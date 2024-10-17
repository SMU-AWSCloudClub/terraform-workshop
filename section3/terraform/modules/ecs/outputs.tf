output "alb_hostname" {
  value = "${aws_alb.microservices_main.dns_name}:3000"
}
