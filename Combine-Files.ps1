<#
  .SYNOPSIS
    Combine divided files.
    Combine-Files.ps1 <filename> [<filename>...]

  .DESCRIPTION
    Select one of divided file(*.001), this script collects other files(.002, .003, ...) in same folder and combines them.
    To use this script, create a shortcut to 'powershell.exe -File "fullpath\to\Combine-Files.ps1"' in '%AppData%\Microsoft\Windows\SendTo'.

  .LINK
    [function Join-File](https://stackoverflow.com/a/29000222)
#>

function Join-File (
  [parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
  [string[]] $Path,
  [parameter(Position = 1, Mandatory = $true)]
  [string] $Destination
) {
  write-verbose "Join-File: Open Destination1 $Destination"
  $OutFile = [System.IO.File]::Create($Destination)
  foreach ( $File in $Path ) {
    write-verbose "   Join-File: Open Source $File"
    $InFile = [System.IO.File]::OpenRead($File)
    $InFile.CopyTo($OutFile)
    $InFile.Dispose()
  }
  $OutFile.Dispose()
  write-verbose "Join-File: finished"
}

$reduced = $args |
  ForEach-Object {
    [PSCustomObject]@{ 
      Dir      = [System.IO.Path]::GetDirectoryName($_)
      FileName = [System.IO.Path]::GetFileNameWithoutExtension($_)
      Ext      = [System.IO.Path]::GetExtension($_) 
    } } |
  Where-Object { $_.Ext -match '^\.\d+$' } |
  ForEach-Object { $hash = @{} } { $hash[$_.FileName] = $_ } { [PSCustomObject]$hash } 
$reduced.psobject.properties.name | ForEach-Object { 
  $key = $reduced.$_
  $target = Join-Path -Path $key.Dir -ChildPath $key.FileName
  $filter = $key.FileName + '.*'
  $paths = Get-ChildItem -Path $key.Dir -Filter $filter | 
    Where-Object { $fname = [System.IO.Path]::GetFileNameWithoutExtension($_.Name); !!$reduced.$fname } |
    Sort-Object { $_.Name } |
    ForEach-Object { Join-Path -Path $key.Dir -ChildPath $_.Name } 
    Join-File -Path $paths -Destination $target
  }
