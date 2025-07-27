param([string] $input_file)

foreach($line in Get-Content $input_file) {
    
    $cut = $line -split ":", 2
    $username = $cut[0]
    $grousp = $cut[1]

    $user = Get-ADUser -Filter {SamAccountName -eq $username}

    if ($user) {
        foreach ($group in $groups) {
            $adg = Get-ADGroup -Filter {Name -eq $group}

            if ($adg) {
                #Add-ADGroupMember -Identity $adg -Member $user
            }
        }
    }                          
    # Write-Host "$username : $group"
}