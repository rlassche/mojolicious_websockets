package Sdc::MuziekController::Muziek;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

# This action will render a template
sub welcome {
    my $self = shift;

    $self->app->log->info('MuziekController::Muziek.welcome');

    # Render template "muziek/welcome.html.ep" with message
    $self->render( msg => 'Welcome to the Muziek controler, action=welcome!' );
}

sub artiest {
    my $self = shift;

    $self->app->log->info('MuziekController::Muziek.artiest');
    $self->app->log->info(
        'Sdc::MuziekController::Muziek.artiest: Helper MUZIEKDB:'
          . Dumper( $self->MUZIEKDB ) );

    # Render template "muziek/artiest.html.ep" with message
    $self->render( msg => 'Welcome to the MuziekControler, action=artiest!' );
}

sub song {
    my $self = shift;

    $self->app->log->info('MuziekController::Muziek.song');

    # Render template "muziek/song.html.ep" with message
    $self->render(
        template => 'muziek/song',
        msg      => 'Welcome to the MuziekControler, action=song!'
    );
}

sub post_song {
    my $self = shift;

    $self->app->log->info('MuziekController::Muziek.post_song');

    # Render template "muziek/post_song.html.ep" with message
    $self->render(
        template => 'muziek/post_song',
        msg      => 'Welcome to the MuziekControler, action=post_song!'
    );
}

1;
