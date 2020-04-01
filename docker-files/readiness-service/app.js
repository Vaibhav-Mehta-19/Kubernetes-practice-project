var express = require('express');
var app = express();

var ready = false

app.get('/readiness', function (req, res) {
  res.set('Content-Type', 'application/json');
  if (ready)
    res.status(200).json({'status': "Up"});
  else 
    res.status(404).json({'status': "Not up"});
});

app.post('/init', function (req, res) {
  res.set('Content-Type', 'application/json');
    ready = true;
    res.status(200).json({'status': "success"});
});

app.post('/destroy', function (req, res) {
  res.set('Content-Type', 'application/json');
    ready = false;
    res.status(404).json({'status': "down"});
});

app.listen(8080, function () {
  console.log('Example app listening on port 3000!');
});