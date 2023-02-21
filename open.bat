<# : chooser.bat
:: launches a File... Open sort of file chooser and outputs choice(s) to the console
:: https://stackoverflow.com/a/15885133/1683264

@echo off
setlocal

set type=%1

for /f "delims=" %%I in ('powershell "iex(${%~f0}|out-string)"') do (
    echo  %%~I
)
goto :EOF

: end Batch portion / begin PowerShell hybrid chimera #>

Add-Type -AssemblyName System.Windows.Forms
function fileDialog([string]$type){
    switch ($type) {
        "load" {
            $f = New-Object Windows.Forms.OpenFileDialog
        }
        "save" {
            $f = New-Object Windows.Forms.SaveFileDialog
        }
        default {
            throw "Invalid type specified: $type"
        }
    }
    $f.InitialDirectory = pwd
    [void]$f.ShowDialog()
}

fileDialog($env:type)