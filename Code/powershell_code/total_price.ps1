$qty = [int] (Read-Host -Prompt "Enter the quantity")
[float] $price = Read-Host -Prompt "Enter the price"

Write-Host ('The total of the shopping cart is: $' + ($qty * $price))