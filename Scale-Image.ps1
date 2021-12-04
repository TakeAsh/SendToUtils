<#
  .SYNOPSIS
    Scale the image by GIMP.
    Scale-Image.ps1 <filename> [<filename>...]

  .DESCRIPTION
    To use this script, create a shortcut to 'powershell.exe -File "fullpath\to\Scale-Image.ps1"' in '%AppData%\Microsoft\Windows\SendTo'.

  .LINK
    GIMP-scripts: https://github.com/TakeAsh/GIMP-scripts
#>

$argumentList = @('-n')  # , '-i'
$argumentList += $args | `
  ForEach-Object { $_.Replace('\', '/') } | `
  ForEach-Object { "-b", "`"(batch-scale-image \`"$_\`" 1920 1080)`"" }
$argumentList += @("-b", "`"(gimp-quit 0)`"")

$processOptions = @{
  #FilePath     = 'C:/Program Files/GIMP 2/bin/gimp-2.10.exe';
  FilePath     = 'C:/Program Files/GIMP 2/bin/gimp-console-2.10.exe';
  WindowStyle  = 'Minimized';
  ArgumentList = $argumentList;
}
#Write-Output $processOptions
#Write-Output $processOptions.ArgumentList
Start-Process @processOptions
#Read-Host 'Push Enter'
