# Funktionalität

Dieses Modul implementiert eine grundlegende Schnittstelle zu System Monitoring Anwendung.

Bei Nagios erfolgt dies durch den Empfang von E-Mail-Nachrichten, die von einer Network
Monitoring Anwendung gesendet werden. Bei Komponentenausfällen werden neue Tickets erstellt.
Sobald ein Ticket eröffnet wurde, werden Nachrichten bezüglich der betroffenen Komponente
diesem Ticket angehängt. Wenn die Komponente wieder funktionsfähig ist, kann der Ticketstatus
geändert oder das Ticket geschlossen werden. Wenn ein offenes Ticket für eine bestimmte
Host-/Dienst-Kombination existiert, werden alle E-Mails, die diese bestimmte Kombination
betreffen, angehängt, bis das Ticket geschlossen wird.

Bei Icinga2 erfolgt dies durch die Angabe eines Hosts und eines Dienstes in den dynamischen
Feldern des Tickets. Diese Kombination aus Host und Dienst wird nach dem Setzen einer
Ticket-Sperre verwendet, um eine HTTP-Anfrage zu generieren, die an den konfigurierten
Icinga2-Host gesendet wird (siehe Kapitel 'Konfiguration'). In Icinga2 wird diese Anfrage
verwendet, um neue Vorfälle anzulegen oder zu bestätigen.

# Funktionsübersicht

## Ablaufsteuerung (Nagios)

Das folgende Diagramm veranschaulicht, wie E-Mails von diesem Modul verarbeitet werden
und in welchen Fällen sie welche Aktion auslösen. Nahezu alle Prüfungen lassen sich
mithilfe der regulären Ausdrücke konfigurieren, die durch die unten aufgeführten Parameter
vorgegeben sind.

```
Stimmt die E-Mail-Adresse mit 'FromAddress' überein?
|
+-> NEIN --> Mit der regulären Email-Bearbeitung fortfahren
|
+-> JA   --> Gibt es in Znuny bereits ein Ticket mit derselben Kombination
        aus Host und Dienst?
        |
        +-> NEIN  -> Stimmt 'State:' mit 'NewTicketRegExp' überein?
        |          |
        |          +-> NEIN -> Die Bearbeitung dieser E-Mail beenden
        |          |           (stilles Wegwerfen)
        |          |
        |          +-> JA   -> Neues Ticket erstellen, Host und Service
        |                      erfassen, E-Mail anhängen
        |
        +-> JA  -> Email an Ticket anhängen
                -> Stimmt 'State:' match 'CloseTicketRegExp'?
                    |
                    +-> NEIN -> Mit der regulären Email-Bearbeitung fortfahren
                    |
                    +-> JA   -> Ticketstatus entsprechend der Konfiguration unter
                                'CloseActionState'
```

Neben einigen zusätzlichen Plausibilitätsprüfungen verarbeitet das
SystemMonitoring-Modul eingehende E-Mails auf diese Weise. Durch Ändern der regulären
Ausdrücke sollte es möglich sein, es an verschiedene Überwachungssysteme anzupassen.

## Icinga2 Bestätigung

Es wird ein neues Ticket mit Werten in den angegebenen dynamischen Feldern erstellt,
die als Kombination aus Host und Dienst für die Kommunikation mit dem Icinga2-Host benötigt
werden. Nachdem dieses neu erstellte Ticket einem Agenten zugewiesen wurde, wird eine
HTTP-Anfrage an den konfigurierten Icinga2-Host gesendet. Auf dem Icinga2-Host wird eine neue
Bestätigung erstellt oder eine bereits vorhandene bestätigt.

# Systemanforderungen

Für die Nutzung dieses Pakets ist folgende Software von Drittanbietern erforderlich:

Ein Netzwerküberwachungssystem wie Nagios, Icinga2, HP OpenView oder Ähnliches,
das Ereignisse per E-Mail versenden kann.

# Installation

In der folgenden Anleitung wird erläutert, wie das Paket installiert wird. Es gibt
zwei Möglichkeiten.

## Administrator-Oberfläche

Bitte verwenden Sie die folgende URL, um das Paket über die Admin-Oberfläche zu
installieren (bitte beachten Sie, dass Sie Mitglied der Gruppe "admin" sein müssen).

```
http://localhost/znuny/index.pl?Action=AdminPackageManager
```

## Befehlszeile

Sollten Sie die Admin-Oberfläche aus irgendeinem Grund nicht nutzen können, können Sie
stattdessen das folgende Befehlszeilentool ("bin/znuny.Console.pl Admin::Package::Install")
verwenden.

```
shell> bin/znuny.Console.pl Admin::Package::Install /Pfad/zu/$Name-$Version.opm
```

# Konfiguration

Das Paket kann über die Systemkonfiguration in der Admin-Oberfläche konfiguriert werden.
Folgende Konfigurationsoptionen stehen zur Verfügung:

| Module | Navigation | Beschreibung |
| --- | --- | --- |
| Icinga2::Acknowledge::Author | Core::SystemMonitoring::Icinga2 | Icinga2 Bestätigungsverfasser. |
| Icinga2::Acknowledge::Comment | Core::SystemMonitoring::Icinga2 | Icinga2 Bestätigungskommentar. |
| Icinga2::Acknowledge::Enabled | Core::SystemMonitoring::Icinga2 | Icinga2 Bestätigung aktiviert? |
| Icinga2::Acknowledge::FreeField::Host | Core::SystemMonitoring::Icinga2 | Name des dynamischen Feldes für den Host. |
| Icinga2::Acknowledge::FreeField::Service | Core::SystemMonitoring::Icinga2 | Name des dynamischen Feldes für den Service. |
| Icinga2::Acknowledge::HTTP::Password | Core::SystemMonitoring::Icinga2 | Das HTTP-Bestätigungspasswort. |
| Icinga2::Acknowledge::HTTP::URL | Core::SystemMonitoring::Icinga2 | Icinga API URL. |
| Icinga2::Acknowledge::HTTP::User | Core::SystemMonitoring::Icinga2 | Der HTTP-Bestätigungsbenutzer. |
| Icinga2::Acknowledge::Notify | Core::SystemMonitoring::Icinga2 | Icinga2 Bestätigungsnachricht. |
| Icinga2::Acknowledge::Sticky | Core::SystemMonitoring::Icinga2 | Icinga2 "sticky"-Bestätigung. |
| Nagios::Acknowledge::FreeField::Host | Core::SystemMonitoring::Nagios | Name des dynamischen Feldes für den Host |
| Nagios::Acknowledge::FreeField::Service | Core::SystemMonitoring::Nagios | Name des dynamischen Feldes für den Dienst. |
| Nagios::Acknowledge::HTTP::Password | Core::SystemMonitoring::Nagios | Das HTTP-Bestätigungspasswort. |
| Nagios::Acknowledge::HTTP::URL | Core::SystemMonitoring::Nagios | Die URL der HTTP-Bestätigung. |
| Nagios::Acknowledge::HTTP::User | Core::SystemMonitoring::Nagios | Der HTTP-Bestätigungsbenutzer. |
| PostMaster::PreFilterModule###00-SystemMonitoring | Core::Email::PostMaster | Grundlegendes Mail-Interface zu System Monitoring Anwendungen. Benutzen Sie diesen Abschnitt, wenn der Filter VOR dem PostMaster-Filter ausgeführt werden soll. |
| PostMaster::PreFilterModule###1-SystemMonitoring | Core::Email::PostMaster | Grundlegendes Mail-Interface zu System Monitoring Anwendungen. Benutzen Sie diesen Abschnitt, wenn der Filter NACH dem PostMaster-Filter ausgeführt werden soll. |
| SystemMonitoring::LinkTicketWithCI | Core::SystemMonitoring | Verlinkung eines bereits geöffneten Incident Tickets mit einem betroffenen CI. Dies ist nur möglich, wenn eine entsprechende System Monitoring E-Mail eintrifft. |
| SystemMonitoring::SetIncidentState | Core::SystemMonitoring | Setzt den Vorfallstatus eines Configuration Item automatisch, wenn eine E-Mail vom System-Monitoring eintrifft. |
| Ticket::EventModulePost###9-Icinga2Acknowledge | Core::Event::Icinga2 | Ticket-Ereignismodul, um eine Bestätigung an Icinga2 zu senden. |
| Ticket::EventModulePost###9-NagiosAcknowledge | Core::Event::Nagios | Ticket-Ereignismodul, um eine Bestätigung an Nagios zu senden. |

# Tests

Dieses Modul wurde gemäß den aktuellen Znuny-Richtlinien qualitätsgesichert.

## Unit Test

Um die Qualität des Moduls sicherzustellen, wurden mehrere sogenannte Unit-Tests erstellt,
um die Funktionen dieses Moduls zu testen. Diese Unit-Tests können über die Befehlszeile
ausgeführt werden.

ACHTUNG: Führen Sie bitte niemals Unit-Tests auf einem Produktionssystem durch, da die
dem System hinzugefügten Testdaten nicht mehr entfernt werden. Verwenden Sie stets ein
Testsystem.

### Führe die paketspezifischen Unit-Tests aus.

Um nur den Unit-Test auszuführen, der mit diesem Paket ausgeliefert wird, geben Sie den folgenden Befehl in der Befehlszeile ein:

```
shell> perl bin/znuny.Console.pl Dev::UnitTest::Run --test Console/Command/Maint/SystemMonitoring/NagiosCheck
shell> perl bin/znuny.Console.pl Dev::UnitTest::Run --test Console/Command/Maint/SystemMonitoring/NagiosCheckTicketCount
shell> perl bin/znuny.Console.pl Dev::UnitTest::Run --test SystemMonitoring
```

### Alle verfügbaren Unit-Tests ausführen.

Um alle verfügbaren Unit-Tests auszuführen, geben Sie den folgenden Befehl in der Befehlszeile ein:

```
shell> perl bin/znuny.Console.pl Dev::UnitTest::Run
```
