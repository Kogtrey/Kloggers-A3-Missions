[cmdletBinding()]
param(
    [Parameter(Mandatory,Position=0)]
    [string]$Mission,

    [Parameter(Mandatory=$false, Position=1)]
    [string]$OutDir="~/Documents/Arma 3/missions",

    [Parameter(Mandatory=$false, Position=2)]
    [int]$MaxBackups=5
)

$swMain = [System.Diagnostics.Stopwatch]::new();
$swMain.Start();

$swSection = [System.Diagnostics.Stopwatch]::new();

# Validation
try {
    $swSection.Start();
    Write-Host "<----- Validation ----->"

    if(!(Test-Path "$PSScriptRoot\$Mission")){throw [System.ArgumentException]::new("$Mission not found")};
    
    if(!(Test-Path $OutDir)){ throw [System.ArgumentException]::new("$OutDir not found. Verify the folder exists and try again")};

    $swSection.Stop();
    Write-Host "# Done. ($($swSection.ElapsedMilliseconds)ms)";
    $swSection.Reset();
}
catch {
    Write-Error "Failed to validate: $_"
    return;
}

# Backup
try {
    $swSection.Start();
    Write-Host "<----- Backup ----->"

    # Check for existing PBO
    if(Test-Path "$OutDir\$Mission.pbo"){

        # Assert backup folder exists at out dir
        $dirBackups = New-Item -Path $OutDir -Name 'backup' -ItemType:Directory -Force

        # Copy to backups
        Copy-Item -Path "$OutDir\$Mission.pbo" -Destination "$dirBackups\$Mission.pbo.$(Get-Date -Format 'yyyyMMddHHmmss').bak" -Force

        # Get backups
        $backups = (Get-ChildItem $dirBackups).Where{ $_.Name -match "$($Mission).pbo.\d{14}.bak" }

        Write-Host "# Found $($backups.Count) backups"

        # Delete backups if current backup count for this mission is greater than max backups
        if(($MaxBackups -ne -1) -and ($backups.Count -gt $MaxBackups)){
            $backupsToDelete = ($backups | Sort Name -Descending)[$($MaxBackups)..$($backups.Count - 1)]

            Write-Host "# Deleting $($backupsToDelete.Count) backups";
            $backupsToDelete | Remove-Item -Recurse -Force
        }
    }
    $swSection.Stop();
    Write-Host "# Done. ($($swSection.ElapsedMilliseconds)ms)";
    $swSection.Reset();
}
catch {
    Write-Error "Failed to validate: $_"
    return;
}

# Pack with pbo manager
try {
    $swSection.Start();
    Write-Host "<----- Pack ----->";

    if(Test-Path "$OutDir\$Mission.pbo"){
        Write-Host "# Deleting old mission file";
        Remove-Item -Path "$OutDir\$Mission.pbo" -Force;
    }
    
    Write-Host "# Packing $($Mission) with PBO Manager";
    $o = Get-Item $OutDir;
    Start-Process "pbom" -ArgumentList "pack -o `"$($o.FullName)`" -u `"$Mission`"" -Wait -NoNewWindow

    if(!(Test-Path "$OutDir\$Mission.pbo")){throw [System.Exception]::new("The mission PBO did not make it to the target destination. Review error messages or try again.")}

    $swSection.Stop();
    Write-Host "# Done. ($($swSection.ElapsedMilliseconds)ms)";
    $swSection.Reset();
}
catch {
    Write-Error "Failed to validate: $_"
    return;
}
$swMain.Stop();
Write-Host "Runtime: $($swMain.Elapsed.Hours)hr $($swMain.Elapsed.Minutes)min $($swMain.Elapsed.Seconds)s $($swMain.Elapsed.Milliseconds)ms";