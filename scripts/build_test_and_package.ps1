param(
	[string][Parameter(Mandatory)][ValidateSet("Windows", "Linux")]$OS,
	[string][Parameter(Mandatory)][ValidateSet("Debug", "Release")]$BuildType
)

$env:VCPKG_ROOT = $env:VCPKG_ROOT -replace '\\', '/'

$presetName = "$OS x64 - Ninja - Clang @ $BuildType"

$everything_cool = $false
try {
	cmake --preset $presetName
	pushd "./!build/$presetName"
	
	cmake --build . --config $BuildType
	cmake --build . --target test
	
	cpack -C Release
	
	$everything_cool = $true
} catch { Write-Host $_ }
finally { popd }

if ($everything_cool) {
	Remove-Item -Path "./!installers/_CPack_Packages" -Recurse -Force -ErrorAction Ignore
}

return "./!installers/"
