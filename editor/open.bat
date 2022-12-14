<# : chooser.bat
:: launches a File... Open sort of file chooser and outputs choice(s) to the console
:: https://stackoverflow.com/a/15885133/1683264

@echo off
setlocal

for /f "delims=" %%I in ('powershell "iex (${%~f0} | out-string)"') do (
    echo %FileName%
)
goto :EOF

: end Batch portion / begin PowerShell hybrid chimera #>

Add-Type -AssemblyName System.Windows.Forms
$f = new-object System.Windows.Forms.OpenFileDialog
$f.InitialDirectory = pwd
$f.filter = "All files (*.*)|*.*
$f.ShowDialog()
$f.FileName