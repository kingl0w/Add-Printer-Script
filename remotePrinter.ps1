#Copy driver folder to PC
$localPath = ".\Driver"
$remotePath = "C:\Temp"

$remoteComputerName = Read-Host -Prompt "Computer Name"

$fullLocalPath = Resolve-Path $localPath

try {
    Copy-Item -Path $fullLocalPath -Destination "\\$remoteComputerName\$($remotePath.Replace(':', '$'))" -Recurse -Force -ErrorAction Stop
} catch {
    Write-Host "Failed to copy driver folder: $_"
    exit
}

#Install driver
$scriptBlock = {
    param($driverPath, $driverDisplayName)
    
    try {
        $output = & pnputil /add-driver $driverPath /install
        Write-Host $output
        Write-Host "Driver installation to the Driver Store completed."

        Start-Sleep -Seconds 5  #Wait for a few seconds to ensure the installation process is complete

        #Verify the driver installation
        $driverInstalled = Get-PrinterDriver -Name $driverDisplayName -ErrorAction SilentlyContinue
        if ($null -ne $driverInstalled) {
            Write-Host "Driver installation verified."
        } else {
            Write-Host "Driver installation could not be verified."
            exit
        }
    } catch {
        Write-Host "Failed to install driver: $_"
        exit
    }
}

$driverPath = Join-Path -Path $remotePath -ChildPath "Driver\x3UNIVX.inf"
$driverDisplayName = "Xerox Global Print Driver PCL6"

Invoke-Command -ComputerName $remoteComputerName -ScriptBlock $scriptBlock -ArgumentList $driverPath, $driverDisplayName

#Install printer
do {
    $printerIP = Read-Host -Prompt "Enter the printer's IP address"
    $printerName = Read-Host -Prompt "Enter the printer's name"
    $portName = "IP_$printerIP"

    $printerScriptBlock = {
        param($portName, $printerIP, $driverDisplayName, $printerName)

        #Check if the port already exists
        if (-not (Get-PrinterPort -Name $portName -ErrorAction SilentlyContinue)) {
            Add-PrinterPort -Name $portName -PrinterHostAddress $printerIP
        } else {
            Write-Host "Port $portName already exists."
        }

        try {
            Add-Printer -DriverName $driverDisplayName -Name $printerName -PortName $portName
            Write-Host "Printer '$printerName' added successfully."
        } catch {
            Write-Host "Failed to add printer: $_"
            exit
        }
    }

    Invoke-Command -ComputerName $remoteComputerName -ScriptBlock $printerScriptBlock -ArgumentList $portName, $printerIP, $driverDisplayName, $printerName

    $addAnother = Read-Host "Do you want to add another printer? (yes/no)"
} while ($addAnother -eq "yes")

Write-Host "Printer installation process completed."