#!perl
package App::Nopaste;
use strict;
use warnings;
use Module::Pluggable search_path => 'App::Nopaste::Service';

use base 'Exporter';
our @EXPORT_OK = 'nopaste';

sub nopaste {
    # process arguments {{{
    # allow "nopaste($text)"
    unshift @_, 'text' if @_ == 1;

    # only look for $self if we have odd number of arguments
    my $self;
    $self = @_ % 2 ? shift : __PACKAGE__;

    # everything else
    my %args = @_;

    $args{services} = defined($ENV{NOPASTE_SERVICES})
                   && [split ' ', $ENV{NOPASTE_SERVICES}]
                        if !exists($args{services});

    $args{nick} = $ENV{NOPASTE_NICK} || $ENV{USER}
        if !exists($args{nick});


    unless (ref($args{services}) eq 'ARRAY' && @{$args{services}}) {
        $args{services} = [ $self->plugins ];
    }

    @{ $args{services} }
        or Carp::croak "No App::Nopaste::Service module found";

    defined $args{text}
        or Carp::croak "You must specify the text to nopaste";

    $args{error_handler} ||= sub { warn "$_[1]: $_[0]" };
    # }}}
    # try to paste to each service in order {{{
    for my $service (@{ $args{services} }) {
        $service = "App::Nopaste::Service::$service"
            unless $service =~ /^App::Nopaste::Service/;

        my @ret = eval {
            (my $file = "$service.pm") =~ s{::}{/}g;
            require $file;
            $service->nopaste(%args);
        };

        @ret = (0, $@) if $@;

        # success!
        return $ret[1] if $ret[0];

        # failure!
        $args{error_handler}->($ret[1], $service);
    }
    # }}}

    return undef;
}

=head1 NAME

App::Nopaste - easy access to any pastebin

=head1 VERSION

Version 0.03 released 06 May 08

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

    use App::Nopaste 'nopaste';

    my $url = nopaste(q{
        perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' [number]
    });

    # or on the command line:
    nopaste test.pl
    => http://pastebin.com/fcba51f

=head1 DESCRIPTION

Pastebins (also known as nopaste sites) let you post text, usually code, for
public viewing. They're used a lot in IRC channels to show code that would
normally be too long to give directly in the channel (hence the name nopaste).

Each pastebin is slightly different. When one pastebin goes down (I'm looking
at you, L<http://paste.husk.org>), then you have to find a new one. And if you
usually use a script to publish text, then it's too much hassle.

This module aims to smooth out the differences between pastebins, and provides
redundancy: if one site doesn't work, it just tries a different one.

It's also modular: you only need to put on CPAN a
L<App::Nopaste::Service::Foo> module and anyone can begin using it.

=head1 INTERFACE

=head2 CLI

The command line interface is a currently razor thin wrapper around
C<App::Nopaste>.

In the usual Perl manner, you can pass text in via STDIN or through named files
as arguments. Multiple files will be concatenated into one paste (this may
change in the future).

It prints on STDOUT the paste URI - if one was available. It warns on STDERR
any errors that occur.

=head2 C<nopaste>

    use App::Nopaste 'nopaste';

    my $url = nopaste(
        text => "Full text to paste (the only mandatory argument)",
        desc => "A short description of the paste",
        nick => "Your nickname",
        lang => "perl",
        chan => "#moose",

        # this is the default, but maybe you want to do something different
        error_handler => sub {
            my ($error, $service) = @_;
            warn "$service: $error";
        },

        # you may specify the services to use - but you don't have to
        services => ["Rafb", "Husk"],
    );

    print $url if $url;

The C<nopaste> function will return the URL of the paste on
success, or C<undef> on failure.

For each failure, the C<error_handler> argument is invoked with the error
message and the service that issued it.

=head1 SEE ALSO

L<WebService::NoPaste>, L<WWW::PastebinCom::Create>, L<WWW::Rafb::Create>, L<Devel::REPL::Plugin::Nopaste>

=head1 AUTHOR

Shawn M Moore, C<< <sartak at gmail.com> >>

=head1 BUGS

Please report any bugs through RT: email
C<bug-app-nopaste at rt.cpan.org>, or browse
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Nopaste>.

=head1 COPYRIGHT AND LICENSE

Copyright 2008 Shawn M Moore.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

