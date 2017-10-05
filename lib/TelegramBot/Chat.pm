#!/usr/bin/perl

package TelegramBot::Chat;

use strict;

use Data::Dumper;
use LWP::UserAgent;
use JSON qw( decode_json );

sub new
{
    my $type    = shift;
    my %params  = @_;

    my $class   = ref($type) || $type || "TelegramBot::Chat";
    my $this    = {};

    bless $this, $class;
    return $this;
}

sub initiate
{
    my $this    = shift;
    my %params  = @_;
    my $token   = $params{ token } or die "Missing parameter : token\n";

    my $request = decode_json( $this->request(token => $token, type => 'getUpdates') );
    $request or die "Cannot get request ", $request;

    $this->{ token } = $token;
    $this->{ chat } = $request->{ result }[0]->{ message }->{ chat };

    return $this;
}

sub set
{
    my $this    = shift;
    my %params  = @_;
    my $name    = $params{ name } or die "Missing parameter : name\n";
    my $value   = $params{ value } or die "Missing parameter : value\n";

    $this->{ $name } = $value;
    return $this;
}

sub get
{
    my $this    = shift;
    my %params  = @_;
    my $name    = $params{ name } or die "Missing parameter : name\n";

    return $this->{ $name };
}

sub request
{
    my $this    = shift;
    my %params  = @_;
    my $type    = $params{ type } or die "Missing parameter : type\n";
    my $text    = $params{ text };

    my $token;
    if (not $this->{ token })
    {
        $token  = $params{ token } or die "Missing parameter : token\n";
    }
    else
    {
        $token  = $this->{ token };
    }
   
    my $url = 'https://api.telegram.org/bot'. $token .'/'. $type;

    $this->{ chat }->{ id } and $url .= '?chat_id='. $this->{ chat }->{ id };
    $text and $url .= '&text='. $text;

    my $ua = LWP::UserAgent->new;
    my $request = HTTP::Request->new(GET => $url);
    my $response = $ua->request($request) or die;

    return $response->decoded_content;
}

sub sendMessage
{
    my $this = shift;
    my %params = @_;
    my $text  = $params{ text } or die "Missing parameter : text\n";

    my $request = $this->request( type => 'sendMessage', text => $text ); 

    return $request;
}

1;
