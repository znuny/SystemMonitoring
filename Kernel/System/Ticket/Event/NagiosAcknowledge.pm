# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Event::NagiosAcknowledge;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::User',
);

use LWP::UserAgent;
use URI::Escape qw();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get correct FreeFields
    $Self->{Fhost}    = $ConfigObject->Get('Nagios::Acknowledge::FreeField::Host');
    $Self->{Fservice} = $ConfigObject->Get('Nagios::Acknowledge::FreeField::Service');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Data->{TicketID}!",
        );

        return;
    }

    # Check if acknowledge is active.
    my $Enabled = $Kernel::OM->Get('Kernel::Config')->Get('Nagios::Acknowledge::Enabled');

    return 1 if !$Enabled;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check if it's a Nagios related ticket
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 1,
    );
    if ( !$Ticket{ $Self->{Fhost} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "No Nagios Ticket!",
        );

        return 1;
    }

    # check if it's an acknowledge
    return 1 if $Ticket{Lock} ne 'lock';

    # agent lookup
    my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        UserID => $Param{UserID},
        Cached => 1,                # not required -> 0|1 (default 0)
    );

    my $Return = $Self->_HTTP(
        Ticket => \%Ticket,
        User   => \%User,
    );

    if ($Return) {
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            HistoryType  => 'Misc',
            Name         => "Sent Acknowledge to Nagios (http).",
            CreateUserID => $Param{UserID},
        );

        return 1;
    }
    else {
        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            HistoryType  => 'Misc',
            Name         => "Was not able to send Acknowledge to Nagios (http)!",
            CreateUserID => $Param{UserID},
        );

        return;
    }
}

sub _HTTP {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Ticket User)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }
    my %Ticket = %{ $Param{Ticket} };
    my %User   = %{ $Param{User} };

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $URL  = $ConfigObject->Get('Nagios::Acknowledge::HTTP::URL');
    my $User = $ConfigObject->Get('Nagios::Acknowledge::HTTP::User');
    my $Pw   = $ConfigObject->Get('Nagios::Acknowledge::HTTP::Password');

    if ( $Ticket{ $Self->{Fservice} } !~ /^host$/i ) {
        $URL =~ s/<CMD_TYP>/34/g;
    }
    else {
        $URL =~ s/<CMD_TYP>/33/g;
    }

    # replace host
    $URL =~ s/<HOST_NAME>/$Ticket{$Self->{Fhost}}/g;

    # replace time stamp
    $URL =~ s/<SERVICE_NAME>/$Ticket{$Self->{Fservice}}/g;

    # replace ticket tags
    TICKET:
    for my $Key ( sort keys %Ticket ) {
        next TICKET if !defined $Ticket{$Key};

        # URLencode values
        $Ticket{$Key} = URI::Escape::uri_escape_utf8( $Ticket{$Key} );
        $URL =~ s/<$Key>/$Ticket{$Key}/g;
    }

    # replace config tags
    $URL =~ s{<CONFIG_(.+?)>}{$Kernel::OM->Get('Kernel::Config')->Get($1)}egx;

    my $UserAgent = LWP::UserAgent->new();
    $UserAgent->timeout(15);

    my $Request = HTTP::Request->new( GET => $URL );
    $Request->authorization_basic( $User, $Pw );
    my $Response = $UserAgent->request($Request);
    if ( !$Response->is_success() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't request $URL: " . $Response->status_line(),
        );

        return;
    }

    #    return $Response->content();
    return 1;
}
1;
