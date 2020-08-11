# terraform-module-sqs

Terraform Module for creating an SQS queue and an accompanying dead letter queue.

This module automatically adds:

- `.fifo` if a fifo queue is selected
- CloudWatch alarm for items on the dead letter queue
- CloudWatch alarm for large numbers of items on a queue
- A default policy to the queue
- Allows for easy adding of additional accounts to read/write to the queue
- By default enables encrypted queues using the default account key (overridable)

## Providers

| Name | Version |
| ---- | ------- |
| aws  | n/a     |

## Inputs

| Name                                | Description                                                                                                                                                                                                                         | Type          | Default           | Required |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ----------------- | :------: |
| `name`                              | This is the human-readable name of the queue. If omitted, Terraform will assign a random name.                                                                                                                                      | `string`      | n/a               |   yes    |
| `visibility_timeout_seconds`        | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)                                                                                                                                                         | `number`      | n/a               |   yes    |
| `alarm_sns_topic_arn`               | ARN of the SNS topic for alarm notifactions                                                                                                                                                                                         | `any`         | n/a               |   yes    |
| `allowed_arns`                      | A list of AWS account IDs allowed to access this resource                                                                                                                                                                           | `list`        | n/a               |   yes    |
| `message_retention_seconds`         | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)                                                                                                           | `number`      | null              |    no    |
| `content_based_deduplication`       | Enables content-based deduplication for FIFO queues                                                                                                                                                                                 | `bool`        | true              |    no    |
| `fifo_queue`                        | Boolean designating a FIFO queue                                                                                                                                                                                                    | `bool`        | false             |    no    |
| `allowed_items_max`                 | The maximum number of items allowed on the SQS queue before it triggers an alarm                                                                                                                                                    | `number`      | `50`              |    no    |
| `kms_data_key_reuse_period_seconds` | The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours) | `number`      | `300`             |    no    |
| `kms_master_key_id`                 | The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK                                                                                                                                                   | `string`      | `"alias/aws/sqs"` |    no    |
| `max_message_size`                  | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)                                                                                     | `number`      | `262144`          |    no    |
| `redrive_policy`                    | The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5")                                                                 | `string`      | `""`              |    no    |
| `tags`                              | A mapping of tags to assign to all resources                                                                                                                                                                                        | `map(string)` | `{}`              |    no    |

## Outputs

| Name              | Description |
| ----------------- | ----------- |
| deadletter\_queue | n/a         |
| queue             | n/a         |
