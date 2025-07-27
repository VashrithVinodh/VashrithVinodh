param([string] $input_file)

foreach($line in Get-Content $input_file) {
    
    $cut = $line -split ":", 3
    $username = $cut[0]
    $display = $cut[1]
    $password = $cut[2]

    #Write-Host "$username : $display : $password"
    New-ADUser -SamAccountName $username -DisplayName $display -Name $display -AccountPassword $password -Enabled $true
}