package Sdc::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use DateTime;

my $clients = {};

# This action will render a template
sub welcome {
    my $self = shift;

    $self->app->log->info('Controller::Example.welcome');

    # Render template "example/welcome.html.ep" with message
    $self->render( msg => 'Default Controller', msg2 => 'Websocket client' );
}

# The websocket  server
sub echo {
    my $self = shift;
    my $id = sprintf "%s", $self->tx;
    $clients->{$id} = $self->tx;

    # Increase inactivity timeout for connection a bit
    $self->inactivity_timeout(300);

    $self->app->log->info( sprintf 'Client connected: %s', $id );

    #$self->app->log->info("CONNECT $id");

    $self->on(
        message => sub {
            my ( $self, $msg ) = @_;
            my $id = sprintf "%s", $self->tx;

            if ( length($msg) > 0 ) {
                $self->app->log->info( "client $id, msg=->" . $msg . '<-' );
                my $dt = DateTime->now( time_zone => 'Europe/Amsterdam' );
                for ( keys %$clients ) {
                    $id = sprintf "%s", $_;
                    $self->app->log->info("Sending to client ($id)");

                    $clients->{$_}->send(
                        {
                            json => {
                                hms  => $dt->hms,
                                text => $msg
                            }
                        }
                    );
                }
            }
            else {
                #$self->app->log->info( "Ping");
            }
        }
    );
    $self->on(
        finish => sub {
            my $id = sprintf "%s", $self->tx;
            $self->app->log->debug("Client disconnected: $id");
            delete $clients->{ $self->tx };
        }
    );

}

# Websocket client
sub client {
    my $self = shift;

    $self->app->log->info('client');

    # Render template "example/client.html.ep" with message
    $self->render( msg => 'Websocket client' );
}
1;
