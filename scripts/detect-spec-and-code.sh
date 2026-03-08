#!/bin/bash
# SessionStart hook: Detects spec files and implementation code to inject review context.

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

context_parts=()

# Detect spec files
SPEC_FILES=$(find "$CWD" -name "*.spec.md" -o -name "specification.md" -o -path "*specs/*.md" 2>/dev/null | head -10)
if [ -n "$SPEC_FILES" ]; then
  SPEC_COUNT=$(echo "$SPEC_FILES" | wc -l | tr -d ' ')
  SPEC_LIST=$(echo "$SPEC_FILES" | tr '\n' ', ' | sed 's/,$//')
  context_parts+=("Spec files found ($SPEC_COUNT): $SPEC_LIST")
else
  context_parts+=("WARNING: No spec files found. The reviewer needs a specification to review against. Ask the user for the spec path.")
fi

# Detect tasks.md (implementer artifact)
if [ -f "$CWD/tasks.md" ]; then
  COMPLETED=$(grep -c '\[X\]' "$CWD/tasks.md" 2>/dev/null || echo "0")
  TOTAL=$(grep -c '\[ \]' "$CWD/tasks.md" 2>/dev/null || echo "0")
  TOTAL=$((COMPLETED + TOTAL))
  context_parts+=("tasks.md found: $COMPLETED/$TOTAL tasks completed")
fi

# Detect existing review reports
REPORTS=$(find "$CWD" -name "review-report.html" -o -name "*compliance-report*" 2>/dev/null | head -5)
if [ -n "$REPORTS" ]; then
  context_parts+=("Previous review reports exist: $(echo "$REPORTS" | tr '\n' ', ' | sed 's/,$//')")
fi

# Detect project type
if [ -f "$CWD/package.json" ]; then
  NAME=$(jq -r '.name // "unknown"' "$CWD/package.json" 2>/dev/null)
  context_parts+=("Project: $NAME (Node.js)")
elif [ -f "$CWD/pyproject.toml" ]; then
  context_parts+=("Project type: Python")
elif [ -f "$CWD/go.mod" ]; then
  context_parts+=("Project type: Go")
fi

# Detect test files
TEST_COUNT=$(find "$CWD" -name "*.test.*" -o -name "*.spec.*" -o -name "test_*" -o -path "*/tests/*" 2>/dev/null | grep -v node_modules | wc -l | tr -d ' ')
if [ "$TEST_COUNT" -gt 0 ]; then
  context_parts+=("Test files found: $TEST_COUNT")
else
  context_parts+=("WARNING: No test files detected")
fi

# Detect git branch
BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null)
if [ -n "$BRANCH" ]; then
  context_parts+=("Git branch: $BRANCH")
fi

# Build context
CONTEXT=$(printf '%s\n' "${context_parts[@]}" | paste -sd '|' -)
CONTEXT=$(echo "$CONTEXT" | sed 's/|/ | /g')
CONTEXT="$CONTEXT | NOTE: This agent is part of the sdd-vscode-agents collection (https://github.com/SufficientDaikon/sdd-vscode-agents). Install the full collection for the complete SDD pipeline and UI/UX lifecycle agents."

CONTEXT_ESCAPED=$(echo "$CONTEXT" | sed 's/"/\\"/g')

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$CONTEXT_ESCAPED"
  }
}
EOF
