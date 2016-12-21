variable "key_name" {}
variable "zone_id" {}
variable "consul_fqdn" {}

# TODO this should be multiple and we should be using a map to spread out the
# masters
variable "subnet_ids" {
  type = "list"
}

variable "tags" {
  type = "map"
  default = {}
}

//TODO make this be single entry
variable "security_group_ids" { 
  /*type = "list"*/
}

variable "consul_install_dir" {
    default="/var/consul"
}

variable "alarm_actions" {
  type = "list"
}

/**
 * Note that as of now, we can't actually override
 * this value in the module, so if you want to change the
 * number you must modify it in this file
 */
variable "min_size" {
  default ="3"
}



variable "max_size" {
  default ="5"
}

variable "instance_type" {
	default = "t2.micro"
}

variable "consul_local_config" {
  default = "{\"skip_leave_on_interrupt\": true}" 
}

data "template_file" "start_consul_sh" {
  template = "${file("${path.module}/consul_server.sh.tpl")}"
  vars {
    num_servers = "${var.min_size}"
    consul_local_config = "${var.consul_local_config}"
    region = "${data.aws_region.current.name}"
  }
}

data "aws_region" "current" {
  current = true
}


data "aws_ami" "amazon" {
  most_recent = true
   filter {
    name = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
}






# Autoscaling launch configuration
resource "aws_launch_configuration" "cluster_launch_conf" {

    name = "consul-launch"
    image_id = "${data.aws_ami.amazon.image_id}"
    # No public ip when instances are placed in private subnets. See notes
    # about creating an ELB to proxy public traffic into the cluster.
    associate_public_ip_address = false

    iam_instance_profile = "${aws_iam_instance_profile.consul_profile.name}"

    # Security groups
    security_groups = ["${split(",",var.security_group_ids)}"]

    key_name = "${var.key_name}"

    # Add rendered userdata template
    user_data = "${data.template_file.start_consul_sh.rendered}"

    # Misc
    instance_type = "${var.instance_type}"
    enable_monitoring = true
}


# Create a new load balancer
resource "aws_alb" "consul" {
  name            = "consul-alb"
  internal        = true
  security_groups = ["${split(",",var.security_group_ids)}"]
  subnets         = ["${var.subnet_ids}"]

  enable_deletion_protection = false
  tags = "${merge(map("Name","consul"),var.tags)}"

}

resource "aws_route53_record" "consul" {
  zone_id = "${var.zone_id}"
  name = "${var.consul_fqdn}"
  type = "A"
  alias {
    name = "${aws_alb.consul.dns_name}"
    zone_id = "${aws_alb.consul.zone_id}"
    evaluate_target_health= true
  }
}

//Pick up the vpc id from the first subnet id
data "aws_subnet" "selected" {
  id = "${element(var.subnet_ids,0)}"
}
data "aws_vpc" "vpc" {
    id = "${data.aws_subnet.selected.vpc_id}"
}


resource "aws_alb_target_group" "consul_server_http" {
  name     = "tf-example-alb-tg"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = "${data.aws_subnet.selected.vpc_id}"
  health_check {
    path = "/v1/health/state/critical"
  }
}


resource "aws_alb_listener" "front_end" {
   load_balancer_arn = "${aws_alb.consul.arn}"
   port = "8500"
   protocol = "HTTP"
   default_action {
     target_group_arn = "${aws_alb_target_group.consul_server_http.arn}"
     type = "forward"
   }
}



# Autoscaling group
resource "aws_autoscaling_group" "consul_asg" {

    name = "consul-AS"
    launch_configuration = "${aws_launch_configuration.cluster_launch_conf.name}"
    min_size = "${var.min_size}"
    max_size = "${var.max_size}"
    health_check_grace_period = 180
    //health_check_type = "ELB"
    health_check_type = "EC2"

    force_delete = false
    termination_policies = ["OldestInstance"]

    target_group_arns = ["${aws_alb_target_group.consul_server_http.arn}"]

    // wait_for_elb_capacity="true"

    # Add ELB's here if you're proxying public traffic into the cluster
    # load_balancers = ["${var.instance_cluster_load_balancers}"]

    # Target subnets
    vpc_zone_identifier = ["${var.subnet_ids}"]

    // tags = "${merge(map("Name","ConsulASG"),var.tags)}"
    tag {
      key = "Name"
      value = "consul"
      propagate_at_launch = true

    }
    enabled_metrics = ["GroupInServiceInstances", "GroupTotalInstances"]

}


resource "aws_autoscaling_policy" "bat" {
    name = "consul-policy"
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.consul_asg.name}"
}




resource "aws_cloudwatch_metric_alarm" "consul_members" {
    alarm_name = "consul-group"
    comparison_operator = "LessThanThreshold"
    evaluation_periods = "2"
    metric_name = "GroupInServiceInstances"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Minimum"
    threshold = "${var.min_size}"
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.consul_asg.name}"
    }
    alarm_description = "This measures the number of consul servers active"
    // alarm_actions = ["${aws_autoscaling_policy.bat.arn}"]
}



resource "aws_security_group_rule" "consul_http_ingress" {

    security_group_id = "${var.security_group_ids}"
    type = "ingress"
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["${data.aws_vpc.vpc.cidr_block}"]

}

output "consul_fqdn" {
  value = "${var.consul_fqdn}"
}