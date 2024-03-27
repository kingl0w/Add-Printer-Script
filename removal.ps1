$remoteComputerName = Read-Host -Prompt "Enter the remote computer name"

#Function to list all printers on the remote computer
function Get-RemotePrinters {
    param (
        [string]$ComputerName
    )

    try {
        $printers = Get-Printer -ComputerName $ComputerName -ErrorAction Stop
        return $printers
    }
    catch {
        Write-Host "Failed to retrieve printers from $($ComputerName): $_"
        return $null
    }
}

#Function to remove a specific printer
function Remove-RemotePrinter {
    param (
        [string]$ComputerName,
        [string]$PrinterName
    )

    try {
        Remove-Printer -ComputerName $ComputerName -Name $PrinterName -ErrorAction Stop
        Write-Host "Printer '$PrinterName' removed successfully from $ComputerName."
    }
    catch {
        Write-Host "Failed to remove printer '$PrinterName' from $($ComputerName): $_"
    }
}

#Function to remove all printers
function Remove-AllRemotePrinters {
    param (
        [string]$ComputerName
    )

    try {
        $printers = Get-RemotePrinters -ComputerName $ComputerName
        if ($printers) {
            foreach ($printer in $printers) {
                Remove-RemotePrinter -ComputerName $ComputerName -PrinterName $printer.Name
            }
            Write-Host "All printers removed successfully from $ComputerName."
        }
        else {
            Write-Host "No printers found on $ComputerName."
        }
    }
    catch {
        Write-Host "Failed to remove printers from $($ComputerName): $_"
    }
}

#List all printers on the remote computer
$printers = Get-RemotePrinters -ComputerName $remoteComputerName
if ($printers) {
    Write-Host "Printers on $($remoteComputerName):"
    $printers | Format-Table -AutoSize
}
else {
    Write-Host "No printers found on $remoteComputerName."
}

#Prompt user for action
$action = Read-Host -Prompt "Enter 'all' to remove all printers, or enter a printer name to remove a specific printer"

if ($action -eq 'all') {
    Remove-AllRemotePrinters -ComputerName $remoteComputerName
}
else {
    Remove-RemotePrinter -ComputerName $remoteComputerName -PrinterName $action
}