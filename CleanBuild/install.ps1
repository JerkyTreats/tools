$Ok = "*** [OK]"

function Write-Ok 
    Write-Host 


## Setup local path to install CleanBuild
$AppData = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Local AppData' | Select-Object -ExpandProperty 'Local AppData'
$ToolsPath = 'Tools\CleanBuild\CleanBuild.ps1'

$Path = Join-Path -Path $AppData -ChildPath $ToolsPath

Write-Host "Creating path: [$Path]"
New-Item -Path $Path -ItemType File -Force | Out-Null

if (Test-Path -Path $Path) {
    Write-Host $Ok
}

## Download CleanBuild
Write-Host "Download CleanBuild to [$ToolsPath]"
$CleanBuildUrl = "https://raw.githubusercontent.com/JerkyTreats/tools/main/CleanBuild/CleanBuild.ps1"
$Req = Invoke-WebRequest -Uri $CleanBuildUrl | Select-Object -ExpandProperty Content 

Set-Content -Path $Path -Value $Req

$LocalHash  = (Get-FileHash $Path -Algorithm MD5).Hash
$ReqHash    = (Get-FileHash $Req -Algorithm MD5).Hash

if ($LocalHash -eq $ReqHash)

## Add Script to Right-Click Explorer Menu
$RegPath = "HKCU:\Directory\Background\shell\CleanBuild\command"
$RegName = "command"
$RegValue = $Path


Write-Host "Adding Command to Right-Click File Context Menu"
Write-Host "Writing [$RegPath]"
New-Item -Path $RegPath -Force | Out-Null

New-ItemProperty -Path $RegPath $RegValue -PropertyType String -Force | Out-Null

if (Test-Path -Path $RegPath){
    Write-Host $Ok
}