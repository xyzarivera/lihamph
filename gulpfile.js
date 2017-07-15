const gulp = require('gulp');
const args = require('yargs').argv;
const plug = require('gulp-load-plugins')({ lazy: true });
const fs = require('fs');
const path = require('path');

////////////////////////////////////////////////

const uglify = require('gulp-uglify');
const cssnano = require('gulp-cssnano');
const gzip = require('gulp-gzip');
const rename = require('gulp-rename');
const deployAzureCdn = require('gulp-deploy-azure-cdn');

////////////////////////////////////////////////

const dbConfig = require('./db.config');
const config = require('./gulp.config');

////////////////////////////////////////////////

gulp.task('build-sql', () => {
  //Sequence is important in running the script
  log('Concatenating SQL scripts...');
  const sqlFiles = dbConfig.scripts;

  if(args.test) {
    dbConfig.testDataScripts.forEach((scrp) => {
      sqlFiles.push(scrp);
    });
  }

  return gulp
    .src(sqlFiles)
    .pipe(plug.concat(dbConfig.buildScriptName))
    .pipe(gulp.dest(dbConfig.buildDir));
});

gulp.task('sql', ['build-sql'], (done) => {
  const env = process.env.NODE_ENV || 'development';
  const config = require('./server/config/config')[env];
  const connectionString = config.database.connectionString;
  const pgp = require('pg-promise')();
  const db = pgp(connectionString);
  const buildScript = path.join(__dirname, dbConfig.buildDir, dbConfig.buildScriptName);

  log('Executing ' + buildScript + ' to sql db in ' + connectionString.split('@')[1]);
  fs.readFile(buildScript, { encoding: 'utf-8'}, (err, content) => {
    if(err) {
      console.error(err);
      return done();
    }
    db.query(content)
      .then(() => {
        pgp.end();
        done();
      })
      .catch((err) => {
        console.error(err);
        pgp.end();
        done();
      });
  });
});

gulp.task('analysis', () => {
  log('Code Analysis using ESLint');
  return gulp
    .src(config.analysis.js)
    .pipe(plug.if(args.verbose, plug.print()))
    .pipe(plug.eslint())
    .pipe(plug.eslint.format())
    .pipe(plug.eslint.failAfterError());
});

gulp.task('js-compress', () => {
  log('Compressing JS file');
  return gulp.src(config.scripts.src)
    .pipe(uglify())
    .pipe(rename(config.scripts.minName))
    .pipe(gulp.dest(config.scripts.dest));
});

gulp.task('css-compress', () => {
  log('Compressing CSS file');
  return gulp.src(config.stylesheets.src)
    .pipe(cssnano())
    .pipe(rename(config.stylesheets.minName))
    .pipe(gulp.dest(config.stylesheets.dest));
});

gulp.task('assets', ['js-compress', 'css-compress'], () => {
  const stor = config.storage;
  log('Upload assets to Azure Storage on ' + stor.account);

  return gulp.src(stor.assets)
    .pipe(gzip({
      append: false,
      threshold: false,
      gzipOptions: {
        level: 9,
        memLevel: 9
      }
    }))
    .pipe(deployAzureCdn({
      containerName: stor.container,
      serviceOptions: [stor.account, stor.key],
      zip: true,
      folder: 'assets',
      deleteExistingBlobs: true,
      metadata: {
        cacheControl: 'public, max-age=31530000',
        cacheControlHeader: 'public, max-age=31530000'
      },
      testRun: false
    }));
});

function log(msg) {
  if(typeof(msg) === 'object') {
    for(let item in msg) {
      if(msg.hasOwnProperty(item)) {
        plug.util.log(plug.util.colors.blue(msg[item]));
      }
    }
  } else {
    plug.util.log(plug.util.colors.blue(msg));
  }
}
