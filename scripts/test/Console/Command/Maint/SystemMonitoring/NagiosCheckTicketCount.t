# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2022 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject
    = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::SystemMonitoring::NagiosCheckTicketCount');

my $ConfigFile = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/test/sample/NagiosCheckTesting.pm';

my $ExitCode = $CommandObject->Execute( '--config-file', $ConfigFile, '--as-checker', );

$Self->Is(
    $ExitCode,
    0,
    "Maint::SystemMonitoring::NagiosCheckTicketCount exit code",
);

1;
