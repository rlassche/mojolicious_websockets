use AnyEvent;
use AnyEvent::WebSocket::Client 0.12;
use Log::Log4perl;
use Data::Dumper;
Log::Log4perl::init('/usr/lib/cgi-bin/log4perl.conf');
my $logger = Log::Log4perl->get_logger();

sub SendMsg2Websocket {
    my ($params) = @_;


    # The message to send to the websocket server
    my $toSend       = $params->{MESSAGE};

    # The condition
    my $result_ready = AnyEvent->condvar;

    my $client = AnyEvent::WebSocket::Client->new();
    # Ignore SSL errors
    $client->{ssl_no_verify} = 1;

    # The Websocket response
    my $result;

    $client->connect("wss://hp-probook:9443/echo")->cb(
        sub {

            # make $connection an our variable rather than
            # my so that it will stick around.  Once the
            # connection falls out of scope any callbacks
            # tied to it will be destroyed.
            our $connection = eval { shift->recv };
            if ($@) {

                # handle error...
                warn $@;
                return;
            }

            # send a message through the websocket...
            $connection->send($toSend);

            # recieve message from the websocket...
            $connection->on(
                each_message => sub {
                    # $connection is the same connection object
                    # $message isa AnyEvent::WebSocket::Message
                    my ( $connection, $message ) = @_;

					# Get the message in the variable result
					$result = $message;

                    # Mark the AnyEvent condition that we are ready.
                    $result_ready->send($message);
                }
            );

            # handle a closed connection...
            $connection->on(
                finish => sub {

                    # $connection is the same connection object
                    my ($connection) = @_;
                    $logger->info("finish ");
                }
            );

        }
    );

    $logger->info("hi from perl");

    # Wait the the websocket to receive our message and return a response
    $result_ready->recv;

    # The AnyEvent puts the result in global variable $result
    return { RETVAL => "OK", DATA => $result->body };
}

# Send a message to the websocket and wait for the response send by the server
my $rv = SendMsg2Websocket( { MESSAGE => 'Send to the websocket' } );
print Dumper($rv);
