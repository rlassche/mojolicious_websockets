package Sdc;
use Mojo::Base 'Mojolicious';

#use Mojolicious::Lite;
use Data::Dumper;
use Database;

# This method will run once at server start
sub startup {
    my $self = shift;

    # Logging to a file!
    $self->app->log(
        Mojo::Log->new( path => '/tmp/mojolicious.log', level => 'info' ) );
    $self->app->log->info('Sdc.startup');

    # Load configuration from hash returned by "my_app.conf"
    my $config = $self->plugin('Config');

    $self->app->log->info( 'Sdc.startup config:' . Dumper($config) );

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer') if $config->{perldoc};


    $self->app->log->info('Sdc.startup: setup default routing');

    # Router
    my $r = $self->routes;

    # Normal route to the default controller (=lib/Sdc/Controller)
    $r->get('/')->to('example#welcome');

    $r->websocket('/echo')->to('example#echo');
    $r->get('/client')->to( controller => 'example', action => 'client' );

}

1;
