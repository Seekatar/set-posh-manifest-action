<#
.SYNOPSIS
Helper script to set the version of a Manifest

.DESCRIPTION
A thin wrapper over Update-ModuleManifest as a exercise in creating a GitHub Action

.PARAMETER ManifestPath
The path to the existing psd1 file

.PARAMETER Revision
Revision number, not valid for SemVer.

.PARAMETER Build
Build number.  If not supplied, used the one in the manifest

.PARAMETER Minor
Minor version number.  If not supplied, used the one in the manifest

.PARAMETER Major
Major version number.  If not supplied, used the one in the manifest

.PARAMETER Prerelease
Set the Prerelease value, if not supplied will clear it.

.PARAMETER CommitSHA
Save the CommitSHA in PrivateData

.EXAMPLE
..\Build\Update-ManifestVersion.ps1 .\joat-config.psd1 1

#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateScript( {Test-Path $_ -PathType Leaf})]
    [Parameter(Mandatory)]
    [string] $ManifestPath,
    [int] $Major = -1,
    [int] $Minor = -1,
    [int] $Build = -1,
    [int] $Revision = -1,
    [string] $Prerelease,
    [string] $CommitSha
)

Set-StrictMode -Version Latest

$manifest = Test-ModuleManifest -Path $ManifestPath -Verbose:$false

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

if ( $PSCmdlet.ShouldProcess($ManifestPath, "Set module manifest data"))
{
    $prevVerbose = $VerbosePreference
    $VerbosePreference = 'SilentlyContinue' # avoid Update-ModuleManifest dumping module load it may do

    $parms = @{
        Path = $ManifestPath
        ModuleVersion = $newVersion
        Verbose = $false
        Prerelease = $Prerelease
    }
    if ($CommitSha) {
        $parms['PrivateData'] = @{ CommitSHA = $CommitSha }
    }
    Update-ModuleManifest @parms

    $VerbosePreference = $prevVerbose

    # strip trailing whitespace the above command adds since that triggers Analyzer warnings
    $temp = New-TemporaryFile
    Get-Content $ManifestPath | ForEach-Object { $_.TrimEnd(); } | Out-File -Append -FilePath $temp -Encoding utf8
    Copy-Item $temp $ManifestPath
    Remove-Item $temp
}
