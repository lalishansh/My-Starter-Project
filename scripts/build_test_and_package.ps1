param(
	[string][Parameter(Mandatory)][ValidateSet("Windows", "Linux")]$OS,
	[string][Parameter(Mandatory)][ValidateSet("Debug", "Release")]$BuildType,
	[string]$VCPKG_ROOT="$env:VCPKG_ROOT"
)

$env:VCPKG_ROOT = $env:VCPKG_ROOT -replace '\\', '/'

$presetName = "$OS x64 - Ninja - Clang @ $BuildType"

Push-Location "$PSScriptRoot/.."
$everything_cool = $false
try {
	cmake --preset $presetName -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
	
	$installers_dir = "$PWD/!installers"
	Push-Location "$PWD/!build/$presetName"
	
	cmake --build . --config $BuildType
	cmake --build . --target test
	
	cpack -C Release
	
	$everything_cool = $true
} catch { Write-Host $_ }
finally { popd }


if ($everything_cool) {
	Remove-Item -Path "$installers_dir/_CPack_Packages" -Recurse -Force -ErrorAction Ignore
}

Pop-Location

return $installers_dir
