#  Mojolicious application

Demonstrate a Perl Mojolicious echo server application with websockets. 

A html/javascript client and SSL connection. 

Websockets timeout very quickly. This is also handled in this app.

## Create a new mojolicious application

Generate a new application 

`mojo generate app sdc`.

Controler `example` is created in package `lib\Sdc\Controller\Example.pm`.

## The mojolicious websocket 

### End point `echo`
Create the end-point in controller `example` 

Open file `Example.pm` and past this code.

A HTML client with javascript, will generate keepalive request. This means, in this example, that the length of 
the message is zero and will not send back to the client.

```
sub echo {
    my $self = shift;
    $self->on(
        message => sub {
            my ( $self, $msg ) = @_;
            $self->app->log->info( 'Controller::Example.echo on.message: msg=' . $msg );
            if ( length($msg) > 0 ) {
                my $dt = DateTime->now( time_zone => 'Europe/Amsterdam' );
                $self->send(
                    {
                        json => {
                            hms  => $dt->hms,
                            text => $msg
                        }
                    }
                );
            }
        }
    );
}
```

### The websocket in the router

The websocket endpoint in the router. Open the main application file `Sdc.pm`  and add this code:

```
$r->websocket('/echo')->to('example#echo');
```


## The HTML webpage for communicating with the websocket 

### The HTML webpage

Paste the following code in the template file `templates\example\client.html.ep`

```
<html>
  <head>
    <title>WebSocket Client</title>
    <script
      type="text/javascript"
      src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"
    ></script>
    <script type="text/javascript" src="/js/ws.js"></script>
    <style type="text/css">
      textarea {
          width: 40em;
          height:10em;
      }
    </style>
  </head>
<body>

<h1>Mojolicious + WebSocket</h1>

<p><input type="text" id="msg" /></p>
<textarea id="log" readonly></textarea>

</body>
</html>
```

Java script code in `public\js\ws.js`

```
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
```


### Mojolicious action `client`

Paste the code below in the example controller `lib\Sdc\Controller\Example.pm`:

```
sub client {
    my $self = shift;

    $self->app->log->info('Controller::Example.client');

    # Render template "example/client.html.ep" with message
    $self->render( msg => 'Websocket client' );
}
```

### Add the router in the main app

Add the code in file `Sdb.pm`

```
$r->get('/client')->to( controller => 'example', action => 'client' );
```

### Configure SSL for hypnotoad

Open the config file `sdc.conf` and add:

```
{
	perldoc => 1,
	secrets => ['a0f4bbe99524090791bfd31483ad27dd221ac0e2'],

	hypnotoad => {
    	listen  => ['https://hp-probook:9443?cert=ssl/hp-probook.cert.pem&key=ssl/hp-probook.key.pem'],
    	workers => 5
  	}
}
```

My self-signed ssl certificates can be found in the `ssl` directory.

#Start the application

Leave server running on the foreground `hypnotoad script/sdc -f`

Server log in `/tmp/mojolicious.log`.

Test the application by browsing to `https://hp-probook:9443`