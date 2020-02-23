# terraform-module-sqs

Terraform Module for creating an SQS queue and an accompanying dead letter queue.

This module automatically adds:

- `.fifo` if a fifo queue is selected
- CloudWatch alarm for items on the dead letter queue
- CloudWatch alarm for large numbers of items on a queue
- A default policy to the queue
- Allows for easy adding of additional accounts to read/write to the queue
- By default enables encrypted queues using the default account key (overridable)
