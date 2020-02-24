resource "aws_sqs_queue" "queue" {
  name                              = "${var.name}${var.fifo_queue == true ? ".fifo" : ""}"
  message_retention_seconds         = var.message_retention_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  max_message_size                  = var.max_message_size
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter_queue.arn,
    maxReceiveCount     = 3
  })
  tags = var.tags
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id
  policy    = data.aws_iam_policy_document.queue.json
}

data "aws_iam_policy_document" "queue" {
  statement {
    effect    = "Allow"
    resources = [aws_sqs_queue.queue.arn]
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListQueueTags",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
    ]
    principals {
      type        = "AWS"
      identifiers = var.allowed_arns == null ? [local.account_id] : var.allowed_arns
    }
  }
}

resource "aws_sqs_queue" "deadletter_queue" {
  name                              = "${var.name}-dead-letter-queue${var.fifo_queue == true ? ".fifo" : ""}"
  message_retention_seconds         = var.message_retention_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  max_message_size                  = var.max_message_size
  tags                              = var.tags
}

resource "aws_sqs_queue_policy" "deadletter_queue" {
  queue_url = aws_sqs_queue.deadletter_queue.id
  policy    = data.aws_iam_policy_document.deadletter_queue.json
}

data "aws_iam_policy_document" "deadletter_queue" {
  statement {
    effect    = "Allow"
    resources = [aws_sqs_queue.deadletter_queue.arn]
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListQueueTags",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
    ]
    principals {
      type        = "AWS"
      identifiers = var.allowed_arns == null ? [local.account_id] : var.allowed_arns
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name          = "${aws_sqs_queue.queue.name}-flood-alarm"
  alarm_description   = "The ${aws_sqs_queue.queue.name} main queue has a large number of queued items"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Average"
  threshold           = var.allowed_items_max
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  tags                = tomap(var.tags)
  dimensions = {
    "QueueName" = aws_sqs_queue.queue.name
  }
}

resource "aws_cloudwatch_metric_alarm" "deadletter_alarm" {
  alarm_name          = "${aws_sqs_queue.deadletter_queue.name}-not-empty-alarm"
  alarm_description   = "Items are on the ${aws_sqs_queue.deadletter_queue.name} queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  tags                = tomap(var.tags)
  dimensions = {
    "QueueName" = aws_sqs_queue.deadletter_queue.name
  }
}

resource "aws_sns_topic" "alarm" {
  name = "${var.name}-alarm-topic"
}
