
Set-Location $PSScriptRoot

Describe "Tests Manifest Version" {
    It "Checks 4-level version" {

        $temp = "$(New-TemporaryFile).psd1"
        Copy-Item .\test.psd1 $temp

        ..\Update-ManifestVersion.ps1 -ManifestPath $temp -Major 9 -Minor 8 -Build 7 -Revision 6

        $manifest = Test-ModuleManifest -Path $temp -Verbose:$false
        Write-Warning "$($manifest.Version) $([Version]"9.8.7.6")"
        $manifest.Version | Should -be ([Version]"9.8.7.6")
    }

    It "Checks 3-level version" {

        $temp = "$(New-TemporaryFile).psd1"
        Copy-Item .\test.psd1 $temp

        ..\Update-ManifestVersion.ps1 -ManifestPath $temp -Major 9 -Minor 8 -Build 7

        $manifest = Test-ModuleManifest -Path $temp -Verbose:$false
        Write-Warning "$($manifest.Version) $([Version]"9.8.7")"
        $manifest.Version | Should -be ([Version]"9.8.7")
    }

    It "Checks 2-level version" {

        $temp = "$(New-TemporaryFile).psd1"
        Copy-Item .\test.psd1 $temp

        ..\Update-ManifestVersion.ps1 -ManifestPath $temp -Major 9 -Minor 8

        $manifest = Test-ModuleManifest -Path $temp -Verbose:$false
        Write-Warning "$($manifest.Version) $([Version]"9.8.0")"
        $manifest.Version | Should -be ([Version]"9.8.0")
    }

    It "Sets only revision" {

        $temp = "$(New-TemporaryFile).psd1"
        Copy-Item .\test.psd1 $temp

        ..\Update-ManifestVersion.ps1 -ManifestPath $temp -Revision 99

        $manifest = Test-ModuleManifest -Path $temp -Verbose:$false
        Write-Warning "$($manifest.Version) $([Version]"0.1.0.99")"
        $manifest.Version | Should -be ([Version]"0.1.0.99")
    }

    # most typical case to set build during build
    It "Sets only build" {

        $temp = "$(New-TemporaryFile).psd1"
        Copy-Item .\test.psd1 $temp

        ..\Update-ManifestVersion.ps1 -ManifestPath $temp -Build 99

        $manifest = Test-ModuleManifest -Path $temp -Verbose:$false
        $manifest.Version | Should -be ([Version]"0.1.99")
    }
    It "Sets only build" {

        $temp = "$(New-TemporaryFile).psd1"
        Copy-Item .\test.psd1 $temp

        ..\Update-ManifestVersion.ps1 -ManifestPath $temp -Build 99

        $manifest = Test-ModuleManifest -Path $temp -Verbose:$false
        $manifest.Version | Should -be ([Version]"0.1.299")
    }
}