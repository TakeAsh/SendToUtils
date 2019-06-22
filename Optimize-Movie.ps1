<#
  .SYNOPSIS
    Optimize the movie file by ffmpeg.
    Optimize-Movie.ps1 <filename> [<filename>...]

  .DESCRIPTION
    To use this script, create a shortcut to 'powershell.exe -File "fullpath\to\Optimize-Movie.ps1"' in '%AppData%\Microsoft\Windows\SendTo'.

  .LINK
    [Recycle - PowerShell Gallery](https://www.powershellgallery.com/packages/Recycle/)
#>


$args | ForEach-Object {
  $path = $_
  $dir = [System.IO.Path]::GetDirectoryName($path)
  $filename = [System.IO.Path]::GetFileNameWithoutExtension($path)
  $ext = [System.IO.Path]::GetExtension($path)
  $bak = "${filename}.bak${ext}"
  if (!!$dir) {
    $bak = Join-Path "$dir" "$bak"
  }
  Write-Output $path $bak
  Rename-Item -LiteralPath "$path" -NewName "$bak"
  ffmpeg.exe -i "$bak" -bsf:a aac_adtstoasc -c copy -movflags faststart "$path"
  Remove-ItemSafely -LiteralPath "$bak"
}
