/**
 * helper.js
 */
'use strict';

const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const glob = require('glob');
const async = require('async');
const chalk = require('chalk');

module.exports = {
  getFiles,
  getSourcesFromViews,
  replaceOnViews,
  revFile,
  log: {
    green: function(msg) { console.log(chalk.green(msg)); },
    red: function(msg) { console.error(chalk.red(msg)); },
    yellow: function(msg) { console.log(chalk.yellow(msg)); },
    plain: function(msg) { console.log(msg); },
  }
};

/**
 * Retrieves the files using glob
 * @param {String[]} patterns
 * @param {function(Error, String[])} done
 */
function getFiles(patterns, done) {
  let files = new Set(); //- To keep the files unique
  async.each(patterns, (pattern, cb) => {
    glob(pattern, (err, matches) => {
      if(err) { return cb(err, null); }
      matches.forEach(m => files.add(m));
      cb();
    });
  }, (err) => {
    if(err) { return done(err, []); }
    done(null, Array.from(files));
  });
}

/**
 * Revs up the file for cache busting
 * @param {String} filename
 * @param {String} code
 * @returns {String}
 */
function revFile(filename, code) {
  const hash = crypto.createHmac('sha256', 'wandering-wolf')
    .update(code)
    .digest('hex')
    .slice(0, 12);
  const base = path.basename(filename);
  const dir = path.dirname(filename);
  const ext = path.extname(base);
  return path.join(dir, base.replace(ext, '') + '-' + hash + '.min' + ext);
}

/**
 * Gets the sources from the pug files in the build folder
 * @param {RegExp} regexp - Uses 3 group match in the pattern
 * @param {function(Error, Object)} done
 */
function getSourcesFromViews(regexp, opts, done) {
  const pugs = path.resolve(__dirname, '../build/views/**/*.pug');
  const sources = {};
  getFiles([pugs], (err, files) => {
    if(err) { return done(err, null); }
    files.forEach((file) => {
      let content = fs.readFileSync(file, { encoding: 'utf-8' });
      let match = regexp.exec(content);
      while(match !== null) {
        let group = match[1];
        let script = path.join(__dirname, opts.dir, match[2]);

        if(!sources[group]) { sources[group] = []; }
        sources[group].push(script);

        match = regexp.exec(content);
      }
    });
    done(null, sources);
  });
}

/**
 * Replaces anything that matches the regexp with value on the pug files
 * @param {RegExp} regexp
 * @param {String} value
 * @param {function(Error, Object)} done
 */
function replaceOnViews(regexp, value, done) {
  const pugs = path.resolve(__dirname, '../build/views/**/*.pug');
  let affectedFiles = [];
  getFiles([pugs], (err, files) => {
    if(err) { return done(err, null); }
    if(files.length === 0) { return done(null, affectedFiles); }

    files.forEach((file, index) => {
      let hasReplaced = false;
      let originalContent = fs.readFileSync(file, { encoding: 'utf-8' });
      let match = regexp.exec(originalContent);
      let transformedContent = String(originalContent);

      while(match !== null) {
        //- Replace only once in the file
        if(!hasReplaced) {
          affectedFiles.push(file);
          transformedContent = transformedContent.replace(match[0], value);
          hasReplaced = true;
        } else {
          //- just wiped it from the view file since it has been replaced once
          transformedContent = transformedContent.replace(match[0], '');
        }
        match = regexp.exec(originalContent);
      }

      fs.writeFileSync(file, transformedContent, { encoding: 'utf-8' });
    });
    done(null, affectedFiles);
  });
}
