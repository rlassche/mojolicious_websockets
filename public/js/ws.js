var ws;
var log = function (text) {
  $('#log').val(text + "\n" + $('#log').val() );
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
      //console.log('ws: ', ws);
      console.log('#msg.val(): ', $('#msg').val());
	  //n = new Date() ;
	  //hms: n.getHours() + ':' + n.getMinutes() + ':' + n.getSeconds(),
	  twoSend = {
	    		author: $('#author').val(),
				message: $('#msg').val() 
	  };
      if (ws.readyState == 1) {
		console.log( 'ws.send: ', JSON.stringify( twoSend ) ) ;
        ws.send( JSON.stringify( twoSend ) );
        $('#msg').val('');
      } else {
        log('Connection with server is lost');
    	socketinit();
      }
    }
  });



})

function socketinit() {
  console.log('socketinit');

  let o = window.location.origin;
  let uri = o.replace("http", "ws");
  console.log('location.origin NEW: ', uri)

  ws = new WebSocket(uri + '/echo');
  ws.onopen = function () {
    log('Connection opened');
  };

  ws.onmessage = function (msg) {
    console.log( 'ws.onmessage: ', msg );
    var res = JSON.parse(msg.data);
    log(res.author + ' - ' + res.message);
  };
  ws.onclose = function (evt) {
    log('onclose');
    // Below was required, because of the frequent timeouts.
    // NOW: not neede any more. Perl increased the timeout
    //console.log('onclose, calling socketinit');
    //socketinit();
  }
}
