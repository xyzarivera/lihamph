/**
 * @description
 * cdn-upload.js
 */
'use strict';

const async = require('async');
const azureStorage = require('azure-storage');
const fs = require('fs');
const helper = require('./helper');
const log = helper.log;
const strg = require('./config').azure.storage;
const blobSvc = azureStorage.createBlobService(strg.account, strg.key);

log.yellow(`cdn: account: ${strg.account} in ${strg.container}`);
helper.getFiles(['./build/assets/**/*'], (err, files) => {
  async.eachLimit(files, 10, (file, done) => {
    if(!fs.lstatSync(file).isFile()) { return done(); }

    const blobName = file.replace('./build/assets/', '');
    const opts = {
      contentSettings: {
        cacheControl: 'public, max-age: 604800'
      }
    };
    log.plain(`cdn: uploading: ${file} as ${blobName}`);
    blobSvc.createBlockBlobFromLocalFile(strg.container, blobName, file, opts,
      (err, result, res) => {
        if(err) { return done(err); }
        done();
      });
  }, (err) => {
    if(err) { return log.red(err); }
    log.green(`cdn: ${files.length} files are uploaded`);
  });
});


