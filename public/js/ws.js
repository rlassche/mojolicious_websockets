var ws;
var log = function (text) {
  $('#log').val($('#log').val() + text + "\n");
};
$(function () {
  console.log('Top of function');
  var timerID = 0;
  function keepAlive() {
    // 14000 was the default
    var timeout = 140000;
    if (ws.readyState == ws.OPEN) {
      console.log('keep alive: ' + timerID++);
      ws.send('');
    } else {
      console.log('CONNECTION IS CLOSED!! ');
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

  let o = window.location.origin;
  let uri = o.replace( "http", "ws" ) ;
  console.log( 'location.origin NEW: ' , uri )
  //ws = new WebSocket('wss://hp-probook:9443/echo');
  ws = new WebSocket( uri + '/echo' ) ;
  ws.onopen = function () {
    log('Connection opened');
  };

  ws.onmessage = function (msg) {
    var res = JSON.parse(msg.data);
    log('[' + res.hms + '] ' + res.text);
  };
  ws.onclose = function (evt) {
    log('onclose');
    // Below was required, because of the frequent timeouts.
    // NOW: not neede any more. Perl increased the timeout
    //console.log('onclose, calling socketinit');
    //socketinit();
  }
}
