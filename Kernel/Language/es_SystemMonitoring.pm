# --
# Copyright (C) 2012-2022 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_SystemMonitoring;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run AFTER PostMasterFilter.'} =
        'Interfaz de correo básico para el System Monitoring Suites. Utilice este bloque si el filtro debe funcionar DESPUÉS del PostMasterFilter.';
    $Self->{Translation}->{'Basic mail interface to System Monitoring Suites. Use this block if the filter should run BEFORE PostMasterFilter.'} =
        'Interfaz de correo básico para el System Monitoring Suites. Utilice este bloque si el filtro debe funcionar ANTES del PostMasterFilter.';
    $Self->{Translation}->{'Defines if closed tickets will be unlocked.'} = '';
    $Self->{Translation}->{'Icinga API URL.'} = 'Icinga API URL.';
    $Self->{Translation}->{'Icinga2 acknowledgement author.'} = 'Icinga2 autor de reconocimiento.';
    $Self->{Translation}->{'Icinga2 acknowledgement comment.'} = 'Icinga2 comentario de reconocimiento.';
    $Self->{Translation}->{'Icinga2 acknowledgement enabled?'} = 'Icinga2  ¿Reconocimiento habilitado?';
    $Self->{Translation}->{'Icinga2 acknowledgement notify.'} = 'Icinga2 notificación de reconocimiento.';
    $Self->{Translation}->{'Icinga2 acknowledgement sticky.'} = 'Icinga2 adhesivo de reconocimiento.';
    $Self->{Translation}->{'Link an already opened incident ticket with the affected CI. This is only possible when a subsequent system monitoring email arrives.'} =
        'Enlace un ticket de incidente ya abierto con el CI afectado. Esto sólo es posible cuando llega un correo electrónico de seguimiento del sistema posterior.';
    $Self->{Translation}->{'Name of the Dynamic Field for Host.'} = 'Nombre del campo dinámico para el host.';
    $Self->{Translation}->{'Name of the Dynamic Field for Service.'} = 'Nombre del campo dinámico para el servicio.';
    $Self->{Translation}->{'Set the incident state of a CI automatically when a system monitoring email arrives.'} =
        'Establezca el estado de incidencia de un CI automáticamente cuando llegue un correo electrónico de supervisión del sistema.';
    $Self->{Translation}->{'The HTTP acknowledge URL.'} = 'El HTTP reconoce la URL.';
    $Self->{Translation}->{'The HTTP acknowledge password.'} = 'El HTTP reconoce la contraseña.';
    $Self->{Translation}->{'The HTTP acknowledge user.'} = 'El HTTP reconoce al usuario.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Icinga2.'} = 'Módulo de evento de ticket para enviar un reconocimiento a Icinga2.';
    $Self->{Translation}->{'Ticket event module to send an acknowledge to Nagios.'} = 'Modulo de Ticket de eventos para enviar un reconocimiento a Nagios.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
