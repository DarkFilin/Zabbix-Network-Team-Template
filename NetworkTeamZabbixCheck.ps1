<#
    .VERSION
    0.3
    
    .SYNOPSIS
    [En]Script with LLD support for getting data from Windows Team network interfaces to Zabbix monitoring system.
    [Ru]Скрипт с поддержкой LLD для получения данных из сетевых интерфейсов Windows Team в систему мониторинга Zabbix. 

    .DESCRIPTION
    [En]The script may generate LLD data for Windows Team network interfaces
    [Ru]Скрипт может генерировать данные LLD для сетевых интерфейсов Windows Team. 

    .NOTES
    Author: Dark_Filin
    https://github.com/DarkFilin/Zabbix-Network-Team-Template

#>
Param (
[switch]$version = $false,
[ValidateSet("lld","health")][Parameter(Position=0, Mandatory=$True)][string]$action,
[ValidateSet("status","mode","teamname")][Parameter(Position=1, Mandatory=$True)][string]$part,
[string][Parameter(Position=2)]$TeamName
)

$AllNetworkTeams =$null

#Function for LLD all Windows Team network interfaces
#Функция для обнаружения всех Windows Team network interfaces
function LLDTeamName() {
    #Get info about all network team interfaces
    #Получение информации обо всех network team interfaces
    $AllNetworkTeams = Get-NetLbfoTeam
    #If team is exist, get team names 
    #Если team найдены, получаем их имена
    if ($AllNetworkTeams) {
        $AllNetworkTeams | ForEach-Object {
            $NetworkTeamName = $_.Name
            #Format team name as JSON
            #Форматируем полученное имя team как JSON
            $NetworkTeamInfoFormatted = [string]::Format('{{"{{#TEAM.NAME}}":"{0}"}},',$NetworkTeamName )
            $NetworkTeamJSON += $NetworkTeamInfoFormatted
        }
        #Create JSON Array
        #Создаем массив JSON
        $LLDData = '{"data":[' + $($NetworkTeamJSON -replace ',$') + ']}'    
    }
    return $LLDData
}

#Function for get Windows Team network interfaces status. Statuses that can be: Up, Down, Degraded. (from info about MSFT_NetLbfoTeam)
#Функция для получения статуса Team сетевых интерфейсов Windows. Статусы, которые могут быть: Up, Down, Degraded. (из информации о MSFT_NetLbfoTeam) 
function GetNetworkTeamStatus() {
    $NetworkTeamInfo = Get-NetLbfoTeam -Name $TeamName
    $NetworkTeamStatus = $NetworkTeamInfo.Status
    return $NetworkTeamStatus

}

#Function for get Windows Team network interfaces mode. Modes that can be: Static, SwitchIndependent, Lacp. (from info about MSFT_NetLbfoTeam)
#Функция для получения режима работы Team сетевых интерфейсов Windows. Возможные режимы: Static, SwitchIndependent, Lacp. (из информации о MSFT_NetLbfoTeam) 
function GetNetworkTeamMode() {
    $NetworkTeamInfo = Get-NetLbfoTeam -Name $TeamName
    $NetworkTeamMode = $NetworkTeamInfo.TeamingMode
    return $NetworkTeamMode
}

#Selecting a function depending on the arguments passed to the script.
#Выбор функции в зависимости от аргументов, переданных скрипту. 
switch($action){
    "lld" {
        switch($part){
            "teamname" { write-host $(LLDTeamName) }
        }
    }
    "health" {
        switch($part) {
            "status" { write-host $(GetNetworkTeamStatus)}
            "mode"   { write-host $(GetNetworkTeamMode)}
        }
    }
    default {Write-Host "ERROR: Wrong argument: use 'lld' or 'health'"}
}