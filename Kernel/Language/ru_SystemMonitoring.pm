# --
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'Основной почтовый интерфейс для System Monitoring Suites. Используйте этот блок, если фильтр должен выполняться ПОСЛЕ PostMasterFilter.';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Основной почтовый интерфейс для System Monitoring Suites. Используйте этот блок, если фильтр должен выполняться ДО PostMasterFilter.';
    $Self->{Translation}->{'Defines if closed tickets will be unlocked.'} = '';
    $Self->{Translation}->{'Icinga API URL.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = '';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = '';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Свяжите уже открытый инцидент с затронутым CI. Это возможно только в том случае, если приходит сообщение о последующей проверке электронной почты.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'Имя динамического поля для хоста.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'Имя динамического поля для службы.';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Автоматически задавать состояние инцидента для CI, когда приходит сообщение системы мониторинга.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'URL-адрес подтверждения HTTP.';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'Пароль подтверждения HTTP.';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'Пользователь с подтверждением HTTP.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = '';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Модуль события заявки для отправки подтверждения в Nagios.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
