# --
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::SystemMonitoring::LinkTicketWithCI;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
);

our $DynamicFieldTicketTextPrefix  = 'TicketFreeText';
our $DynamicFieldArticleTextPrefix = 'ArticleFreeText';

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    $Self->_BasicModulesInit();

    # Default Settings
    $Self->{Config} = {
        FromAddressRegExp => 'sysmon@example.com',
        FreeTextHost      => '1',
        FreeTextService   => '2',
        FreeTextState     => '1',
        StateRegExp       => '\s*State:\s+(\S+)',
        HostRegExp        => '\s*Address:\s+(\d+\.\d+\.\d+\.\d+)\s*',
        ServiceRegExp     => '\s*Service:\s+(.*)\s*',
    };

    # get communication log object and MessageID
    if ( !defined $Param{CommuncationLogRequired} || $Param{CommuncationLogRequired} ) {
        $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
        Value         => 'Start SystemMonitoringLinkTicketWithCI Filter',
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    return 1 if !$ConfigObject->Get('SystemMonitoring::LinkTicketWithCI');

    # get config options, use defaults unless value specified
    if ( $Param{JobConfig} && ref $Param{JobConfig} eq 'HASH' ) {
        KEY:
        for my $Key ( keys( %{ $Param{JobConfig} } ) ) {
            next KEY if !$Self->{Config}->{$Key};
            $Self->{Config}->{$Key} = $Param{JobConfig}->{$Key};
        }
    }

    # check if sender is of interest
    return 1 if !$Param{GetParam}->{From};
    return 1 if $Param{GetParam}->{From} !~ /$Self->{Config}->{FromAddressRegExp}/i;

    $Self->_MailParse(%Param);

    # we need State and Host to proceed
    if ( !$Self->{State} || !$Self->{Host} ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
            Value         => 'SystemMonitoring Mail: '
                . 'SystemMonitoring: Could not find host address '
                . 'and/or state in mail => Ignoring',
        );

        return 1;
    }

    my $TicketID = $Self->_TicketSearch();
    return 1 if !$TicketID;

    # link ticket with CI
    $Self->_LinkTicketWithCI(
        Name     => $Self->{Host},
        TicketID => $TicketID,
    );

    return 1;
}

# these are optional modules from the ITSM Kernel::System::GeneralCatalog and Kernel::System::ITSMConfigItem

sub _BasicModulesInit {
    my ( $Self, %Param ) = @_;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # require the general catalog module
    if ( $MainObject->Require( 'Kernel::System::GeneralCatalog', Silent => 1 ) ) {

        # create general catalog object
        $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    }

    # require the config item module
    if ( $MainObject->Require( 'Kernel::System::ITSMConfigItem', Silent => 1 ) ) {

        # create config item object
        $Self->{ConfigItemObject} = Kernel::System::ITSMConfigItem->new( %{$Self} );
    }

    return 1;
}

sub _MailParse {
    my ( $Self, %Param ) = @_;

    if ( !$Param{GetParam} || !$Param{GetParam}->{Subject} ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
            Value         => "Need Subject!",
        );

        return;
    }

    my $Subject = $Param{GetParam}->{Subject};

    # Try to get State, Host and Service from email subject
    my @SubjectLines = split /\n/, $Subject;
    for my $Line (@SubjectLines) {
        for my $Item (qw(State Host Service)) {
            if ( $Line =~ /$Self->{Config}->{ $Item . 'RegExp' }/ ) {
                $Self->{$Item} = $1;
            }
        }
    }

    #  Don't Try to get State, Host and Service from email body, we want it from the subject alone

    # split the body into separate lines
    if ( !$Param{GetParam}->{Body} ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
            Value         => "Need Body!",
        );

        return;
    }
    my $Body = $Param{GetParam}->{Body};

    my @BodyLines = split /\n/, $Body;

    # to remember if an element was found before
    my %AlreadyMatched;

    LINE:
    for my $Line (@BodyLines) {

        # Try to get State, Host and Service from email body
        ELEMENT:
        for my $Element (qw(State Host Service)) {

            next ELEMENT if $AlreadyMatched{$Element};

            my $Regex = $Self->{Config}->{ $Element . 'RegExp' };

            if ( $Line =~ /$Regex/ ) {

                # get the found element value
                $Self->{$Element} = $1;

                # remember that we found this element already
                $AlreadyMatched{$Element} = 1;
            }
        }
    }

    return 1;
}

sub _TicketSearch {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

    # Check if dynamic fields really exists.
    # If dynamic fields don't exists, TicketSearch will return all tickets
    # and then the new article/ticket could take wrong place.
    # The lesser of the three evils is to create a new ticket
    # instead of defacing existing tickets or dropping it.
    # This behavior will come true if the dynamic fields
    # are named like TicketFreeTextHost. Its also bad.
    my $Errors = 0;
    for my $Type (qw(Host Service)) {
        my $FreeTextField = $Self->{Config}->{ 'FreeText' . $Type };

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicFieldTicketTextPrefix . $FreeTextField,
        );

        if ( !IsHashRefWithData($DynamicField) || $FreeTextField !~ m{\d+}xms ) {

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
                Value         => "DynamicField "
                    . $DynamicFieldTicketTextPrefix
                    . $FreeTextField
                    . " does not exists or misnamed."
                    . " The configuration is based on Dynamic fields, so the number of the dynamic field is expected"
                    . " (wrong value for dynamic field FreeText" . $Type . " is set).",
            );

            $Errors = 1;
        }
    }

    my $ArticleFreeTextField = $Self->{Config}->{'FreeTextState'};
    my $DynamicFieldArticle  = $DynamicFieldObject->DynamicFieldGet(
        Name => $DynamicFieldArticleTextPrefix . $ArticleFreeTextField,
    );

    if ( !IsHashRefWithData($DynamicFieldArticle) || $ArticleFreeTextField !~ m{\d+}xms ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
            Value         => "DynamicField "
                . $DynamicFieldArticleTextPrefix
                . $ArticleFreeTextField
                . " does not exists or misnamed."
                . " The configuration is based on dynamic fields, so the number of the dynamic field is expected"
                . " (wrong value for dynamic field FreeTextState is set).",
        );

        $Errors = 1;
    }

    # Is there a ticket for this Host/Service pair?
    my %Query = (
        Result    => 'ARRAY',
        Limit     => 1,
        UserID    => 1,
        StateType => 'Open',
    );

    for my $Type (qw(Host Service)) {
        my $FreeTextField = $Self->{Config}->{ 'FreeText' . $Type };
        my $KeyName       = "DynamicField_" . $DynamicFieldTicketTextPrefix . $FreeTextField;
        my $KeyValue      = $Self->{$Type};

        $Query{$KeyName}->{Equals} = $KeyValue;
    }

    my @TicketIDs = $TicketObject->TicketSearch(%Query);

    # get the first and only ticket id
    my $TicketID;
    if ( !$Errors && @TicketIDs ) {
        $TicketID = shift @TicketIDs;
    }

    return $TicketID;
}

sub _LinkTicketWithCI {
    my ( $Self, %Param ) = @_;

    NEEDED:
    for my $Needed (qw(Name TicketID)) {

        next NEEDED if defined $Param{$Needed};

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
            Value         => "Need $Needed",
        );

        return;
    }

    # check configitem object
    return if !$Self->{ConfigItemObject};

    # search configitem
    my $ConfigItemIDs = $Self->{ConfigItemObject}->ConfigItemSearchExtended(
        Name => $Param{Name},
    );

    # if no config item with this name was found
    if ( !$ConfigItemIDs || ref $ConfigItemIDs ne 'ARRAY' || !@{$ConfigItemIDs} ) {

        # log error
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
            Value         => "Could not find any CI with the name '$Param{Name}'. ",
        );

        return;
    }

    # if more than one config item with this name was found
    if ( scalar @{$ConfigItemIDs} > 1 ) {

        # log error
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoringLinkTicketWithCI',
            Value         => "Can not set incident state for CI with the name '$Param{Name}'. "
                . "More than one CI with this name was found!",
        );

        return;
    }

    # we only found one config item
    my $ConfigItemID = shift @{$ConfigItemIDs};

    # link the ticket with the CI
    my $LinkResult = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => $Param{TicketID},
        TargetObject => 'ITSMConfigItem',
        TargetKey    => $ConfigItemID,
        Type         => 'RelevantTo',
        State        => 'Valid',
        UserID       => 1,
    );

    return $LinkResult;
}

1;
