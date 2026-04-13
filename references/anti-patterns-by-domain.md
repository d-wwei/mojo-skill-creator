# Anti-Patterns by Domain

Mechanically verifiable failure patterns organized by domain. Each item can be checked by scanning the output — no subjective judgment required.

Use these as red-line checklists in skills. The agent scans output against applicable items before delivery.

---

## Writing

| Anti-Pattern | Check Method |
|-------------|-------------|
| Passive voice stacking | Count passive constructions per paragraph. More than 1 per 3 sentences → rewrite |
| Noun-as-verb ("实现了优化") | Scan for "实现了/进行了/完成了 + noun". Rewrite to direct verb |
| Clause nesting ("在我们讨论了这个之后我发现") | Count subordinate clauses per sentence. Max 1 per sentence |
| Adjective inflation ("非常重要的关键因素") | Scan for stacked modifiers. Keep max 1 modifier per noun |
| Connector overuse ("此外/另外/与此同时") | Count transition words. Max 2 per 500 words |
| AI copywriting tone ("赋能/无缝/释放/下一代/标志着/充满活力") | Keyword blocklist scan |
| Quotable sentence syndrome | If a sentence sounds like it belongs on a poster → rewrite. Same rhetorical pattern max 1 occurrence in full text |
| Template disease | Same sentence structure appearing twice → change one |
| Summary disease | Ending that repeats what was already said → replace with new insight or open question |
| Translation tone | Reverse-translate to English then back to Chinese — if identical, it's translation tone |

---

## Visual / Design

| Anti-Pattern | Check Method |
|-------------|-------------|
| Inter font dependency | Scan CSS/token for `Inter`. Avoid unless deliberately chosen |
| Pure black (#000000) | Scan for `#000000` or `rgb(0,0,0)`. Use off-black (#1a1a1a or warmer) |
| Equal-thirds layout | Detect 3 equal-width columns with no variation |
| Centered hero default | If design variance > 4 elements, centered hero is lazy |
| AI purple-blue gradient | Scan for gradient from blue (#4F46E5 range) to purple (#7C3AED range) |
| Gray default shadows | Scan box-shadow for gray values. Shadows should be tinted to match background hue |
| Fake data (99.99%, $1,234,567) | Scan for suspiciously round/perfect numbers in demos |
| Generic names (John Doe, Sarah Chen, Acme Inc) | Scan for common placeholder names |
| Accent color ≤ 1 with saturation < 80% | Count distinct accent hues. More than 1 → reduce |

---

## Analysis / Decision

| Anti-Pattern | Check Method |
|-------------|-------------|
| Flat parallel listing | Count top-level bullet points. More than 5 at same level → find hierarchy |
| Fake comprehensiveness | Listed 20+ factors without ranking → identify the 3 that matter |
| Empty judgment ("前景广阔/团队优秀") | Scan for evaluative phrases without supporting evidence. Each judgment needs ≥ 1 data point |
| Universal advice ("加强沟通/提高效率") | Scan for advice applicable to any situation. Replace with specific next action |
| Unexamined assumption | Count assertions without stated basis. Each causal claim needs "because [verifiable reason]" |
| Missing counterfactual | Recommendation without "what happens if we do nothing?" analysis |
| Single-approach convergence | All proposed options are variants of the same underlying strategy → challenge the framing |

---

## Teaching / Education

| Anti-Pattern | Check Method |
|-------------|-------------|
| Jargon-first introduction | First mention of concept uses technical term before plain explanation → reverse order |
| Information dumping | Count new concepts introduced per section. Max 3 per section |
| Excessive preamble ("自古以来...") | First paragraph must give the reader a reason to continue |
| Missing bridge | Consecutive sentences where second does not follow from first → add connecting logic |
| Assumed knowledge | Concept B depends on concept A, but A was never introduced → add prerequisite |
| One-way explanation | Only abstract → concrete direction. Add concrete → abstract path as well |
| Testing without teaching | Assessment appears before the concept was fully explained |

---

## Usage Guide

### Selecting Applicable Anti-Patterns

Not every skill needs every domain's anti-patterns. Match to the skill's output type:

| Skill Output Type | Applicable Domains |
|-------------------|-------------------|
| Text/articles | Writing |
| Visual/HTML/images | Visual + Writing (for text within) |
| Analysis reports | Analysis + Writing |
| Tutorials/courses | Teaching + Writing |
| Code | None of the above (use code review checklists instead) |

### Integrating into a Skill

In the skill's red-line section:
```markdown
## Red Lines
Scan all output against these anti-pattern checklists before delivery:
- Writing anti-patterns (references/anti-patterns-by-domain.md § Writing)
- Analysis anti-patterns (references/anti-patterns-by-domain.md § Analysis)
```
