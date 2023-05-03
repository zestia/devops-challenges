# Deploy Trubble

A playbook to create an AWS EC2 instance and install The trubble nodejs application.

## Prerequisites

- python 3.9+
- python pip

## Setup

Install dependencies

```
python3 -m pip install -r requirements.txt
ansible-galaxy install -f -r requirements.yml
ansible-galaxy collection install -f -r requirements.yml
```

Setup AWS credentials

```
export AWS_ACCESS_KEY_ID="xxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxx"
export AWS_SESSION_TOKEN="xxxxx"
```

To only manage existing running application instances run:

ansible-playbook deploy.yml  --extra-vars='\{"users": \[user1,user2,user3\]\}' --skip-tags='create'

where `users` var is an array of users to create instances for.

Run the full playbook and create a new instance:

```
ansible-playbook deploy.yml  --extra-vars='\{"users": \[user1,user2,user3\]\}'
```