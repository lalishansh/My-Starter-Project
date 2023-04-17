param(
	[String][Parameter(Mandatory)]$DirPath,
	[String]$CompressedFileNameIfRequired="compressed_files"
)

$files = Get-ChildItem -Path $DirPath -File
$fileCount = $files.Count

if ($fileCount -eq 0) {
	Write-Warning "No files in the directory."
	return 0
} elseif ($fileCount -eq 1) {
	$single_file_path = $files[0].FullName
	$relative_single_file_path = (Resolve-Path -Path $single_file_path -Relative).Replace('.\', '')
	return $relative_single_file_path
} else {
	$zip_file_path = Join-Path $DirPath "$CompressedFileNameIfRequired"
	Compress-Archive -Path (Join-Path $DirPath "*") -DestinationPath $zip_file_path
	
	foreach ($file in $files) {
		Remove-Item -Path $file.FullName -Force
	}
	
	$relative_zip_file_path = (Resolve-Path -Path "$zip_file_path*" -Relative).Replace('.\', '')
	return $relative_zip_file_path
}
