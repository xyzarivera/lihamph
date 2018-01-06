/**
 * @description
 * Minifies the JS and CSS files into bundles
 */
'use strict';

const fs = require('fs');
const path = require('path');
const helper = require('./helper');
const args = require('yargs').argv;
const log = helper.log;
const UglifyJS = require('uglify-js');
const target = path.resolve(__dirname, '../build/assets/scripts');
const scriptPath = '/scripts';
const cdn = require('./config').azure.cdn;

const regexp = new RegExp(/data-minjs-group="([a-z]+)" src="(.+?)"/, 'gm');
const opts = {
  dir: '../public'
};
helper.getSourcesFromViews(regexp, opts, (err, sources) => {
  if(err) { return log.red(err); }
  minifyFiles(sources);
});

/**
 * Minifies the file based on the source name and content
 * @param {String} src
 * @param {String} content
 * @param {function(Error, String)} done
 */
function minify(src, content, done) {
  log.yellow(`jsmin: minifying src ${src}`);

  let minified = UglifyJS.minify(content, { warnings: true });
  if(minified.error) { return done(minified.error, null); }

  log.yellow(`jsmin: min success for ${src} len ${minified.code.length}`);
  const storageDir = path.resolve(target, src + '.js');
  const filename = helper.revFile(storageDir, minified.code);
  log.yellow(`jsmin: setting filename ${filename}`);
  fs.writeFile(filename, minified.code, { encoding: 'utf-8'}, (err) => {
    if(err) { return done(err, null); }

    const name = path.resolve(scriptPath, path.basename(filename));
    log.yellow(`jsmin: completing min for ${name}`);
    done(null, name);
  });
}

/**
 * Minifies the files to the target folder
 */
function minifyFiles(sources) {
  for(let src in sources) {
    if(sources.hasOwnProperty(src)) {
      const fileSrc = sources[src];
      helper.getFiles(fileSrc, (err, files) => {
        let content = String();
        files.forEach((file) => {
          let readDir = path.resolve(__dirname, '../', file);
          let fileContent = fs.readFileSync(readDir, { encoding: 'utf-8' });
          if(fileContent) { content += fileContent + '\n'; }
        });
        minify(src, content, (err, filename) => {
          if(err) { return log.red(err); }
          log.green(`jsmin: ${src}: minified: ${filename}`);

          const regexp = new RegExp(`script\\(.*?data-minjs-group="${src}".*?"\\)`, 'gm');
          let cdnPath = filename;
          if(args.cdn) {
            cdnPath = cdn.url.replace('https:', '') + path.join('/assets/', filename);
          }
          const tagSrc = `script(src="${cdnPath}")`;
          helper.replaceOnViews(regexp, tagSrc, (err, affectedFiles) => {
            if(err) { return log.red(err); }
            log.green(`jsmin: ${src}: replaced ${filename} affected: ${affectedFiles.length}`);
          });
        });
      });
    }
  }
}
