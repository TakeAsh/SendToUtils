<#
  .SYNOPSIS
    Swap the id and the title in the filename.
    Swap-Id-Title.ps1 <filename> [<filename>...]

  .DESCRIPTION
    Rename the filename from "(id)_(title)[.ext]" to "(title)_(id)[.ext]".
    To use this script, create a shortcut to 'powershell.exe -File "fullpath\to\Swap-Id-Title.ps1"' in '%AppData%\Microsoft\Windows\SendTo'.
#>


$re = [regex]'^(?<id>[^_]+)_(?<title>.*)$'
$args | ForEach-Object {
  $path = $_
  $dir = [System.IO.Path]::GetDirectoryName($path)
  $filename = [System.IO.Path]::GetFileNameWithoutExtension($path)
  $ext = [System.IO.Path]::GetExtension($path)
  $m = $re.Matches($filename)
  if (!$m[0].Success) { return }
  $id = $m[0].Groups['id']
  $title = $m[0].Groups['title']
  $newPath = Join-Path "${dir}" "${title}_${id}${ext}"
  Rename-Item -LiteralPath "${path}" -NewName "${newPath}"
}
