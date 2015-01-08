use strict;
use warnings;
package App::Nopaste::Service::Shadowcat;
{ our $VERSION = '0.99'; }
use base 'App::Nopaste::Service';

sub available {
    my $self = shift;
    my %args = @_;
    return !(exists($args{private}) && $args{private});
}

sub uri { "http://paste.scsys.co.uk" }

1;
__END__

=pod

=head1 NAME

App::Nopaste::Service::Shadowcat - http://paste.scsys.co.uk/

=head1 VERSION

version 0.99

=cut
