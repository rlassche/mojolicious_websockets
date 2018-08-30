var ws;
var log = function (text) {
  $('#log').val($('#log').val() + text + "\n");
};
$(function () {
  console.log('Top of function');
  var timerID = 0;
  function keepAlive() {
    var timeout = 14000;
    if (ws.readyState == ws.OPEN) {
      console.log('keep alive: ' + timerID++);
      ws.send('');
    } else {
      console.log('CONNECTIN IS CLOSED!! ');
    }
    timerId = setTimeout(keepAlive, timeout);
  }
  function cancelKeepAlive() {
    if (timerId) {
      clearTimeout(timerId);
    }
  }

  socketinit();
  keepAlive();
  $('#msg').focus();

  $('#msg').keydown(function (e) {
    if (e.keyCode == 13 && $('#msg').val()) {
      console.log('ws: ', ws);
      if (ws.readyState == 1) {
        ws.send($('#msg').val());
        $('#msg').val('');
      } else {
        log('Connection with server is lost');
      }
    }
  });



})

function socketinit() {
  console.log('socketinit');
  ws = new WebSocket('wss://hp-probook:9443/echo');
  ws.onopen = function () {
    log('Connection opened');
  };

  ws.onmessage = function (msg) {
    var res = JSON.parse(msg.data);
    log('[' + res.hms + '] ' + res.text);
  };
  ws.onclose = function (evt) {
    log('onclose');
    console.log('onclose, calling socketinit');
    socketinit();
  }
}
