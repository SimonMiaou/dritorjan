var entries_to_tree = function(entries) {
  var tree = {
    name: '',
    directories: []
  };

  entries.forEach(function(entry) {
    var node = tree;
    var directories = entry.dirname.split('/');
    directories.splice(0, 1);

    directories.forEach(function(directory) {
      new_node = node.directories.filter(function(n) {
        return n.name == directory;
      })[0];

      if (!new_node) {
        new_node = {
          name: directory,
          directories: []
        }
        node.directories.push(new_node);
      }

      node = new_node
    });
  });

  return tree;
}

var human_readable_size = function(size) {
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

var print_search_result = function(json) {
  if (json.q == document.getElementById('q').value) {
    var boxes = document.getElementById('entries');
    boxes.innerHTML = '';

    if (json.hits.length == 0) boxes.innerHTML = '<h3>No results</h3>';

    json.hits.forEach(function(entry) {
      var box = document.createElement('div');
      box.className = 'well well-sm'

      var size = document.createElement('span');
      size.className = 'label label-default pull-right';
      size.innerHTML = human_readable_size(entry.size);
      box.appendChild(size);

      var dirname = document.createElement('small');
      dirname.innerHTML = entry.dirname;
      box.appendChild(dirname);

      var basename = document.createElement('div');
      basename.innerHTML = entry.basename;
      box.appendChild(basename);

      boxes.appendChild(box);
    });

    console.log(entries_to_tree(json.hits));
  }
}

var search = function(q) {
  var request = new XMLHttpRequest();
  request.open('GET', '/entries?q='+q)
  request.responseType = 'json'
  request.onreadystatechange = function() {
    if (request.readyState != 4 || request.status != 200) return;
    print_search_result(request.response);
  }
  request.send();
}

var auto_search_on_typing = function() {
  var q_box = document.getElementById('q');
  q_box.focus();

  q_box.oninput = function() {
    var q = q_box.value;

    setTimeout(function() {
      if (q == q_box.value) {
        search(q_box.value);
      }
    }, 500);
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
  auto_search_on_typing();
  search('');
}
