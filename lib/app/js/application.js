var size_formater = function(size) {
  if (size > 1000000000) {
    return Math.round(size/10000000) / 100 + ' Go';
  }
  if (size > 1000000) {
    return Math.round(size/10000) / 100 + ' Mo';
  }
  if (size > 1000) {
    return Math.round(size/10) / 100 + ' Ko';
  }
  return size + ' o';
}

var print_search = function(json) {
  if (json.q == document.getElementById('q').value) {
    var boxes = document.getElementById('entries');
    boxes.innerHTML = '';

    if (json.hits.length == 0) boxes.innerHTML = '<h3>No results</h3>';

    json.hits.forEach(function(entry) {
      var box = document.createElement('div');
      box.className = 'well well-sm'

      var size = document.createElement('span');
      size.className = 'label label-default pull-right';
      size.innerHTML = size_formater(entry.size);
      box.appendChild(size);

      var dirname = document.createElement('small');
      dirname.innerHTML = entry.dirname;
      box.appendChild(dirname);

      var basename = document.createElement('div');
      basename.innerHTML = entry.basename;
      box.appendChild(basename);

      boxes.appendChild(box);
    });
  }
}

var load_search = function(q) {
  var request = new XMLHttpRequest();
  request.open('GET', '/entries?q='+q)
  request.responseType = 'json'
  request.onreadystatechange = function() {
    if (request.readyState != 4 || request.status != 200) return;
    print_search(request.response);
  }
  request.send();
}

var auto_search = function() {
  var q_box = document.getElementById('q');
  q_box.focus();

  var run_search = function(q) {
    setTimeout(function() {
      if (q == q_box.value) {
        load_search(q_box.value);
      }
    }, 500);
  }

  q_box.oninput = function() {
    run_search(q_box.value);
  }
}

var preventSubmit = function() {
  document.getElementById('q').addEventListener('keypress', function(event) {
    if (event.keyCode == 13) {
      event.preventDefault();
    }
  });
}

window.onload = function () {
  preventSubmit();
  auto_search();
  load_search('');
}
