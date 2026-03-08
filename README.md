# copilot-reviewer

> **Part of [sdd-vscode-agents](https://github.com/SufficientDaikon/sdd-vscode-agents)** — install the full collection for the complete SDD pipeline + UI/UX lifecycle.

A VS Code Copilot agent plugin that compares implementation against specifications and produces comprehensive HTML compliance reports.

## What it does

The **reviewer** agent takes a specification and an implementation, then systematically audits:

- **User story coverage** — Is each story implemented with passing tests?
- **Functional requirements** — Is each FR-001, FR-002... correctly implemented?
- **Non-functional requirements** — Performance, security, accessibility met?
- **Success criteria** — Are SC-001, SC-002... verifiable?
- **Edge cases** — Are error scenarios handled?
- **Code quality** — Readability, patterns, test coverage?

Produces a self-contained **HTML report** (`review-report.html`) with:

- Executive summary with compliance score
- Requirements traceability matrix (FR → Code → Test)
- Color-coded findings (Critical/Major/Minor)
- Verdict: APPROVED / APPROVED WITH CONDITIONS / NEEDS REVISION / REJECTED

## Hooks included

| Hook                          | Event          | What it does                                                                                                                                      |
| ----------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Spec & code detection**     | `SessionStart` | Auto-detects spec files, tasks.md, test files, existing reports, project type, and git branch — injects context so the agent knows what to review |
| **Review completion summary** | `Stop`         | When the session ends, checks if a review report was generated, extracts the verdict, and displays it with the report path                        |

## Install

### Via Copilot CLI

```bash
copilot plugin install SufficientDaikon/copilot-reviewer
```

### Via VS Code settings

Clone the repo and add to your `settings.json`:

```json
"chat.plugins.paths": {
    "/path/to/copilot-reviewer": true
}
```

### Via local path

```bash
git clone https://github.com/SufficientDaikon/copilot-reviewer.git
copilot plugin install ./copilot-reviewer
```

## Usage

Switch to the **reviewer** agent in VS Code chat, then:

```
Review the implementation against the spec at ./specs/product-search.spec.md
```

**Expected output**: A comprehensive `review-report.html` saved to your project directory with compliance scores, findings, and recommendations.

### More examples

```
Audit this codebase against the specification in ./docs/api-spec.md.
Focus on functional requirements coverage and test completeness.
```

```
Review the implementation for spec compliance. The spec is at
./specs/library-api.spec.md and the code is in ./src/
```

## Scoring

| Score   | Verdict                     | Meaning               |
| ------- | --------------------------- | --------------------- |
| 95-100% | ✅ APPROVED                 | Ship it               |
| 80-94%  | ⚠️ APPROVED WITH CONDITIONS | Minor fixes needed    |
| 60-79%  | 🔶 NEEDS REVISION           | Significant gaps      |
| <60%    | ❌ REJECTED                 | Major rework required |

## The full SDD pipeline

This agent is designed to work in a pipeline:

```
spec-writer  →  implementer  →  reviewer
  (specs it)      (codes it)      (you)
```

Install the full collection to get all three:

```bash
copilot plugin install SufficientDaikon/sdd-vscode-agents
```

## File structure

```
copilot-reviewer/
├── plugin.json                              # Plugin manifest
├── hooks.json                               # Hook configuration
├── agents/
│   └── reviewer.agent.md                    # Agent definition
└── scripts/
    ├── detect-spec-and-code.sh              # SessionStart hook (Unix)
    ├── detect-spec-and-code.ps1             # SessionStart hook (Windows)
    ├── on-review-complete.sh                # Stop hook (Unix)
    └── on-review-complete.ps1               # Stop hook (Windows)
```

## License

MIT
