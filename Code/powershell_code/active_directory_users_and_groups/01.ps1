#Import-Module ActiveDirectory

param([string] $input_file)



foreach($line in Get-Content $input_file) {
    
    $cut = $line -split ":", 2
    $group = $cut[0]
    $display = $cut[1]

    # Write-Host "$group : $display"
    New-ADGroup -Name $group -DisplayName $display
}