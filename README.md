# A Perl Mojolicious Web and CLI application with WebSocket

Demonstrate a Perl Mojolicious echo-server application with websockets (=backend). 

Frontend is a html/javascript web client with SSL connection. 

Perl script client.pl demonstrates a CLI version how to connect to a websocket server.

# Code

Controler `example` is in package `lib\Sdc\Controller\Example.pm`.

## The mojolicious websocket 

### End point `echo`

This websocket end-point is in controller `example` :

`wss://hp-probook:9443/echo`

## The HTML webpage for communicating with the websocket backend Server

### The HTML webpage

The web page code is in template file `templates\example\client.html.ep`


Java script code in `public\js\ws.js`

### Configure SSL for hypnotoad

Config file `sdc.conf` contains hypnotoad configuration.

* Server name
Environment variable `MOJOSRV` is the hostname for the hypnotoad server.

* Certificate names

The self-signed ssl certificates can be found in the `ssl` directory and should be replaced with you own certicicates for testing purpose.

`ssl/${MOJOSRV}.cert.pem` and `ssl/${MOJOSRV}.key.pem`

# Start the web application

Start server in the backgrond `MOJOSRV=`hostname` hypnotoad script/sdc `

Server log in `/tmp/mojolicious.log`: `tail -f /tmp/mojolicious.log`

Test the application by browsing to `https://${MOJOSRV}:9443/client`

If you are interested in an Angular client for connecting to this websocket server, then check

`https://github.com/rlassche/ng6_websockets`

# Use the cli application

When the web application is running, you can start the CLI: `perl client.pl  'a message to send'`. 

A message will send to the server and result will be displayed.

Sample output:

```
$VAR1 = {
          'RETVAL' => 'OK',
          'DATA' => '{"hms":"19:08:54","text":"Send to the websocket"}'
        };
```
