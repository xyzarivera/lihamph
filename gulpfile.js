let gulp = require('gulp');
let args = require('yargs').argv;
let plug = require('gulp-load-plugins')({ lazy: true });
let dbConfig = require('./db.config');
let fs = require('fs');
let path = require('path');

////////////////////////////////////////////////

const uglify = require('gulp-uglify');
const cssnano = require('gulp-cssnano');
const gzip = require('gulp-gzip');
const rename = require('gulp-rename');
const deployAzureCdn = require('gulp-deploy-azure-cdn');

////////////////////////////////////////////////

gulp.task('build-sql', function() {
  //Sequence is important in running the script
  log('Concatenating SQL scripts...');
  let sqlFiles = dbConfig.scripts;

  if(args.test) {
    dbConfig.testDataScripts.forEach(function(scrp) {
      sqlFiles.push(scrp);
    });
  }

  return gulp
    .src(sqlFiles)
    .pipe(plug.concat(dbConfig.buildScriptName))
    .pipe(gulp.dest(dbConfig.buildDir));
});

gulp.task('sql', ['build-sql'], function(done) {
  let env = process.env.NODE_ENV || 'development';
  let config = require('./server/config/config')[env];
  let connectionString = config.database.connectionString;
  let pgp = require('pg-promise')();
  let db = pgp(connectionString);
  let buildScript = path.join(__dirname, dbConfig.buildDir, dbConfig.buildScriptName);

  log('Executing ' + buildScript + ' to sql db in ' + connectionString.split('@')[1]);
  fs.readFile(buildScript, { encoding: 'utf-8'}, function(err, content) {
    if(err) {
      console.error(err);
      return done();
    }
    db.query(content)
      .then(function() {
        pgp.end();
        done();
      })
      .catch(function(err) {
        console.error(err);
        pgp.end();
        done();
      });
  });
});

gulp.task('js-compress', function () {
  log('Compressing JS file');
  return gulp.src('public/scripts/main.js')
    .pipe(uglify())
    .pipe(rename('main.min.js'))
    .pipe(gulp.dest('public/scripts'));
});

gulp.task('css-compress', function () {
  log('Compressing CSS file');
  return gulp.src('public/stylesheets/main.css')
    .pipe(cssnano())
    .pipe(rename('main.min.css'))
    .pipe(gulp.dest('public/stylesheets'));
});

gulp.task('assets', ['js-compress', 'css-compress'], function() {
  let stor = {
    assets: 'public/**/*',
    container: 'krw',
    account: process.env.KRW_STORAGE_ACCOUNT,
    key: process.env.KRW_STORAGE_KEY
  };
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
  if (typeof(msg) === 'object') {
    for(let item in msg) {
      if(msg.hasOwnProperty(item)) {
        plug.util.log(plug.util.colors.blue(msg[item]));
      }
    }
  } else {
    plug.util.log(plug.util.colors.blue(msg));
  }
}
