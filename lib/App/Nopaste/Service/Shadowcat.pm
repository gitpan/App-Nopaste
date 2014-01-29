use strict;
use warnings;
package App::Nopaste::Service::Shadowcat;
BEGIN {
  $App::Nopaste::Service::Shadowcat::AUTHORITY = 'cpan:SARTAK';
}
$App::Nopaste::Service::Shadowcat::VERSION = '0.96';
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

version 0.96

=cut
