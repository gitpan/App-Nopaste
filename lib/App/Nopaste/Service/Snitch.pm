use strict;
use warnings;
package App::Nopaste::Service::Snitch;
BEGIN {
  $App::Nopaste::Service::Snitch::AUTHORITY = 'cpan:SARTAK';
}
$App::Nopaste::Service::Snitch::VERSION = '0.95';
use base 'App::Nopaste::Service';

sub available {
    my $self = shift;
    my %args = @_;
    return !(exists($args{private}) && $args{private});
}

sub uri { "http://nopaste.snit.ch" }

1;

__END__

=head1 NAME

App::Nopaste::Service::Snitch - http://nopaste.snit.ch/

=cut

