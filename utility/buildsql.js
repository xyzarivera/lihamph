/**
 * @description
 * SQL script automation
 * - Concatenate all sql scripts into one package
 */
'use strict';

const fs = require('fs');
const path = require('path');
const chalk = require('chalk');
const args = require('yargs').argv;
const log = console.log;
const logErr = console.error;
const name = 'Build SQL';

function buildSql() {
  //Sequence is important in running the script
  log(chalk.blue(`${name}: initializing build scripts...`));

  let dbConfig = require('../db.config.json');

  // Override the config
  if(args.config) {
    dbConfig = require(args.config);
  }

  if(!dbConfig || !dbConfig.scripts) {
    return log(chalk.red('You passed an invalid dbConfig'));
  }

  let sqlFiles = dbConfig.scripts;

  if(args.test) {
    sqlFiles = sqlFiles.concat(dbConfig.testDataScripts);
  }

  let concatenatedSql = String();
  sqlFiles.forEach((sqlFile) => {
    log(`${name}: reading file ${sqlFile}`);
    let text = `--- START OF ${sqlFile} --- \n`;
    text += fs.readFileSync(sqlFile, 'utf-8');
    text += `--- END OF ${sqlFile} --- \n\n`;
    concatenatedSql = concatenatedSql.concat(text);
  });

  const targetDir = path.resolve(dbConfig.buildDir, dbConfig.buildScriptName);
  log(`${name}: target directory ${targetDir}`);
  fs.writeFile(targetDir, concatenatedSql, (err) => {
    if(err) { return logErr(chalk.red(err.toString())); }
    log(chalk.green(`${name}: the database SQL script has been created`));
  });
}

buildSql();
