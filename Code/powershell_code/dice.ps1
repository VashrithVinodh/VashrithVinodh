$d1 = Get-Random -Minimum 1 -Maximum 7
$d2 = (Get-Random) % 6 + 1

write-output "$d1 $d2"
Write-Output "$($d1 + $d2)"