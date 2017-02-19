let gulp = require('gulp');
let args = require('yargs').argv;
let plug = require('gulp-load-plugins')({ lazy: true });
let dbConfig = require('./db.config');
let fs = require('fs');
let path = require('path');

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
