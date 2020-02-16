data "template_file" "user_data" {
  template = "${file("${path.module}/resources/user_data.sh.tpl")}"

  vars {
    cluster_name = "${var.cluster_name}"
  }
}

##############################3
resource "aws_launch_template" "worker_launch_template" {
  name_prefix             = "${var.cluster_name}-${var.worker_name}-lc-"
  disable_api_termination = false

  iam_instance_profile {
    arn = "${aws_iam_instance_profile.workers.arn}"
  }

  image_id      = "${data.aws_ami.eks_node_ami.id}"
  instance_type = "${var.asg_instance_type}"

  instance_initiated_shutdown_behavior = "terminate"

  key_name               = "${var.key_pair_name}"
  vpc_security_group_ids = ["${var.worker_security_gps}"]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = "${var.root_volume_size}"
    }
  }

  #user_data = "${base64encode(data.template_file.user_data_hw.rendered)}"
  user_data = "${base64encode(data.template_file.user_data.rendered)}"

  #user_data = "${data.template_file.user_data.rendered}"
}

resource "aws_autoscaling_group" "asg_gp" {
  name_prefix = "${var.cluster_name}-${var.worker_name}-asg-"

  max_size         = "${var.asg_max_size}"
  min_size         = "${var.asg_min_size}"
  desired_capacity = "${var.asg_desired_capacity}"

  #launch_configuration = "${aws_launch_configuration.worker_launch_config.name}"

  vpc_zone_identifier = ["${var.subnet_ids}"]

  #  launch_template = {
  #    id = "${aws_launch_template.worker_launch_template.id}"
  #    version            = "$$Latest"
  #  }

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_name = "${aws_launch_template.worker_launch_template.name}"
        version              = "$$Latest"
      }

      override {
        instance_type = "m5.large"
      }

      override {
        instance_type = "m5.xlarge"
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 2
    }
  }
  tags = ["${list(
    map("key", "Name", "value", "${var.cluster_name}-${var.worker_name}", "propagate_at_launch", true),
    map("key", "NodeGroup", "value", "${var.worker_name}", "propagate_at_launch", true),
    map("key", "Project", "value", "${var.project}", "propagate_at_launch", true),
    map("key", "Env", "value", "${var.env}", "propagate_at_launch", true),
    map("key", "kubernetes.io/cluster/${var.cluster_name}", "value", "owned", "propagate_at_launch", true)
  )}"]
}
