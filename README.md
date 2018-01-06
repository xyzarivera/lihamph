# Liham Na Iniwan
Write stories anywhere, fast for [liham.ph](http://liham.ph). Forked from descouvre repository.

## Features

- Simple login username/password using Passport module
- Write post using basic markdown
- Super lightweight client side

## Prerequisite Components

Install the following components in your local development machine or server.

[Node.js 8.9](https://nodejs.org/en/download)

[Postgresql 9.6](https://www.postgresql.org/download/)

[Redis 3.2](https://redis.io/download)

For Windows 7/8/10, you can check the Microsoft Redis releases from their [Github page](https://github.com/MicrosoftArchive/redis/releases)

## Setup your Postgresql database

NOTE: Make sure your database name and user name for Postgresql should be the same to avoid difficult configuration issues on your setup.

This creates the database and the user. Make sure your user account is a superuser and has a password.

```bash
createdb lihamph
createuser lihamph --superuser --pwprompt
```

Test your new database and user
```
psql -U lihamph
```

See this stackoverflow question if you have  [https://stackoverflow.com/questions/10861260/how-to-create-user-for-a-db-in-postgresql](https://stackoverflow.com/questions/10861260/how-to-create-user-for-a-db-in-postgresql)

## Setting up the environment variables

Setup the following environment variables in your machine:

`NODE_ENV` - Use "development" for your local development machine. The stage or prod are used for the sever setup.

`LHM_POSTGRESQL` - Postgresql connection string. Example connection string: "postgres://username:password@127.0.0.1/lihamph".

`LHM_REDIS_HOST` - Redis address instance without the port. For local development machine, you can use "127.0.0.1".

`LHM_REDIS_KEY` - Redis instance password. Do not set if requirepass is not configured.

`LHM_SESSION_SECRET` - Any string to set the session secret. Example secret: "ionlydrinkmilktea".

------
This is only required for setting up the servers. The following environment variables are used for the deployment. You can skip this.

`LHM_STORAGE_ACCOUNT` - Azure Storage for asset uploads  
`LHM_STORAGE_KEY` - Azure Storage secret key  
`LHM_CDN_URL` - HTTPS URL of the content delivery network where the assets are located

NOTE: For Windows 7/8/10, make sure you are an administrator of your machine and follow the instructions here: [https://superuser.com/questions/949560/how-do-i-set-system-environment-variables-in-windows-10](https://superuser.com/questions/949560/how-do-i-set-system-environment-variables-in-windows-10)

## Quick Setup

First, make sure the maintainer has added you as a collaborator so that you can clone it in your setup. 

Clone the repository in your project directory.
```bash
git clone https://github.com/descouvre/lihamnainiwan
cd lihamnainiwan
```

Installs the global and project dependencies to your machine.
```bash
npm install

# For Linux/Unix, this require sudo
# For Windows, it requires your CLI with run as admin
npm install -g nsp nodemon 
```

Runs the database script to the database
```bash
npm run db-test
```

Runs the web app
```bash
nodemon app.js
```

The web app listens to port 6500 by default.

Open the [localhost:6500](http://localhost:6500) in your browser to test the web app on your local development machine. If you can change any of the server-side JS file, it automatically restarts the app for you.

## Contribution

This project is created under the Descouvre project of Fortcode Inc.
- Kenneth Bastian (bastian.kenneth.g@gmail.com)
