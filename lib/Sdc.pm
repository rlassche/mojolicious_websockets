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

    $self->app->helper(
        VISUALDB => sub {
            return {
                DATABASE => new Database(
                    dsn       => $config->{visual_dsn},
                    user      => $config->{visual_user},
                    pass      => $config->{visual_password},
                    LOG4DB    => 1,
                    LOG_LEVEL => "FATAL",
                    LOG_CLASS => "testDatabase"
                )
            };
        }
    );

    $self->app->helper(
        MUZIEKDB => sub {
            return {
                DATABASE => new Database(
                    dsn       => $config->{muziek_dsn},
                    user      => $config->{muziek_user},
                    pass      => $config->{muziek_password},
                    LOG4DB    => 1,
                    LOG_LEVEL => "FATAL",
                    LOG_CLASS => "testDatabase"
                )
            };
        }
    );

    #  $self->app->hook(before_server_start => sub {
    #		my( $c ) =shift;
    #  	my ($server, $app) = @_;
    #  		$c->app->log->info('Sdc.startup.hook->before_server_start') ;
    #  });

    $self->app->hook(
        after_build_tx => sub {
            my ( $tx, $app ) = @_;
            $app->log->info('Sdc.startup.hook->after_build_tx');
        }
    );

    $self->app->hook(
        around_dispatch => sub {
            my ( $next, $c ) = @_;
            $c->app->log->info('Sdc.startup.hook->around_dispatch');
            return $next->();
        }
    );

    $self->app->hook(
        before_dispatch => sub {
            my $c = shift;
            $c->app->log->info('Sdc.startup.hook->before_dispatch');
        }
    );

    $self->app->hook(
        after_static => sub {
            my $c = shift;
            $c->app->log->info('Sdc.startup.hook->after_static');
        }
    );

    $self->app->hook(
        before_routes => sub {
            my ($c) = shift;
            $c->app->log->info('Sdc.startup.hook->before_routes');
        }
    );

    $self->app->hook(
        around_action => sub {
            my ( $next, $c, $action, $last ) = @_;
            $c->app->log->info('Sdc.startup.hook->around_action');
            return $next->();
        }
    );

    $self->app->hook(
        before_render => sub {
            my ( $c, $args ) = @_;
            $c->app->log->info('Sdc.startup.hook->before_render');
        }
    );

    $self->app->hook(
        after_render => sub {
            my ( $c, $output, $format ) = @_;
            $c->app->log->info('Sdc.startup.hook->after_render');
        }
    );

    $self->app->hook(
        after_dispatch => sub {
            my ($c) = @_;
            $c->app->log->info('Sdc.startup.hook->after_dispatch');
        }
    );

    $self->app->log->info('Sdc.startup: setup default routing');

    # Router
    my $r = $self->routes;

    # Normal route to the default controller (=lib/Sdc/Controller)
    $r->get('/')->to('example#welcome');

    $self->app->log->info('Sdc.startup: setup Muziek routing');

    # Add controller (=lib/Sdc/MuziekController)
    push @{ $r->namespaces }, 'Sdc::MuziekController';

    # Muziek controller: welcome
    $r->get('/muziek/artiest')->to('muziek#artiest');
    $r->get('/muziek/song')->to( controller => 'muziek', action => 'song' );
    $r->post('/muziek/song')
      ->to( controller => 'muziek', action => 'post_song' );

    $r->websocket('/echo')->to('example#echo');
    $r->get('/client')->to( controller => 'example', action => 'client' );

}

1;
