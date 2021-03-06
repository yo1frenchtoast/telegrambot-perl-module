#!/usr/bin/perl

use strict;

use Data::Dumper;
use Getopt::Long;

use lib 'lib';
use TelegramBot::Chat;

main();

sub main
{
    my ($token, $text);
    GetOptions(
        "token|to=s"    => \$token,
        "text|te=s"     => \$text
    );
    if (not $token)
    {
        die "Missing argument : token\n\n\tUsage : $0 --token=<token> (--text=<text to send>)\n\n";
    }

    my $chat = TelegramBot::Chat->new();

    $chat->initiate(token => $token);
    $chat or die "Error while initiating chat", $chat;

    print "Success ! chat_id : $chat->{ chat }->{ id }\n";

    if ($text)
    {
        my $send = $chat->sendMessage(text => $text);
        not $send and die "Error while sending message", $send;
    }

    return;
}
