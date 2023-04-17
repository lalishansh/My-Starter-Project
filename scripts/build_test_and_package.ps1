param(
	[string][Parameter(Mandatory)]$os,
	[string][Parameter(Mandatory)]$build_type
)

if (-not $os) {
	$os = "windows-latest"
}

if (-not $build_type) {
	$build_type = "Debug"
}

$env:VCPKG_ROOT = "$env:VCPKG_ROOT" -replace '\\', '/'

Write-Host "Configuring project for OS: $os and Build Type: $build_type"
cmake -B build -S . -DCMAKE_BUILD_TYPE=$build_type

Write-Host "Building project"
cmake --build build

Write-Host "Testing project"
cmake --build build --target test

Write-Host "Packaging project"
cmake --install build --prefix install --component Runtime --strip --verbose
