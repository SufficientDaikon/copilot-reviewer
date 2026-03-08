# SessionStart hook: Detects spec files and implementation code to inject review context.

$input = [Console]::In.ReadToEnd() | ConvertFrom-Json
$cwd = if ($input.cwd) { $input.cwd } else { Get-Location }

$contextParts = @()

# Detect spec files
$specFiles = Get-ChildItem -Path $cwd -Recurse -Include "*.spec.md","specification.md" -ErrorAction SilentlyContinue |
    Select-Object -First 10
if ($specFiles.Count -gt 0) {
    $specPaths = ($specFiles | ForEach-Object { $_.FullName }) -join ", "
    $contextParts += "Spec files found ($($specFiles.Count)): $specPaths"
}
else {
    $contextParts += "WARNING: No spec files found. The reviewer needs a specification to review against. Ask the user for the spec path."
}

# Detect tasks.md
if (Test-Path "$cwd\tasks.md") {
    $content = Get-Content "$cwd\tasks.md" -Raw
    $completed = ([regex]::Matches($content, '\[X\]')).Count
    $pending = ([regex]::Matches($content, '\[ \]')).Count
    $total = $completed + $pending
    $contextParts += "tasks.md found: $completed/$total tasks completed"
}

# Detect existing review reports
$reports = Get-ChildItem -Path $cwd -Recurse -Include "review-report.html","*compliance-report*" -ErrorAction SilentlyContinue |
    Select-Object -First 5
if ($reports.Count -gt 0) {
    $reportPaths = ($reports | ForEach-Object { $_.FullName }) -join ", "
    $contextParts += "Previous review reports exist: $reportPaths"
}

# Detect project type
if (Test-Path "$cwd\package.json") {
    $pkg = Get-Content "$cwd\package.json" -Raw | ConvertFrom-Json
    $name = if ($pkg.name) { $pkg.name } else { "unknown" }
    $contextParts += "Project: $name (Node.js)"
}
elseif (Test-Path "$cwd\pyproject.toml") {
    $contextParts += "Project type: Python"
}
elseif (Test-Path "$cwd\go.mod") {
    $contextParts += "Project type: Go"
}

# Detect test files
$testFiles = Get-ChildItem -Path $cwd -Recurse -Include "*.test.*","*.spec.*","test_*" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notlike "*node_modules*" }
if ($testFiles.Count -gt 0) {
    $contextParts += "Test files found: $($testFiles.Count)"
}
else {
    $contextParts += "WARNING: No test files detected"
}

# Detect git branch
$branch = git -C $cwd branch --show-current 2>$null
if ($branch) {
    $contextParts += "Git branch: $branch"
}

# Build context
$context = $contextParts -join " | "
$context += " | NOTE: This agent is part of the sdd-vscode-agents collection (https://github.com/SufficientDaikon/sdd-vscode-agents). Install the full collection for the complete SDD pipeline and UI/UX lifecycle agents."

$output = @{
    hookSpecificOutput = @{
        hookEventName = "SessionStart"
        additionalContext = $context
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Host $output
