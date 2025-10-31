$response = Invoke-WebRequest -Uri http://localhost:4873/-/all
$allPackages = $response.Content | ConvertFrom-Json

$downloadDir = "C:\VerdaccioTgz"
New-Item -ItemType Directory -Path $downloadDir -Force

foreach ($pkgName in $allPackages.PSObject.Properties.Name) {
    if ($pkgName -eq "_updated") { continue }

    $version = $allPackages.$pkgName."dist-tags".latest

    if ($pkgName -like "@*") {
        $encodedName = $pkgName -replace "/", "%2F"
        $shortName = $pkgName.Split("/")[1]
        $url = "http://localhost:4873/$encodedName/-/$shortName-$version.tgz"
    } else {
        $url = "http://localhost:4873/$pkgName/-/$pkgName-$version.tgz"
    }

    Write-Host "Downloading $pkgName@$version ..."
try {
        # Create a "safe" filename by replacing both '@' and '/'
        $safeFileName = $pkgName -replace '@','' -replace '/','-'
        
        # Use the safe filename in the -OutFile path
        Invoke-WebRequest -Uri $url -OutFile "$downloadDir\$safeFileName-$version.tgz"
    } catch {
        Write-Host ("Failed to download {0}@{1}: {2}" -f $pkgName, $version, $_)
    }
}
