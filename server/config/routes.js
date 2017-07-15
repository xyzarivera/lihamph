/**
 * @description
 * Routes
 */
'use strict';

const accountController = require('../controllers/accountController');
const homeController = require('../controllers/homeController');
const profileController = require('../controllers/profileController');
const postingController = require('../controllers/postingController');

module.exports = function(app, config) {
  app.get('/register',
    accountController.disallowAuthenticatedUsers,
    accountController.renderRegisterPage);
  app.post('/register',
    accountController.disallowAuthenticatedUsers,
    accountController.register);

  app.get('/login',
    accountController.disallowAuthenticatedUsers,
    accountController.renderLoginPage);
  app.post('/login',
    accountController.disallowAuthenticatedUsers,
    accountController.login);

  app.get('/logout', isAuthenticated, accountController.logout);
  app.post('/logout', isAuthenticated, accountController.logout);

  app.get('/submit', isAuthenticated, postingController.renderSubmitPage);
  app.post('/submit', isAuthenticated, postingController.submitPost);

  app.get('/user/settings', isAuthenticated, profileController.renderSettingsPage);
  app.get('/user/:username', profileController.renderProfilePage);
  app.post('/user/profile', isAuthenticated, profileController.updateProfile);
  app.post('/user/password', isAuthenticated, profileController.changePassword);

  app.get('/posting/:topicId', postingController.renderPostingPage);
  app.delete('/posting/:topicId', isAuthenticated, postingController.deletePosting);
  // app.get('/comment/:postId', isAuthenticated, postingController.renderCommentPage);
  app.post('/comment/:postId', isAuthenticated, postingController.comment);
  app.delete('/comment/:postId', isAuthenticated, postingController.deleteComment);

  app.get('/edit/:postId', isAuthenticated, postingController.renderEditPostPage);
  app.post('/edit/:postId', isAuthenticated, postingController.editPost);

  app.post('/upvote/:postId', isAuthenticated, postingController.upvotePost);
  app.delete('/upvote/:postId', isAuthenticated, postingController.undoUpvotePost);

  app.get('/palatuntunan', homeController.renderRulesPage);
  app.get('/tungkol', homeController.renderAboutPage);
  app.get('/search', homeController.renderSearchPage);
  app.get('/', homeController.renderFrontPage);

  app.get('*', function notFoundHandler(req, res, next) {
    let model = req.model;
    model.meta.title = 'Not found';
    model.meta.description = 'Page not found';
    res.status(404).render('notfound', model);
  });

  app.use(function errorHandler(err, req, res, next) {
    //- Adding the copy of req.model here just in case 
    //- it fails in passport or any middleware before init model
    const baseUrl = req.protocol + '://' + req.get('host');
    let model = req.model || {
      meta: {
        url: baseUrl +  req.originalUrl,
        type: 'website',
        title: 'Mga Liham na Iniwan',
        description: 'Mga Liham na Iniwan - Isang lugar para mga katha ng mga makata',
        siteName: 'http://lihamnainiwan.com'
      },
      user: req.user,
      verbose: config.middleware.verbose,
      cdn: config.middleware.cdn
    };
    model.error = {};

    model.error.message = err.toString();
    model.error.stack = err.stack || new Error().stack;

    if(req.headers.accept === 'application/json') {
      return res.status(500).send(model.error);
    }

    model.meta.title = 'Internal Error';
    model.meta.description = 'Internal server error';
    res.status(500).render('error', model);
  });
};

function isAuthenticated(req, res, next) {
  if(req.isAuthenticated()) {
    return next();
  }
  res.redirect('/');
}
