## Overview

The objective of this notebook is to demonstrate standard Markdown syntax alongside HTML workarounds specific to Apache Zeppelin (such as styling tables and callout boxes where standard Markdown rendering may be limited in certain Cloudera/Zeppelin environments).

---

## Covered Formatting Topics

The notebook walks through the following 8 documentation examples:

| Section | Formatting Elements Covered | Syntax / Tags Used |
| :--- | :--- | :--- |
| **Headings & Titles** | Hierarchical document headers from Level 1 to Level 4. | `#`, `##`, `###`, `####` |
| **Text Formatting** | Bold, italic, combined bold-italic, and strikethrough text styles. | `**bold**`, `*italic*`, `***both***`, `~~strikethrough~~` |
| **Lists** | Nested hierarchical bullet lists and multi-level numbered steps. | `*`, `1.`, `1.1.` |
| **Code Blocks** | Inline code snippets and syntax-highlighted multi-line Python blocks. | `` `inline` ``, ```` ```python ```` |
| **Data Tables** | Standard Markdown pipe tables vs. styled HTML tables (including a compatibility note for Cloudera environments). | `\| Col \|`, `<table>`, `<thead>`, `<tbody>`, `<tr>`, `<td>` |
| **Quotes & Notices** | Standard Markdown blockquotes and custom color-coded HTML alert boxes. | `>`, `<div style="...">`, `<strong>`, `<span>` |
| **Links & Media** | External reference links and embedded images via URL. | `[Text](URL)`, `![Alt](URL)` |
| **Comments** | Single-line and multi-line hidden editor comments not rendered in the final output. | `<!-- comment -->` |
