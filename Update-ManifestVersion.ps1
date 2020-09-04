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
    [Parameter(Mandatory)]
    [int] $Revision,
    [int] $Build = -1,
    [int] $Minor = -1,
    [int] $Major = -1
)

Set-StrictMode -Version Latest

Write-Verbose "$ManifestPath $Major.$Minor.$Build.$Revision"
