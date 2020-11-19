# set-posh-manifest-action
This GitHub Action will set the version in a PowerShell module manifest file. The [Version](https://docs.microsoft.com/en-us/dotnet/api/system.version?view=netcore-3.1) object in the manifest should three levels to be in line with [semantic versioning](https://semver.org/). Typically this action would just set the Build number (Patch in semantic terms).

![Status](https://github.com/Seekatar/set-posh-manifest-action/workflows/PesterTest/badge.svg)

## Using set-posh-manifest-action

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Set Manifest Version
        uses: seekatar/set-posh-manifest-action@v1.1
        with:
            manifest-path: tests/test.psd1
            build: ${{ github.run_number }}
            commitSHA: ${{ github.sha }}
```

This will edit `tests/test.psd1` and update the current version in the manifest to the `run_number`. The Major and Minor remain the same. You can also pass in Major, Minor, or Revision to set those, but usually you'd set those in the manifest.

## Building and Publishing this Action

The doc for creating Actions is [here](https://docs.github.com/en/free-pro-team@latest/actions/creating-actions). This is considered to be a [composite action](https://docs.github.com/en/free-pro-team@latest/actions/creating-actions/creating-a-composite-run-steps-action).

To "publish" it you simply push to the repo and tag it

```powershell
git tag -am "Description of this release" v1.1
git push --follow-tags
```

 The `action.yml` file describes the Action for Github.
