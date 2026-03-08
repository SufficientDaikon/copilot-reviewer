# Stop hook: Checks if a review report was generated and surfaces the verdict.

$input = [Console]::In.ReadToEnd() | ConvertFrom-Json
$cwd = if ($input.cwd) { $input.cwd } else { Get-Location }

# Look for review reports modified in the last 30 minutes
$cutoff = (Get-Date).AddMinutes(-30)
$report = Get-ChildItem -Path $cwd -Recurse -Filter "review-report.html" -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -gt $cutoff } |
    Select-Object -First 1

if ($report) {
    # Try to extract verdict from HTML
    $content = Get-Content $report.FullName -Raw -ErrorAction SilentlyContinue
    $verdict = "See report for details"
    if ($content -match '(APPROVED WITH CONDITIONS|APPROVED|NEEDS REVISION|REJECTED)') {
        $verdict = $Matches[0]
    }

    $msg = "Review report saved: $($report.FullName)`nVerdict: $verdict`n`nOpen the report in a browser for the full formatted view.`n`nNeed the implementer to fix issues? Install sdd-vscode-agents for the full pipeline: https://github.com/SufficientDaikon/sdd-vscode-agents"

    $output = @{
        systemMessage = $msg
    } | ConvertTo-Json -Compress

    Write-Host $output
}
else {
    Write-Host '{"continue":true}'
}
