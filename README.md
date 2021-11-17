# Zabbix-Network-Team-Template

## [Russian version] (English version below)
Шаблон для обнаружения объединенных сетевых интерфейсов, сделанных средствами Windows (LBFO).

Протестирован для Zabbix 4.0 и Windows 2019.

### Настройки хоста, на котором необходимо мониторить Team (меняя %Zabbix_install_folder% на путь к папке, в которую установлен Zabbix Agent):

Кладем скрипт в папку "%Zabbix_install_folder%\scripts\NetworkTeamZabbixCheck.ps1"

Кладем файл настроек в "%Zabbix_install_folder%\zabbix_agentd.conf.d\NetworkTeamZabbixCheck.conf"

В основном конфиге агента заббикс "%Zabbix_install_folder%\zabbix_agentd.conf" включаем дополнительные файлы конфигураций, добавляя строку в разделе Include:

Include=%Zabbix_install_folder%\zabbix_agentd.conf.d\*.conf

Так же убеждаемся, что параметр ServerActive= настроен.

Перезапускаем службу Zabbix Agent для применения изменений


### На сервере Zabbix:

#### Создаем шаблон Template_Network_Team

==============================================================

#### В шаблоне создаем Discovery Rule:

Name: Network Team Discovery

Type: Zabbix agent (active)

Key: network.team[lld,teamname]

Update interval: 1h

Keep lost resources period: 30d

==============================================================


#### Создаем 2 item prototypes:

Name: Team "{#TEAM.NAME}" mode

Type: Zabbix agent (active)

Key: network.team[health,mode,{#TEAM.NAME}]

Type of information: Text

Update interval: 30m

New application: Network Team


<br /><br /><br />
Name: Team "{#TEAM.NAME}" state

Type: Zabbix agent (active)

Key: network.team[health,status,{#TEAM.NAME}]

Type of information: Text

Update interval: 5m

New application: Network Team

==============================================================

#### Создаем trigger prototype:

Name: Network Team is degraded state

Severity: Average

Expression: {Template_Network_Team:network.team[health,status,{#TEAM.NAME}].regexp(Degraded)}=1

==============================================================

#### И назначаем созданный шаблон Template_Network_Team на хост, который мы настраивали в начале.


<br /><br /><br />
======================================================================================

## [English version]

A template for detecting team network interfaces made by Windows (LBFO).

Tested for Zabbix 4.0 and Windows 2019.

### Host settings on which the Team can be monitored (changing% Zabbix_install_folder% to the path to the folder where the Zabbix Agent is installed):

Put the script in the folder "%Zabbix_install_folder%\scripts\NetworkTeamZabbixCheck.ps1"

Put the settings file in "%Zabbix_install_folder%\zabbix_agentd.conf.d\NetworkTeamZabbixCheck.conf"

In the main config of the zabbix agent "% Zabbix_install_folder%\zabbix_agentd.conf" we include additional configuration files by adding a line in the Include section:

Include =%Zabbix_install_folder%\zabbix_agentd.conf.d\*.Conf

We also make sure that the ServerActive = parameter is configured.

Restart the Zabbix Agent service to apply the changes

### On the Zabbix server:

#### Create template Template_Network_Team

==============================================================


#### In template we create a Discovery Rule:

Name: Network Team Discovery

Type: Zabbix agent (active)

Key: network.team [lld,teamname]

Update interval: 1h

Keep lost resources period: 30d

==============================================================


#### Create 2 item prototypes:

Name: Team "{#TEAM.NAME}" mode

Type: Zabbix agent (active)

Key: network.team[health,mode,{#TEAM.NAME}]

Type of information: Text

Update interval: 30m

New application: Network Team

<br /><br /><br />

Name: Team "{#TEAM.NAME}" state

Type: Zabbix agent (active)

Key: network.team[health,status,{#TEAM.NAME}]

Type of information: Text

Update interval: 5m

New application: Network Team

==============================================================

#### We create a trigger prototype:

Name: Network Team is degraded state

Severity: Average

Expression: {Template_Network_Team:network.team[health,status,{#TEAM.NAME}].regexp(Degraded)}=1

==============================================================
#### And assign the created Template_Network_Team to the host that we configured in the beginning. 
