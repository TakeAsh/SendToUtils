<#
  .SYNOPSIS
    Negate the movie file.
    Negate-Movie.ps1 <filename> [<filename>...]

  .DESCRIPTION
    To use this script, create a shortcut to 'powershell.exe -File "fullpath\to\Negate-Movie.ps1"' in '%AppData%\Microsoft\Windows\SendTo'.
#>


$args | ForEach-Object {
  $path = $_
  $dir = [System.IO.Path]::GetDirectoryName($path)
  $filename = [System.IO.Path]::GetFileNameWithoutExtension($path)
  $ext = [System.IO.Path]::GetExtension($path)
  ffmpeg.exe -y -i "$path" -vf "lutyuv='y=negval:u=negval:v=negval'" -bsf:a aac_adtstoasc -acodec copy -movflags faststart "${dir}/${filename}n${ext}"
}
