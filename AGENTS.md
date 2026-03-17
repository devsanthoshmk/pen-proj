# DocGen System — Global Rules (AGENTS.md)

> Every agent in this project **MUST** read and follow these rules in full before taking any action.
> These rules are the single source of truth for formatting, behavior, and workflow.

---

## 1. Memory-First Protocol

**Before writing a single word of content, every agent MUST:**

1. Call `@memory-librarian` to query the memory graph for:
   - `project_globals` entity (document title, audience, tone, style guide)
   - `style_rules` entities (heading levels, citation format, diagram conventions)
   - `chapter_registry` entity (list of completed chapters and their anchor IDs)
   - Any entity directly related to your assigned section topic

2. After completing your task, call `@memory-librarian` to store:
   - A `chapter_summary` entity with: section title, anchor ID, key topics, word count
   - Any new `style_rules` or `terminology` entities you introduced
   - Relations between your section and prior sections it references

**Never assume you know the current state of the document. Always query first.**

---

## 2. Markdown Formatting Standards

- **Headings:** Use `##` for chapter titles, `###` for major sections, `####` for subsections. Never use `#` (reserved for document title only, written by architect).
- **Tables:** All tables must have header rows and alignment separators.
- **Code blocks:** Always specify the language identifier (e.g., ` ```python `, ` ```bash `).
- **Mermaid diagrams:** All diagrams must pass the mermaid-linter before inclusion. See §5.
- **Bold / Italic:** Bold (`**text**`) for key terms on first use. Italic (`*text*`) for titles and emphasis.
- **Line length:** Prose paragraphs must not exceed 100 characters per line in source.
- **Blank lines:** Always one blank line before and after headings, code blocks, tables, and diagrams.

---

## 3. Citation & Research Standards

- Every factual claim that is not general knowledge **must** have an inline citation.
- Citation format: `[^N]` inline, with `[^N]: Author, *Title*, URL, Year` in a `## References` section at the end of the chapter.
- Citations must be numbered sequentially per chapter (reset to `[^1]` each chapter).
- Web-fetched sources: always include the fetch date as `(accessed YYYY-MM-DD)`.
- Do NOT fabricate citations. If you cannot find a source, write `[citation needed]` and flag it in your submission summary.

---

## 4. Section Submission Format

When a subagent finishes a section, it must submit **both**:

### A. The Markdown Draft
Full section content, ready to be appended to the document.

### B. The Submission Summary (JSON block)
Submit this at the very end of your response, wrapped in a fenced code block:

```json
{
  "section_title": "string",
  "anchor_id": "string (kebab-case, e.g. introduction-overview)",
  "word_count": 0,
  "citations_used": 0,
  "diagrams": ["list of diagram titles"],
  "new_terminology": ["list of new technical terms defined"],
  "unresolved_flags": ["any [citation needed] or TODO items"],
  "memory_writes_completed": true
}
```

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

---

## 7. Red-Team Validation Triggers (Architect Only)

The architect agent MUST reject a section and send it back if ANY of these are true:

- [ ] Missing or fabricated citations on factual claims
- [ ] Mermaid code blocks that have not been linter-validated
- [ ] Contradictions with entities stored in the memory graph
- [ ] Submission summary JSON is missing or malformed
- [ ] Word count is below 800 words for a major section
- [ ] Section contains generic filler ("It is important to note that...", "As we can see...")
- [ ] New terminology introduced without definition
- [ ] Memory writes not confirmed (memory_writes_completed: false)

---

## 8. Git Commit Convention

After every approved chapter, the architect runs:

```bash
git add docs/
git commit -m "docs(chapter-N): add [section-title] — [word_count]w, [citations]refs"
```

---

## 9. Human-in-the-Loop Checkpoints

The architect **MUST** pause and ask the human for approval at:

1. **After outline is drafted** — before any writing begins
2. **After 25% of chapters complete** — style/tone check
3. **After 50% of chapters complete** — structural review
4. **After 75% of chapters complete** — final direction check
5. **Before final assembly** — confirm nothing is missing

Do NOT proceed past a checkpoint without explicit human confirmation.

---

## 10. File Output Convention

- All chapter drafts go to: `docs/chapters/XX-section-name.md` (XX = zero-padded number)
- Final assembled document goes to: `docs/FINAL-[document-title].md`
- Mermaid temp files: `/tmp/mermaid-XXXX.mmd` (auto-cleaned)
- Memory snapshots: `docs/memory-snapshots/snapshot-YYYY-MM-DD.json`
