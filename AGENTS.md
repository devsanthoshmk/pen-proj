# DocGen System — Global Rules (AGENTS.md)

> Every agent in this project **MUST** read and follow these rules in full before taking any action.
> These rules are the single source of truth for formatting, behavior, and workflow.

---

REMEMBER THIS THE CONTENTS IN MY PRESENTAIONS THAT I ATTACHED EARLIER SHOULD NOT BE CHANGED IN ANY PLACE IN THE REPORT
my PRESENTAIONS:
/PROMPT/presentation-1.md
/PROMPT/presentation-2.md


## 2. Markdown Formatting Standards

- **Headings:** Use `##` for chapter titles, `###` for major sections, `####` for subsections. Never use `#` (reserved for document title only, written by architect).
- **Tables:** All tables must have header rows and alignment separators.
- **Code blocks:** Always specify the language identifier (e.g., ` ```python `, ` ```bash `).
- **Mermaid diagrams:** All diagrams must pass the mermaid-linter before inclusion. See §5.
- **Bold / Italic:** Bold (`**text**`) for key terms on first use. Italic (`*text*`) for titles and emphasis.
- **Line length:** Prose paragraphs must not exceed 100 characters per line in source.
- **Blank lines:** Always one blank line before and after headings, code blocks, tables, and diagrams.

---

## 5. Mermaid Diagram Rules

- All diagrams **must** be validated by `@mermaid-linter` before inclusion.
- Never include unvalidated Mermaid code in a submission.
- Diagrams must have a `%%` comment on the first line with the diagram title.
- Use `flowchart TD` for process flows, `sequenceDiagram` for interactions, `classDiagram` for architecture, `gantt` for timelines.
- Maximum 20 nodes per flowchart. Split larger diagrams.
- Always include a figure caption directly below the closing fence: `*Figure N: Description*`

---

## 6. Anti-Hallucination Rules

- Do NOT invent statistics, names, dates, or product version numbers.
- Do NOT write "as mentioned earlier" without first verifying via memory query that it was actually covered.
- Do NOT contradict a prior chapter. Cross-reference the `chapter_registry` in memory.
- If uncertain about a fact, use `webfetch` to verify before writing it.