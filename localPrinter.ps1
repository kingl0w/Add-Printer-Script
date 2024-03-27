#Install driver
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$driverFolderPath = Join-Path $scriptPath "Driver"
$driverPath = Join-Path $driverFolderPath "x3UNIVX.inf"  
& pnputil /add-driver $driverPath /install
Write-Host "Driver installation to the Driver Store completed."

#Add Driver
Add-PrinterDriver -Name "Xerox Global Print Driver PCL6" -InfPath "C:\Windows\System32\DriverStore\FileRepository\x3univx.inf_amd64_b380d51cc1b6c2b7\x3UNIVX.inf"

do {
    # Install printer
    $printerIP = Read-Host -Prompt "Enter the printer's IP address"
    $printerName = Read-Host -Prompt "Enter the printer's name"
    $driverDisplayName = "Xerox Global Print Driver PCL6"

    $portName = "IP_$printerIP"
    Add-PrinterPort -Name $portName -PrinterHostAddress $printerIP

    Add-Printer -DriverName $driverDisplayName -Name $printerName -PortName $portName
    Write-Host "Printer '$printerName' added successfully."

    # Ask if the user wants to add another printer
    $addAnother = Read-Host "Do you want to add another printer? (yes/no)"
} while ($addAnother -eq "yes")

Write-Host "Printer installation process completed."