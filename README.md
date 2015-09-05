# fluent-plugin-sqs-poll
fluent input plugin poll data from AWS SQS

## Install

```bash
gem install fluent-plugin-sqs-poll
```

## Configuration

If either *aws_access_key* or *aws_secret_key* is missing, it will automatically
fall back to use IAM role for access control.

```
<source>
  type sqs_poll
  aws_access_key {optional: your_aws_access_key}
  aws_secret_key {optional: your_aws_secret_key}
  tag {required: tag}
  sqs_url {required: SQS_url}
  max_number_of_messages {optional: # of messges poll at a time, default: 1}
</source>
```

## Usage

When messages are pulled off SQS queue, it's stored in key *body* of the
emmitted output. If your SQS message is in a known format, you probably want to
use in conjunction with *fluent-plugin-parser*. For example, if your message
from SQS is in JSON format, then you would want to do:

```
<source>
  type sqs_poll
  tag sqs.message
  sqs_url https://sqs.us-east-1.amazonaws.com/123456789/some_queue
  max_number_of_messages 10
</source>

<match sqs.message>
  type parser
  remove_prefix sqs
  format json
  key_name body
</match>
```
