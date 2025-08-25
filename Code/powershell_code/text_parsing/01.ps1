param([string] $input_file)

foreach($line in Get-Content $input_file) {
    
    $cut = $line -split ":"
    $username = $cut[0]
    $uid = $cut[2]
    $house = $cut[5]

    Write-Host "$username,$uid,$house"    
}