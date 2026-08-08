# fix_build.ps1
param(
  [string]$ProjectRoot = (Get-Location).Path
)

Write-Host "Project root: $ProjectRoot"
Push-Location $ProjectRoot

# Stop gradle daemons
if (Test-Path "$ProjectRoot\android\gradlew") {
  Write-Host "Stopping Gradle daemons..."
  Push-Location "$ProjectRoot\android"
  & .\gradlew --stop
  Pop-Location
}

Write-Host "Running flutter clean..."
flutter clean

# Confirm destructive deletes
$yn = Read-Host "Delete local build and .gradle folders in project? (y/N)"
if ($yn -eq 'y' -or $yn -eq 'Y') {
  Write-Host "Deleting .gradle, build, android\.gradle, android\app\build ..."
  Remove-Item -Recurse -Force ".gradle" -ErrorAction SilentlyContinue
  Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue
  Remove-Item -Recurse -Force "android\.gradle" -ErrorAction SilentlyContinue
  Remove-Item -Recurse -Force "android\app\build" -ErrorAction SilentlyContinue
}

# Optionally disable kotlin incremental
$yn2 = Read-Host "Temporarily set kotlin.incremental=false in android/gradle.properties? (y/N)"
if ($yn2 -eq 'y' -or $yn2 -eq 'Y') {
  $propFile = Join-Path $ProjectRoot "android\gradle.properties"
  if (Test-Path $propFile) {
    if (-not (Select-String -Path $propFile -Pattern "^kotlin\.incremental=" -Quiet)) {
      Add-Content -Path $propFile -Value "`n# Added to avoid incremental cache issues`nkotlin.incremental=false"
      Write-Host "Added kotlin.incremental=false"
    } else {
      Write-Host "kotlin.incremental already present"
    }
  } else {
    Write-Host "gradle.properties not found at $propFile"
  }
}

Write-Host "Fetching packages..."
flutter pub get

Write-Host "You can now try a build. For more details run:"
Write-Host "  flutter run -v > run_verbose_log.txt 2>&1"
Write-Host "or (android folder): ./gradlew assembleDebug --stacktrace --info > gradle_build_log.txt 2>&1"

Pop-Location