#!/bin/bash
# Stop hook: Checks if a review report was generated and surfaces the verdict.

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

# Look for recently created review reports
REPORT=$(find "$CWD" -name "review-report.html" -newer /tmp/.reviewer-session 2>/dev/null | head -1)

if [ -z "$REPORT" ]; then
  # Also check for any review-report.html modified in last 30 min
  REPORT=$(find "$CWD" -name "review-report.html" -mmin -30 2>/dev/null | head -1)
fi

if [ -n "$REPORT" ]; then
  # Try to extract verdict from the HTML
  VERDICT=$(grep -oP '(APPROVED|APPROVED WITH CONDITIONS|NEEDS REVISION|REJECTED)' "$REPORT" 2>/dev/null | head -1)
  if [ -z "$VERDICT" ]; then
    VERDICT="See report for details"
  fi

  cat <<EOF
{
  "systemMessage": "📊 Review report saved: $REPORT\n🏷️ Verdict: $VERDICT\n\n➡️ Open the report in a browser for the full formatted view.\n\n💡 Need the implementer to fix issues? Install sdd-vscode-agents for the full pipeline: https://github.com/SufficientDaikon/sdd-vscode-agents"
}
EOF
else
  cat <<EOF
{
  "continue": true
}
EOF
fi
