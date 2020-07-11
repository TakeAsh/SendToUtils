<#
  .SYNOPSIS
    Apply the format to the numeric filenames.
    Apply-Format.ps1 <format> <filename> [<filename>...]

  .DESCRIPTION
    To use this script, create a shortcut to 'powershell.exe -File "fullpath\to\Apply-Format.ps1" "0000"' in '%AppData%\Microsoft\Windows\SendTo'.
    If <format> == "0000", then 1.jpg -> 0001.jpg, 10.jpg -> 0010.jpg, 100.jpg -> 0100.jpg, ...
    If <format> == "Prefix000", then 1.jpg -> Prefix001.jpg, 10.jpg -> Prefix010.jpg, 100.jpg -> Prefix100.jpg, ...
#>


$isFailed = $false
$re = [regex]'(?<num>\d+)$'
[int]$value = 0
$format, $args = $args  # in Perl, my $format = shift(@args);
$args | ForEach-Object {
  $path = $_
  $dir = [System.IO.Path]::GetDirectoryName($path)
  $filename = [System.IO.Path]::GetFileNameWithoutExtension($path)
  $ext = [System.IO.Path]::GetExtension($path)
  $m = $re.Matches($filename)
  if (!$m[0].Success -or ![int]::TryParse($m[0].Groups['num'], [ref]$value)) {
    Write-Warning "Fail to parse as int: ${filename}${ext}"
    $isFailed = $true
  }
  else {
    $newFilename = $value.ToString($format)
    $newPath = Join-Path "${dir}" "${newFilename}${ext}"
    Rename-Item -LiteralPath "${path}" -NewName "${newPath}"
  }
}
if ($isFailed) {
  Read-Host “Press 'ENTER' to close”
}
