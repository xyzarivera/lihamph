(function() {
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
      xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xhr.send('_csrf=' + csrf);
    });
  }

  var delComments = document.getElementsByClassName('del-comment');
  for(var i = 0; i < delComments.length; ++i) {
    delComments[i].addEventListener('click', function(ev) {
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
      dcXhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      dcXhr.send('_csrf=' + csrf);
    });
  }
})();