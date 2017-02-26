# Descouvre
Write stories anywhere, fast

## NOTES
This instance has been deployed in [kronowork.com](http://kronowork.com) and has been ongoing development.

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

`KRW_POSTGRESQL` - Postgresql connection string  
`KRW_REDIS_HOST` - Redis address instance without the port  
`KRW_REDIS_KEY` - Redis instance password (do not set if requirepass is not configured)  
`KRW_SESSION_SECRET` - Any string to set the session secret
`KRW_STORAGE_ACCOUNT` - Azure Storage for asset uploads
`KRW_STORAGE_KEY`

Quick install  
```
git clone https://github.com/onezeronine/descouvre
cd descouvre
npm install
gulp sql
node app.js
```

App listens to port 6500 by default.

## Contribution

This project is created under the Descouvre project of Fortcode Inc.
- Kenneth Bastian (kenneth.g.bastian@descouvre.com)
