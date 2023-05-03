# Trubble

A web application built using Node.js and Express. It serves a simple web page at the root URL. There is only a single route `/` which searches for a random entity from [pokeapi](https://pokeapi.co/) and presents the encounter as plain text.

## Prerequisites

Before running the app, make sure you have the following installed:

- Node.js version 14 (https://nodejs.org/en/download)
- NPM (Node Package Manager)

## Configuration

The web app can be configured using environment variables. Create a `.env` file in the root directory of the project with the following variables:
- `NODE_ENV` (optional): The environment the app will run in.
- `PORT` (optional): The port number the app will listen on. Defaults to `3000`.
- `IMPORTANT_VALUE` (required): A boolean value that must be set to `true` for the app to run. If this value is not set or is set to anything other than `true`, the app will log an error message and exit.

## Logging

The application will log to an `app.log` file in `logs` directory.
In production logging will also be handled by systemd and will log to `/var/logs/syslog`. check the below systemd file for details.

## Running the App in Development

To run the app, follow these steps:

1. Install dependencies by running `npm install`.
2. Start the app by running `npm start`.
3. Access the app by navigating to `http://localhost:3000` (or whichever port you specified in the `PORT` environment variable).

## Testing

Open a web browser and navigate to `http://localhost:3000/`.

## Building the app for production

1. Install dependencies by running `npm install`.
2. Build the application with `npm run build`

## Installing the app in Production

Creation of the instance, install and managment of the application is by ansible. the playbook is in the [ansible directory](./ansible/deploy.yml).
Instructions on how to use the ansible playbook can be found in the [ansible directory](./ansible/README.md).
Ansible should be used to ensure the application is installed and configured correctly.

The [playbook](./ansible/deploy.yml) reads as the documentation however the install steps can be summarised as:

1. Ensure the App is built in the `dist` directory.
1. Create a new Linux instance.
2. Ensure nodejs is installed on the system.
3. Ensure nginx is installed and configured correctly.
4. Copy the contents of the local `dist` directory to the remote machine at the `/opt/` directory
5. Use systemd (example below) to keep the app running


## Systemd Unit File

To run the app as a systemd service on Linux, create a file as a root user `/etc/systemd/system/trubble.service` with the following content:

```
[Unit]
Description=trubble
After=network.target

[Service]
Environment="NODE_ENV=production"
User=root
WorkingDirectory=/opt
ExecStart=/usr/bin/node index.js
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=trubble

[Install]
WantedBy=multi-user.target
```

Then run the following commands:

```
sudo systemctl daemon-reload
sudo systemctl enable trubble
sudo systemctl start trubble
```

The app will now start automatically on boot and can be managed using the `systemctl` command.