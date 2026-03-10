<div align="center">

<img src="https://img.shields.io/badge/VS%20Code%20Copilot%20Agent-Compliance%20Reviewer-A177FE?style=for-the-badge&logo=github-copilot&logoColor=white" />

# copilot-reviewer

*Reviews implementation against the original specification for compliance.*

[![Part of SDD Agent Suite](https://img.shields.io/badge/Part%20of-SDD%20Agent%20Suite-A177FE?style=flat-square)](https://github.com/SufficientDaikon/sdd-vscode-agents)

</div>

---

## What It Does

The **Reviewer** agent is your quality gatekeeper. It takes an implementation and compares it against the original specification, producing a detailed compliance report that identifies gaps, deviations, and quality issues.

It generates a comprehensive HTML/CSS report with section-by-section scoring, highlighting what was implemented correctly, what was missed, and what deviated from the spec. Each finding includes specific file references and actionable recommendations.

Use the Reviewer as the final checkpoint before merging — it catches the subtle spec violations that manual code review often misses, ensuring your implementation truly matches what was specified.

## Features

- ✅ Gap analysis between spec and implementation
- ✅ Deviation detection with severity scoring
- ✅ Comprehensive HTML/CSS compliance report output
- ✅ Actionable recommendations for each finding

## Installation

1. Install the [SDD VS Code Agents](https://github.com/SufficientDaikon/sdd-vscode-agents) extension
2. Open VS Code Copilot Chat
3. Use `@reviewer` to invoke this agent

## Usage

```
@reviewer Review the auth implementation against the original spec
```

## Part of the SDD Agent Suite

This agent is one of 13 specialized Copilot Chat participants in the [SDD VS Code Agents](https://github.com/SufficientDaikon/sdd-vscode-agents) ecosystem.

| Agent | Role |
|---|---|
| **spec-writer** | Specification Architect |
| **implementer** | Implementation Engineer |
| **reviewer** | Compliance Reviewer |
| **packager** | Package Engineer |
| **ui-lifecycle-master** | UI Lifecycle Orchestrator |
| **ux-research** | UX Researcher |
| **info-arch** | Information Architect |
| **wireframe** | Wireframe Designer |
| **ui-design** | Visual Designer |
| **ux-design** | UX Designer |
| **frontend-impl** | Frontend Engineer |
| **design-reviewer** | Design Reviewer |
| **ux-testing** | UX Tester |

## License

MIT
