# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'Основен интерфейс за поща към системния мониторинг. Използвайте този блок, ако филтърът трябва да се изпълнява СЛЕД Филтърът за пощенска администрация';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Основен интерфейс за поща към системния мониторинг. Използвайте този блок, ако филтърът трябва да се изпълнява ПРЕДИ Филтърът за пощенска администрация.';
    $Self->{Translation}->{'Define Nagios acknowledge type.'} = 'Определете типа признаване на Nagios.';
    $Self->{Translation}->{'HTTP'} = '';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Свържете вече отворен билет за инцидент със засегнатия CI. Това е възможно само при пристигането на последващ имейл за наблюдение на системата.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'Име на динамичното поле за хост.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'Име на динамичното поле за обслужване.';
    $Self->{Translation}->{'Named pipe acknowledge command.'} = 'Команда за потвърждаване на име pipe.';
    $Self->{Translation}->{'Named pipe acknowledge format for host.'} = '';
    $Self->{Translation}->{'Named pipe acknowledge format for service.'} = '';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Настройте инцидентното състояние на CI автоматично, когато пристигне имейл за мониторинг на системата.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = '';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = '';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = '';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = '';
    $Self->{Translation}->{'pipe'} = '';

}

1;