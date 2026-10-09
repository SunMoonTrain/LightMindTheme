param(
    [switch]$Watch,
    [string]$ThemeDirectory = "$env:APPDATA\Typora\themes"
)

$sourceDirectory = Split-Path -Parent $PSCommandPath
$themeFiles = @("lightmind.css", "lightmind-dark.css", "lightmind-cyber.css")

function Sync-TyporaThemes {
    if (!(Test-Path -LiteralPath $ThemeDirectory -PathType Container)) {
        throw "Typora 主题目录不存在: $ThemeDirectory"
    }

    foreach ($themeFile in $themeFiles) {
        $source = Join-Path $sourceDirectory $themeFile
        $destination = Join-Path $ThemeDirectory $themeFile

        if (!(Test-Path -LiteralPath $source -PathType Leaf)) {
            throw "主题文件不存在: $source"
        }

        if ((Test-Path -LiteralPath $destination -PathType Leaf) -and
            (Get-FileHash -LiteralPath $source).Hash -eq (Get-FileHash -LiteralPath $destination).Hash) {
            continue
        }

        Copy-Item -LiteralPath $source -Destination $destination -Force
        Write-Host "已同步: $themeFile"
    }
}

Sync-TyporaThemes

if (!$Watch) {
    return
}

Write-Host "正在监听主题文件，按 Ctrl+C 停止。"
while ($true) {
    Start-Sleep -Seconds 1
    Sync-TyporaThemes
}
