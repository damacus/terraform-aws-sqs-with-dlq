resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name          = "${aws_sqs_queue.deadletter_queue.name}-flood-alarm"
  alarm_description   = "The ${aws_sqs_queue.deadletter_queue.name} main queue has a large number of queued items"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Average"
  threshold           = var.allowed_items_max
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.alarm_sns_topic_arn]
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
  alarm_actions       = [var.alarm_sns_topic_arn]
  tags                = tomap(var.tags)
  dimensions = {
    "QueueName" = aws_sqs_queue.deadletter_queue.name
  }
}
