module.exports = {
  scripts: {
    src: [
      '!public/scripts/*.min.js',
      'public/scripts/*.js'
    ],
    minName: 'liham.min.js',
    dest: 'public/scripts/'
  },
  stylesheets: {
    src: [
      '!public/stylesheets/*.min.css',
      'public/stylesheets/*.css'
    ],
    minName: 'liham.min.css',
    dest: 'public/stylesheets/'
  },
  analysis: {
    js: [
      'public/scripts/*.js',
      '!public/scripts/*.min.js',
      'server/**/*.js',
      '*.js'
    ]
  },
  storage: {
    assets: 'public/**/*',
    key: process.env.LHM_STORAGE_KEY,
    account: process.env.LHM_STORAGE_ACCOUNT,
    container: 'devstore'
  }
};