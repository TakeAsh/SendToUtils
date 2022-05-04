<#
  .SYNOPSIS
    Blighten the movie file with gamma value.
    Brighten-Movie.ps1 <filename> [<filename>...]

  .DESCRIPTION
    To use this script, create a shortcut to 'powershell.exe -File "fullpath\to\Brighten-Movie.ps1"' in '%AppData%\Microsoft\Windows\SendTo'.
#>

$args | ForEach-Object {
  $path = $_
  $dir = [System.IO.Path]::GetDirectoryName($path)
  $filename = [System.IO.Path]::GetFileNameWithoutExtension($path)
  $ext = [System.IO.Path]::GetExtension($path)
  ffmpeg.exe -y -i "$path" -vf "lutyuv='y=gammaval(0.6)'" -bsf:a aac_adtstoasc -acodec copy -movflags faststart "${dir}/${filename}g${ext}"
}
