## set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding


## Alias
set-Alias rm rm.exe # requires busybox
Set-Alias ll ls
Set-Alias df Get-PSDrive
Set-Alias py python3
# Set-Alias code code-insiders.cmd

## Utilities
function prompt {
    if ($isAdmin) {
        "[" + (Get-Location) + "] # "
    }
    else {
        "[" + (Get-Location) + "] $ "
    }
}

# Simple function to start a new elevated process. If arguments are supplied then
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin {
    if ($args.Count -gt 0) {
        $argList = "& '" + $args + "'"
        Start-Process powershell.exe -Verb runAs -ArgumentList $argList
    }
    else {
        Start-Process powershell.exe -Verb runAs
    }
}

function cd.. { Set-Location .. }
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# Drive shortcuts
function HKLM: { Set-Location HKLM: }
function HKCU: { Set-Location HKCU: }
function Env: { Set-Location Env: }

# Compute file hashes - useful for checking successful downloads
function md5 { (Get-FileHash -Algorithm MD5 $args).Hash }
function sha1 { (Get-FileHash -Algorithm SHA1 $args).Hash }
function sha256 { (Get-FileHash -Algorithm SHA256 $args).Hash }
function crlf { (Get-Content -Raw $args) -match "\r\n$" }

function n { notepad $args }
function shutdown { Stop-Computer -Force }
function reboot { Restart-Computer -Force }
function recovery { sudo shutdown.exe /r /o /t 0 }
function su { sudo pwsh }
function export($name, $value) { set-item -force -path "env:$name" -value $value; }
function l { ls $args | Format-Wide -Column 5 }
function ver { write $PSVersionTable }
function PubIP { (Invoke-WebRequest http://ifconfig.me/ip ).Content }
function tweak { sudo pwsh -c "irm christitus.com/win | iex" }
function pgrep ($name) { ps "*$name*" }
function pkill { ps $args -ErrorAction SilentlyContinue | kill }
function donde ($name) {
    ls -recurse -filter "${name}" -ErrorAction SilentlyContinue | foreach {
        $place_path = $_.directory
        write-host "${_}"
    }
}
function whereis ($name) {
    Get-Command -Name $name -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
function mcd { mkdir "$args"; cd "$args" }
function units { units.exe -1 -v $args }
function getch { python -c "import msvcrt;print(msvcrt.getch())" }
## Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}
