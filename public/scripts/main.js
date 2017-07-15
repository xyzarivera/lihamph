(function(doc) {
  var delPostings = document.getElementsByClassName('del-posting');
  for(var i = 0; i < delPostings.length; ++i) {
    delPostings[i].addEventListener('click', function(ev) {
      var xhr = new XMLHttpRequest();
      var id = ev.target.dataset.id;
      var csrf = ev.target.dataset.csrf;
      xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
          if(xhr.status === 200) { window.location = '/'; }
        }
        if(xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
          if(xhr.status >= 400) { console.log(xhr.statusText); }
        }
      };
      xhr.open('DELETE', '/posting/' + id, true);
      xhr.setRequestHeader('Accept', 'application/json');
      xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
      xhr.send('_csrf=' + csrf);
    });
  }

  var delComments = document.getElementsByClassName('del-comment');
  for(var j = 0; j < delComments.length; ++j) {
    delComments[j].addEventListener('click', function(ev) {
      var dcXhr = new XMLHttpRequest();
      var id = ev.target.dataset.id;
      var topicId = ev.target.dataset.topicId;
      var csrf = ev.target.dataset.csrf;
      dcXhr.onreadystatechange = function() {
        if(dcXhr.readyState === XMLHttpRequest.DONE) {
          if(dcXhr.status === 200) { window.location = '/posting/' + topicId; }
        }
        if(dcXhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
          if(dcXhr.status >= 400) { console.log(dcXhr.statusText); }
        }
      };
      dcXhr.open('DELETE', '/comment/' + id, true);
      dcXhr.setRequestHeader('Accept', 'application/json');
      dcXhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
      dcXhr.send('_csrf=' + csrf);
    });
  }

  var upvotePosting = document.getElementsByClassName('upvote-heart');
  for(var k = 0; k < upvotePosting.length; ++k) {
    upvotePosting[k].addEventListener('click', function(ev) {
      var tg = ev.target;
      var id = tg.dataset.id;
      var csrf = tg.dataset.csrf;
      var count = Number(tg.dataset.count);
      createRequest({
        url: '/upvote/' + id,
        type: 'post',
        headers: {
          accept: 'application/json',
          contentType: 'application/x-www-form-urlencoded'
        },
        body: { csrf: csrf }
      }, function(xhr) {
        tg.innerHTML = '❤️';
        tg.nextSibling.innerHTML = count + 1;
      }, function(xhr) {
        console.log('err:', xhr);
      });
    });
  }

  function createRequest(opts, success, fail) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
      if(xhr.readyState === XMLHttpRequest.DONE) {
        if(xhr.status >= 200 && xhr.status <= 204) { return success(xhr); }
      }
      if(xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
        if(xhr.status >= 400) { return fail(xhr); }
      }
    };
    xhr.open(opts.type, opts.url, true);
    xhr.setRequestHeader('Accept', opts.headers.accept);
    xhr.setRequestHeader('Content-type', opts.headers.contentType);
    xhr.send('_csrf=' + opts.body.csrf);
  }
})(document);
