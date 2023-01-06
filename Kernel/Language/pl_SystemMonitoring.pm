# --
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'Podstawowy interfejs e-mailowy dla Systemów Monitorujących. Użyj tego bloku, jeśli filtr powinien się wykonać PO PostMasterFilter.';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Podstawowy interfejs e-mailowy dla Systemów Monitorujących. Użyj tego bloku, jeśli filtr powinien się wykonać PRZED PostMasterFilter.';
    $Self->{Translation}->{'Defines if closed tickets will be unlocked.'} = '';
    $Self->{Translation}->{'Icinga API URL.'} = 'URL do API Icinga.';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = 'Autor potwierdzenia Icinga2.';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = 'Komentarz do potwierdzenia Icinga2.';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = 'Czy potwierdzenia Icinga2 są włączone?';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = 'Powiadomienie potwierdzenia Icinga2.';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = 'Przyklejone potwierdzenie Icinga2.';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Połącz już otwarte zgłoszenie zdarzenia z dotyczącym go CI. Jest to możliwe wtedy, gdy nadejdzie kolejny email z systemu monitorującego.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'Nazwa pola dynamicznego dla hosta.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'Nazwa pola dynamicznego dla Usługi.';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Ustaw automatycznie stan zdarzenia dla CI, gdy nadejdzie e-mail z monitoringu.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'URL HTTP dlo potwierdzeń.';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'Hasło HTTP dla potwierdzeń.';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'Użytkownik HTTP dla potwierdzeń.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = 'Nazwa modułu obsługi zdarzeń zgłoszenia do wysyłki potwierdzeń Icinga2.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Nazwa modułu obsługi zgłoszenia do wysyłki potwierdzeń do Nagiosa.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
