[cmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$Mission,

    [Parameter(Mandatory, Position = 1)]
    [string]$Username,

    [Parameter(Mandatory, Position = 2)]
    [securestring]$Password,

    [Parameter(Mandatory=$false, Position = 3)]
    [string]$MissionDir=$PSScriptRoot
)


$swMain = [System.Diagnostics.Stopwatch]::new();
$swMain.Start();

$swSection = [System.Diagnostics.Stopwatch]::new();

# Validation
try {
    $swSection.Start();
    Write-Host "<----- Validation ----->"

    if (!(Test-Path "$MissionDir\$Mission.pbo")) { throw [System.ArgumentException]::new("$Mission PBO not found. Be sure to pack the mission using 'pack.ps1'") };
    if (!(Test-Path "$PSScriptRoot\config.json")) { throw [System.ArgumentException]::new("config.json not found. Be sure that the file exists and is configured") };

    $swSection.Stop();
    Write-Host "# Done. ($($swSection.ElapsedMilliseconds)ms)";
    $swSection.Reset();
}
catch {
    Write-Error "Failed to validate: $_"
    return;
}

# Initialization
try {
    $swSection.Start();
    Write-Host "<----- Initializations ----->"

    $config = Get-Content "$PSScriptRoot\config.json" | ConvertFrom-JSON -depth 10
    $missionFile = Get-Item "$MissionDir\$Mission.pbo"

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
    Write-Host "<----- Upload ----->";

    $result = curl --user "$($Username):$($Password | ConvertFrom-SecureString -AsPlainText)" --upload-file "$($missionFile.FullName)" "ftp://$($config.a3ServerHost)/$($config.a3ServerWorkingDirectory)/mpmissions/$($missionFile.Name)"
    WRite-Host "# Result: $($result)"

    $swSection.Stop();
    Write-Host "# Done. ($($swSection.ElapsedMilliseconds)ms)";
    $swSection.Reset();
}
catch {
    Write-Error "Failed to upload: $_"
    return;
}
$swMain.Stop();
Write-Host "Runtime: $($swMain.Elapsed.Hours)hr $($swMain.Elapsed.Minutes)min $($swMain.Elapsed.Seconds)s $($swMain.Elapsed.Milliseconds)ms";