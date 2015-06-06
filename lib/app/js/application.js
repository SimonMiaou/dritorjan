var print_search = function(entries) {
  var boxes = document.getElementById('entries');
  boxes.innerHTML = '';

  if (entries.length == 0) boxes.innerHTML = '<h3>No results</h3>';

  entries.forEach(function(entry) {
    var box = document.createElement('div');
    var file_path = document.createElement('div');

    file_path.innerHTML = entry.file_path

    box.appendChild(file_path);
    boxes.appendChild(box);
  });
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

window.onload = function () {
  auto_search();
}
