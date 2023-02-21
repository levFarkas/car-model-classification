resource "aws_launch_template" "cmc_launch_template" {
  name_prefix = "cmc"
  image_id    = "ami-0b64c3b927c62fcbd"

  instance_requirements {
    memory_mib {
      min = 8192
    }
    vcpu_count {
      min = 2
    }
    instance_generations = ["current"]
  }
}


resource "aws_autoscaling_policy" "bat" {
  name                   = "foobar3-terraform-test"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.bar.name
}

resource "aws_autoscaling_group" "cmc_on_demand_asg" {
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  desired_capacity   = 0
  max_size           = 1
  min_size           = 0
  capacity_rebalance = true

  mixed_instances_policy {
    instances_distribution {
      spot_allocation_strategy = "capacity-optimized"
    }

    launch_template {
      id      = aws_launch_template.cmc_launch_template.id
      version = "$Latest"
    }
  }
}

resource "aws_sqs_queue" "cmc_source_sqs" {
  name = "cmc-source-queue"
    policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "sqspolicy",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "sqs:SendMessage",
        "Resource": "arn:aws:sqs:*:*:cmc-source-queue",
        "Condition": {
          "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.cmc_train_data_bucket.arn}" }
        }
      }
    ]
  }
  POLICY
}

resource "aws_s3_bucket" "cmc_train_data_bucket" {
  bucket = "car-model-classification-images"
}

resource "aws_s3_bucket_notification" "cmc_train_data_bucket_notification" {
  bucket = aws_s3_bucket.cmc_train_data_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.cmc_source_sqs.arn
    events        = ["s3:ObjectCreated:*"]
  }
}

