
variable "zone_id"{}
variable "hostname"{}
variable "ip_address"{}
resource "aws_route53_record" "www" {
   zone_id = "${var.zone_id}"
   name = "${var.hostname}"
   type = "A"
   ttl = "300"
   records = ["${var.ip_address}"]
}
