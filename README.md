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

| Name                                   | Description                                                                                                                                                                                                                         | Type          | Default           | Required |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ----------------- | :------: |
| alarm\_sns\_topic\_arn                 | ARN of the SNS topic for alarm notifactions                                                                                                                                                                                         | `any`         | n/a               |   yes    |
| allowed\_arns                          | A list of AWS account IDs allowed to access this resource                                                                                                                                                                           | `list`        | n/a               |   yes    |
| allowed\_items\_max                    | The maximum number of items allowed on the SQS queue before it triggers an alarm                                                                                                                                                    | `number`      | `50`              |    no    |
| content\_based\_deduplication          | Enables content-based deduplication for FIFO queues                                                                                                                                                                                 | `bool`        | n/a               |   yes    |
| fifo\_queue                            | Boolean designating a FIFO queue                                                                                                                                                                                                    | `bool`        | n/a               |   yes    |
| kms\_data\_key\_reuse\_period\_seconds | The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours) | `number`      | `300`             |    no    |
| kms\_master\_key\_id                   | The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK                                                                                                                                                   | `string`      | `"alias/aws/sqs"` |    no    |
| max\_message\_size                     | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)                                                                                     | `number`      | `262144`          |    no    |
| message\_retention\_seconds            | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)                                                                                                           | `number`      | n/a               |   yes    |
| name                                   | This is the human-readable name of the queue. If omitted, Terraform will assign a random name.                                                                                                                                      | `string`      | n/a               |   yes    |
| redrive\_policy                        | The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5")                                                                 | `string`      | `""`              |    no    |
| tags                                   | A mapping of tags to assign to all resources                                                                                                                                                                                        | `map(string)` | `{}`              |    no    |
| visibility\_timeout\_seconds           | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)                                                                                                                                                         | `number`      | n/a               |   yes    |

## Outputs

| Name              | Description |
| ----------------- | ----------- |
| deadletter\_queue | n/a         |
| queue             | n/a         |
