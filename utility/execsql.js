/**
 * @description
 * SQL script automation
 * - Run the build script
 */
'use strict';

const fs = require('fs');
const path = require('path');
const chalk = require('chalk');
const dbConfig = require('../db.config.json');
const pgp = require('pg-promise')();
const log = console.log;
const logErr = console.error;
const env = process.env.NODE_ENV || 'development';

execSql('Execute SQL');

/**
 * Execute the build sql script
 */
function execSql(name) {
  //Sequence is important in running the script
  log(`${name}: Target Environment: ` + env);
  if(env === 'production') { return log(chalk.yellow('Cannot recreate db on production')); }

  const config = require('../server/config/config')[env];
  const connectionString = config.database.connectionString;
  log(`${name}: Connecting to database: ${connectionString.split('@')[1]}`);

  const db = pgp(connectionString);
  const buildScript = path.resolve(dbConfig.buildDir, dbConfig.buildScriptName);
  log(`${name}: Executing ${buildScript} to sql db`);

  fs.readFile(buildScript, { encoding: 'utf-8'}, (err, content) => {
    if(err) { return logErr(chalk.red(`${name}: Read file error ${err.toString()}`)); }
    runBuildScript(db, content, name);
  });
}

/**
 * Runs the build script in the database
 * @param {pgPromise} db
 * @param {string} content
 */
function runBuildScript(db, content, name) {
  db.query(content)
    .then((res) => {
      log(chalk.green(`${name}: SQL Execution has been successful`));
      pgp.end();
    })
    .catch((err) => {
      logErr(chalk.red(`${name}: Read file error ${err.toString()}`));
      pgp.end();
    });
}

