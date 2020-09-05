<#
.SYNOPSIS
Helper script to set the version of a Manifest

.PARAMETER ManifestPath
The path to the existing psd1 file

.PARAMETER Revision
Revision number.  Must be supplied

.PARAMETER Build
Build number.  If not supplied, used the one in the manifest

.PARAMETER Minor
Minor version number.  If not supplied, used the one in the manifest

.PARAMETER Major
Major version number.  If not supplied, used the one in the manifest

.EXAMPLE
..\Build\Update-ManifestVersion.ps1 .\joat-config.psd1 1

#>
[CmdletBinding(SupportsShouldProcess)]
param(
    # [ValidateScript( {Test-Path $_ -PathType Leaf})]
    [Parameter(Mandatory)]
    [string] $ManifestPath,
    [int] $Major = -1,
    [int] $Minor = -1,
    [int] $Build = -1,
    [int] $Revision = -1
)

Set-StrictMode -Version Latest
$manifest = Test-ModuleManifest -Path $ManifestPath -Verbose:$false
Write-Warning "Got manifest version from file of $($manifest.Version)"
Write-Warning (gc $ManifestPath -Raw)

$verFormat = "{0}.{1}.{2}.{3}"
if ( $Revision -eq -1 )
{
    $Revision = $manifest.Version.Revision
}
if ( $Revision -eq -1 )
{
    $verFormat = "{0}.{1}.{2}"
}

if ( $Build -eq -1 )
{
    $Build = $manifest.Version.Build
}
if ( $Build -eq -1 )
{
    $verFormat = "{0}.{1}"
}
if ( $Minor -eq -1 )
{
    $Minor = $manifest.Version.Minor
}
if ( $Major -eq -1 )
{
    $Major = $manifest.Version.Major
}
$newVersion = $verformat -f $Major, $Minor, $Build, $Revision
Write-Warning "Setting new version $($newVersion)"

if ( $PSCmdlet.ShouldProcess($ManifestPath, "Set module version to $newVersion"))
{
    Update-ModuleManifest -Path $ManifestPath -ModuleVersion $newVersion -Verbose:$false
    # strip trailing whitespace the above command adds
    $temp = New-TemporaryFile
    Get-Content $ManifestPath | ForEach-Object { $_.TrimEnd(); } | Out-File -Append -FilePath $temp -Encoding utf8
    Copy-Item $temp $ManifestPath
    Remove-Item $temp
}
