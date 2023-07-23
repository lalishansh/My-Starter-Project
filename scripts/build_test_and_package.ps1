param(
	[string][Parameter(Mandatory)][ValidateSet("Windows", "Linux")]$OS,
	[string][Parameter(Mandatory)][ValidateSet("Debug", "Release")]$BuildType,

	[string]$VCPKG_ROOT="$env:VCPKG_ROOT",
	[string]$Arch = "x64",
	[string]$Generator = "Ninja",
	[string]$Compiler = "Clang",
)

$env:VCPKG_ROOT = $env:VCPKG_ROOT -replace '\\', '/'

$presetName = "$OSArch - $Generator - $Compiler @ $BuildType"

Push-Location "$PSScriptRoot/.."
$everything_cool = $false
try {
	cmake --preset $presetName -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
	
	$installers_dir = "$PWD/!installers"
	Push-Location "$PWD/!build/$presetName"
	
	cmake --build . --config $BuildType
	cmake --build . --target test
	
	cpack -C $BuildType #OR cpack .
	ctest -C $BuildType --output-on-failure
	
	$everything_cool = $true
} catch { Write-Error $_ }
finally { Pop-Location }

if ($everything_cool) {
	Remove-Item -Path "$installers_dir/_CPack_Packages" -Recurse -Force -ErrorAction Ignore
}

Pop-Location

return $installers_dir
