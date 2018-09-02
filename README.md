# A Perl Mojolicious application with WebSocket

Demonstrate a Perl Mojolicious echo server application with websockets (=backend). 

Frontend is a html/javascript web client with SSL connection. 

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

Check config file `sdc.conf`.

My self-signed ssl certificates can be found in the `ssl` directory and should be replaced with you own certicicates for testing purpose.

# Start the application

Leave server running on the foreground `hypnotoad script/sdc -f`

Server log in `/tmp/mojolicious.log`: `tail -f /tmp/mojolicious.log`

Test the application by browsing to `https://hp-probook:9443/client`

If you are interested in an Angular client for connecting to this websocket server, then check

`https://github.com/rlassche/ng6_websockets`