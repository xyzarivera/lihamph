/**
 * @description
 * Stylus compression
 */
'use strict';

const postcss = require('postcss');
const precss = require('precss');
const autoprefixer = require('autoprefixer');
const args = require('yargs').argv;
const fs = require('fs');
const path = require('path');
const helper = require('./helper');
const log = helper.log;
const CleanCSS = require('clean-css');
const stylesheetsPath = '/stylesheets';
const target = path.resolve(__dirname, `../build/assets${stylesheetsPath}`);
const buildConfig = require('./config');
const cdn = buildConfig.azure.cdn;
const containerName = buildConfig.azure.storage.container;

((args) => {
  const opts = {
    dir: '../public'
  };
  const regexp = new RegExp(/data-mincss-group="([a-z]+)" href="(.+?)"/, 'gm');
  helper.getSourcesFromViews(regexp, opts, (err, sources) => {
    if(err) { return log.red(err); }
    start(sources);
  });
})(args);

/**
 * Minifies the file based on the source name and content
 * @param {String} src
 * @param {String} content
 * @param {function(Error, String)} done
 */
function minify(src, content, done) {
  const storageDir = path.resolve(target, src + '.css');
  const filename = helper.revFile(storageDir, content);
  log.yellow(`cssmin: setting filename ${filename}`);
  postcss([precss, autoprefixer])
    .process(content, { from: storageDir, to: filename })
    .then((result) => {
      if(result.error) { return done(result.error, null); }

      log.yellow(`cssmin: min success on ${filename} len ${result.css.length}`);
      const output = new CleanCSS({
        compatibility: '*'
      }).minify(result.css);
      fs.writeFile(filename, output.styles, { encoding: 'utf-8'}, (err) => {
        if(err) { return done(err, null); }

        const name = path.join(stylesheetsPath, path.basename(filename));
        log.yellow(`cssmin: completing min for ${name}`);
        done(null, name);
      });
    });
}

/**
 * Minifies the css from the sources
 * @param {Object} sources
 */
function start(sources) {
  for(let src in sources) {
    if(sources.hasOwnProperty(src)) {
      const fileSrc = sources[src];
      helper.getFiles(fileSrc, (err, files) => {
        let content = String();
        files.forEach((file) => {
          log.yellow(`cssmin: ${src}: reading ${file}`);
          let readDir = path.resolve(__dirname, '../', file);
          let fileContent = fs.readFileSync(readDir, { encoding: 'utf-8' });
          if(fileContent) {
            content += fileContent + '\n';
          }
        });
        minify(src, content, (err, filename) => {
          if(err) { return log.red(err); }
          log.green(`cssmin: ${src}: minified ${filename}`);

          const regexp = new RegExp(`link\\(.*? data-mincss-group="${src}" .*?"\\)`, 'gm');
          let cdnPath = filename;
          if(args.cdn) {
            cdnPath = cdn.url.replace('https:', '') + path.join(`/${containerName}/`, filename);
          }
          const tagSrc = `link(href="${cdnPath}" rel="stylesheet")`;
          helper.replaceOnViews(regexp, tagSrc, (err, affectedFiles) => {
            if(err) { log.red(err); }
            log.green(`cssmin: ${src}: replaced ${filename} affected: ${affectedFiles.length}`);
          });
        });
      });
    }
  }
}
