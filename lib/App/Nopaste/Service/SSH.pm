package App::Nopaste::Service::ssh;
use strict;
use warnings;
use base 'App::Nopaste::Service';
use File::Temp;
use File::Spec;
use POSIX qw(strftime);

sub run {
    my ($self, %args) = @_;

    my $server = $ENV{NOPASTE_SSH_SERVER} || return (0,"No NOPASTE_SSH_SERVER set");
    my $docroot = $ENV{NOPASTE_SSH_DOCROOT} || return (0, "No NOPASTE_SSH_DOCROOT set");
    my $topurl = $ENV{NOPASTE_SSH_WEBPATH} || "http://$server";

    my $date = strftime("%Y-%m-%d",localtime());
    my $tmp = File::Temp->new( TEMPLATE => "${date}XXXXXXXX", CLEANUP => 1 );
    my $filename = $tmp->filename;
    print $tmp $args{text} || return (0, "Can't write to tempfile $filename");
    close $tmp || return (0, "Can't write to tempfile $filename");

    system('scp', '-q', $filename, "$server:$docroot");

    my ($volume, $dir, $file) = File::Spec->splitpath($filename);
    return (1, "$topurl/$file");

}

1;

=head1 NAME

App::Nopaste::Service::SSH - copies files to your server using scp

=head1 AUTHOR

Kevin Falcone << <falcone@cpan.org> >>

=head1 ENVIRONMENT VARIABLES

=over 4

=item NOPASTE_SSH_SERVER

The hostname to which you ssh. The left-hand side of the colon in the scp.
Something like C<sartak.org>.

=item NOPASTE_SSH_DOCROOT

The path on disk for your pastes. Something like C<public_html/paste>

=item NOPASTE_SSH_WEBPATH

The path for URLs. Something like C<http://sartak.org/paste>

=back

=cut

