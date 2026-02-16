$flutterPluginsContent = Get-Content "$PWD\.flutter-plugins"

$counts = @{}

foreach ($plugin_path in $flutterPluginsContent) {
    if (-not ($plugin_path -match '=')) {
        continue
    }

    $plugin_path = $plugin_path.Split('=')[1].Trim().Replace("\\", "\")

    $plugin_name = $plugin_path.TrimEnd('\').Split('\')[-1]

    $gradle_file = Join-Path $plugin_path "android/build.gradle"

    if (-not (Test-Path $gradle_file)) {
        continue
    }

    $target = (Select-String -Path $gradle_file -Pattern 'compileSdk').Line.Trim().Replace(" ", "").Replace("=", "").Replace("Version", "")

    if ($counts.ContainsKey($target)) {
        $counts[$target]++
    } else {
        $counts[$target] = 1
    }

    Write-Output "$plugin_name wants to be compiled against $target"
}

foreach ($key in $counts.Keys) {
    "$key $($counts[$key])"
}
