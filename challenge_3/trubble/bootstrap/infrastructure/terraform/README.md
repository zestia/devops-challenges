# Trubble infra bootstrap

## internal use only

Creates the base infra needed for the trubble instances:

- A vpc with a public subnet and routes
- an open security group for HTTP and SSH
- ssh public keys for each user


## Setup

Setup AWS credentials

```
export AWS_ACCESS_KEY_ID="xxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxx"
export AWS_SESSION_TOKEN="xxxxx"
```

add username, ssh public keys to the local variable `allowed_keys` in the [locals.tf file](./locals.tf)
