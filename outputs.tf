output "queue" {
  value = aws_sqs_queue.queue
}

output "deadletter_queue" {
  value = aws_sqs_queue.deadletter_queue
}
