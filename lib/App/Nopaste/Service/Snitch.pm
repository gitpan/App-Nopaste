use strict;
use warnings;
package App::Nopaste::Service::Snitch;
{ our $VERSION = '1.002'; }
use base 'App::Nopaste::Service';

sub available {
    my $self = shift;
    my %args = @_;
    return !(exists($args{private}) && $args{private});
}

sub uri { "http://nopaste.snit.ch" }

1;
__END__

=pod

=head1 NAME

App::Nopaste::Service::Snitch - http://nopaste.snit.ch/

=head1 VERSION

version 1.002

=cut
