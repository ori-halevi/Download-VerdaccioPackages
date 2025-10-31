# Download-VerdaccioPackages

A PowerShell script for downloading all packages from a Verdaccio npm registry to local storage.

## Overview

Download-VerdaccioPackages is a simple yet powerful PowerShell utility that connects to your Verdaccio private npm registry and downloads all published packages as `.tgz` files. This is ideal for:

- Creating backups of your private npm registry
- Migrating packages between Verdaccio instances
- Setting up offline package repositories
- Archiving package versions for compliance or audit purposes
- Disaster recovery planning

## Features

- 📦 Downloads all packages from a Verdaccio registry automatically
- 🎯 Fetches the latest version of each package
- 🏷️ Handles scoped packages (e.g., `@company/package-name`)
- 🛡️ Safe filename generation (removes special characters)
- ⚠️ Error handling with detailed logging
- 🪟 Native PowerShell - no additional dependencies required

## Prerequisites

- Windows with PowerShell 5.1 or higher (or PowerShell Core 6+ on any platform)
- Access to a running Verdaccio instance (default: `http://localhost:4873`)
- Appropriate permissions to download packages from the registry

## Installation

### Option 1: Download from Releases

You can download the latest release directly from the [Releases page](https://github.com/ori-halevi/Download-VerdaccioPackages/releases).

### Option 2: Clone from Source

```powershell
git clone https://github.com/ori-halevi/Download-VerdaccioPackages.git
cd Download-VerdaccioPackages
```

## Usage

1. Ensure your Verdaccio instance is running (default port: 4873)

2. Run the PowerShell script:
```powershell
.\Download-VerdaccioPackages.ps1
```

3. The script will:
   - Query your Verdaccio registry for all available packages
   - Download the latest version of each package
   - Save all `.tgz` files to `C:\VerdaccioTgz`
   - Display progress and any errors during download

## Configuration

### Change Verdaccio URL

Edit the first line of the script to point to your Verdaccio instance:

```powershell
$response = Invoke-WebRequest -Uri http://your-verdaccio-server:4873/-/all
```

### Change Download Directory

Modify the `$downloadDir` variable:

```powershell
$downloadDir = "C:\Your\Custom\Path"
```

## Output

- **Downloaded packages**: All `.tgz` files are saved to `C:\VerdaccioTgz` by default
- **Filename format**: 
  - Regular packages: `package-name-1.0.0.tgz`
  - Scoped packages: `scope-package-name-1.0.0.tgz`
- **Console output**: Real-time progress and error messages

## Example Output

```
Downloading express@4.18.2 ...
Downloading @types/node@20.10.0 ...
Downloading lodash@4.17.21 ...
Failed to download some-package@1.0.0: 404 Not Found
Downloading body-parser@1.20.2 ...
```

## How It Works

1. **Fetch Package List**: Queries the `/-/all` endpoint to get all packages
2. **Extract Latest Version**: Reads the `dist-tags.latest` for each package
3. **URL Construction**: Builds the correct download URL for each package
   - Regular packages: `http://localhost:4873/package/-/package-version.tgz`
   - Scoped packages: `http://localhost:4873/@scope%2Fpackage/-/package-version.tgz`
4. **Safe Download**: Creates sanitized filenames and downloads each package
5. **Error Handling**: Catches and reports any download failures

## Troubleshooting

### Connection Refused
Make sure Verdaccio is running:
```powershell
verdaccio
```

### Permission Denied
Run PowerShell as Administrator or choose a directory where you have write permissions.

### 404 Errors
Some packages may not have `.tgz` files available. These will be logged but won't stop the script.

### Execution Policy Error
If you get an execution policy error, run:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## Advanced Usage

### Download Specific Versions

Modify the script to use a different version tag:
```powershell
$version = $allPackages.$pkgName."dist-tags".beta  # Instead of .latest
```

### Filter Packages

Add filtering logic before the download loop:
```powershell
foreach ($pkgName in $allPackages.PSObject.Properties.Name) {
    if ($pkgName -notlike "@mycompany/*") { continue }  # Only download @mycompany packages
    # ... rest of the code
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Repository

https://github.com/ori-halevi/Download-VerdaccioPackages

## Related Projects

- [OfflinePackMaster](https://github.com/ori-halevi/OfflinePackMaster) - Download npm packages with dependencies for offline use
