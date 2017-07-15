# Liham Na Iniwan
Write stories anywhere, fast [liham.ph](http://liham.ph). Forked from descouvre repository.

## Features

- Simple login username/password using Passport module
- Write post using basic markdown
- Super lightweight client side

## Prerequisites

[Node.js 6.9](https://nodejs.org/en/download)  
[Postgresql 9.6](https://www.postgresql.org/download/)  
[Redis 3.2](https://redis.io/download)  

## Get Started

Setup the following environment variables in your machine:

`NODE_ENV` - Use development, stage or prod as values.  
`LHM_POSTGRESQL` - Postgresql connection string  
`LHM_REDIS_HOST` - Redis address instance without the port  
`LHM_REDIS_KEY` - Redis instance password (do not set if requirepass is not configured)  
`LHM_SESSION_SECRET` - Any string to set the session secret  
`LHM_STORAGE_ACCOUNT` - Azure Storage for asset uploads  
`LHM_STORAGE_KEY` - Azure Storage secret key  
`LHM_CDN_URL` - HTTPS URL of the content delivery network where the assets are located  

Quick install
```
git clone https://github.com/descouvre/lihamnainiwan
cd lihamnainiwan
npm install
gulp sql
node app.js
```

App listens to port 6500 by default.

## Contribution

This project is created under the Descouvre project of Fortcode Inc.
- Kenneth Bastian (kenneth.g.bastian@descouvre.com)
