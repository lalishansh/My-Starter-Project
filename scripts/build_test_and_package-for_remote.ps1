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

Write-Host "Configuring project for OS: $os and Build Type: $build_type"
Write-Host $(cmake -B build -S . -DCMAKE_BUILD_TYPE=$build_type -DCMAKE_TOOLCHAIN_FILE=$PWD/vcpkg/scripts/buildsystems/vcpkg.cmake)

Write-Host "Building project"
Write-Host $(cmake --build build)

Write-Host "Testing project"
Write-Host $(cmake --build build --target test)

Write-Host "Packaging project"
Write-Host $(cmake --install build --prefix install --component Runtime --strip --verbose)
