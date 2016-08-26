=encoding UTF-8

=head1 NAME

Acme::IsItJSON - Is my variable JSON or a Perl data structure?

=head1 SYNOPSIS

    use Acme::IsItJSON 'is_it_json';
    my $json = '{"zilog":"z80"}';
    is_it_json ($json);
    my $perl = {zilog => 'z80'};
    is_it_json ($json);

=head1 DESCRIPTION

Not sure if your variable is a Perl data structure or a JSON string?

This Perl module can help.

=head1 FUNCTIONS

=head2 is_it_json

Given a variable containing something which you are not sure about,
and it may or may not be JSON or a Perl data structure, feed it to
this routine. This module uses support vector machines running on an
OCAML cluster backed up by a Node pipeline in an S3 cloud to
distinguish JSON from Perl data structures.

=cut

package Acme::IsItJSON;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/is_it_json/;
%EXPORT_TAGS = (
    all => \@EXPORT_OK,
);
use warnings;
use strict;
use Carp;
use JSON::Parse qw/parse_json valid_json/;
use JSON::Create 'create_json';
our $VERSION = '0.01';

my @responses = (
    "That seems to be {X}.",
    "That might be {X}.",
    "I'm not sure whether that is {X}.",
    "It could be {X}.",
    "OK, it's definitely {X}. Maybe.",
);

sub babble
{
    my ($what) = @_;
    my $response = $responses[int (rand (scalar (@responses)))];
    $response =~ s/\{X\}/$what/;
    if (rand (2) > 1) {
	$response = create_json ($response);
    }
    print "$response\n";
}

sub is_it_json
{
    my ($input) = @_;
    if (valid_json ($input)) {
	babble ('JSON');
    }
    else {
	babble ('a Perl data structure');
    }
}

1;
