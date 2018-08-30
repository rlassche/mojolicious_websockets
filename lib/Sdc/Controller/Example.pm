package Sdc::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use DateTime;

# This action will render a template
sub welcome {
    my $self = shift;

    $self->app->log->info('Controller::Example.welcome');
    $self->app->log->info( 'Sdc::Controller::Example.welcome: Helper VISUALDB:'
          . Dumper( $self->VISUALDB ) );

    # Render template "example/welcome.html.ep" with message
    $self->render( msg => 'Default Controller', msg2 => 'Muziek Controller' );
}

# The websocket  server
sub echo {
    my $self = shift;
    $self->on(
        message => sub {
            my ( $self, $msg ) = @_;
            $self->app->log->info( 'Controller::Example.echo on: msg=' . $msg );
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

# Websocket client
sub client {
    my $self = shift;

    $self->app->log->info('Controller::Example.client');

    # Render template "example/client.html.ep" with message
    $self->render( msg => 'Websocket client' );
}
1;
