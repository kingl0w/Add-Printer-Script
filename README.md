# Add-Printer-Script

## Overview
A couple of tools I built for work to add printers remotely and locally using a Xerox global driver. Some of our smaller sites don't have or need a print server configuration or specific GPO policies, so we add printers locally. I wrote these scripts to save time and as a learning experience. The script adds the printer assuming the driver is not already installed. If the driver is already installed, it will throw an error but will still add the printer in subsequent steps. I plan to add functionality in the future to check for the driver first and bypass the error if it's already installed.

## How It Works
The tools copy the driver folder to C:/Temp on the chosen PC, install the driver to the driver store, and add the printer using its IP and name. The remote tool performs the same actions but locates the PC by its name on the domain. The removal script provides options to list, remove specific, or remove all printers based on your needs.

**Note:** You will need to download the actual driver folder and extract its contents to the empty Driver folder in the project. I use the V3 Xerox Global Print Driver PCL6 from the [Xerox support site](https://www.support.xerox.com/en-us/product/global-printer-driver/downloads?language=en), but you can use a different driver if you prefer. Note that other drivers may not work as intended as they have not been tested with this script.

## Scripts

### `localPrinter.ps1`
This script installs the driver and adds a printer locally using its IP address and name. The user is prompted to enter these details, and the script will continue to prompt for additional printers until the user decides to stop.

### `remotePrinter.ps1`
This script copies the driver to a remote PC and installs the driver and printer in a similar fashion to `localPrinter.ps1`. It requires the computer name on the domain to find and access the remote PC.

### `removal.ps1`
This script offers options to list all printers, remove a specific printer, or remove all printers from a remote computer. The user is prompted for the computer name and the desired action.

## Usage
1. Download the Xerox Global Print Driver PCL6 and extract it to the `Driver` folder in this project.
2. Run the desired script:
   - For local installation, use `localPrinter.ps1`.
   - For remote installation, use `remotePrinter.ps1`.
   - To remove printers, use `removal.ps1`.
3. Follow the on-screen prompts to complete the printer installation or removal process.

## Contributing
Feel free to fork this repository and use or modify as you wish


