param([string] $input_file, $shell_string)
[int] $count = 0

foreach($line in Get-Content $input_file) {
    
    $cut = $line -split ":"
    $shell = $cut[6]

    if ($shell_string -eq $shell) {
        $count++
    }   
}

Write-Host "Count of default shell set to $shell_string is $count"