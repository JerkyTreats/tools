
function Ok {
    Write-Host "*** [OK]"
}

function Err {
    param( [String]$msg )
    Write-Host $msg
    Exit 1
}


## Setup local path to install CleanBuild
$AppData = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Local AppData' | Select-Object -ExpandProperty 'Local AppData'
$ToolsPath = 'Tools\CleanBuild\CleanBuild.ps1'

$Path = Join-Path -Path $AppData -ChildPath $ToolsPath

Write-Host "Creating path: [$Path]"
New-Item -Path $Path -ItemType File -Force | Out-Null

if (Test-Path -Path $Path) {
    Ok
}

## Download CleanBuild
Write-Host "Download CleanBuild to [$ToolsPath]"
$CleanBuildUrl = "https://raw.githubusercontent.com/JerkyTreats/tools/main/CleanBuild/CleanBuild.ps1"
$Req = Invoke-WebRequest -Uri $CleanBuildUrl

Set-Content -Path $Path -Value $Req.Content


## Add Script to Right-Click Explorer Menu
$RegPath = 
    'Registry::HKEY_CLASSES_ROOT\Directory\shell\CleanBuild\command', # Right Click on a folder
    'Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\CleanBuild\command' #Right Click in explorer window
$RegName = "(Default)"
$RegValue = $Path
$IconPath = Join-Path -Path $AppData -ChildPath "Tools\CleanBuild\icon.ico"

Write-Host "Adding Command to Right-Click File Context Menu"
Write-Host "Writing [$RegPath]"

foreach ( $rp in $RegPath ) {
    New-Item -Path $rp -Force 
    New-ItemProperty -Path $rp $RegName -Value $RegValue -PropertyType String -Force #| Out-Null
    New-ItemProperty -Path $rp Icon -Value $IconPath -PropertyType String -Force 

    if (Test-Path -Path $RegPath){
        Write-Host $Ok
    }
}
