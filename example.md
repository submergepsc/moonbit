# Markdown Syntax Coverage Fixture

This file is a plain Markdown document for testing Markdown-to-HTML renderers. It
contains CommonMark basics, GitHub Flavored Markdown features, and common
extension syntax. Some sections may intentionally remain literal text if a
renderer does not support that extension.

[TOC]

---

# 1. Headings

# ATX Heading 1
## ATX Heading 2
### ATX Heading 3
#### ATX Heading 4
##### ATX Heading 5
###### ATX Heading 6

Setext Heading 1
================

Setext Heading 2
---------------- 

### Heading With Trailing Hashes ###

### Heading With `inline code`, **bold**, and ![a link](https://raw.githubusercontent.com/submergepsc/imgur/main/example.png)
---

# 2. Paragraphs And Line Breaks

This is a normal paragraph with multiple sentences. It should become one
paragraph even though the source wraps across several lines.

This paragraph ends with two spaces for a hard line break.  
This line should appear below it inside the same paragraph.

This paragraph uses a backslash for a hard line break.\
This line should also appear below it inside the same paragraph.

Multiple blank lines should still separate paragraphs.


This is the next paragraph after extra blank lines.

---

# 3. Inline Text Styles

Plain text, **bold text**, __bold text with underscores__, *italic text*,
_italic text with underscores_, ***bold italic text***, ___bold italic text with
underscores___, ~~strikethrough text~~, ==highlight extension==, H~2~O, x^2^,
and <u>underlined HTML text</u>.

Use `inline code`, ``code with ` backtick``, and `symbols <>&"' inside code`.

Escaped punctuation should stay literal: \*not italic\*, \[not a link\],
\# not a heading, \`not code\`, \\ backslash.

Entity and special character coverage: &amp; &lt; &gt; &quot; &#39; © ® ™
中文字符, 日本語, 한국어, emoji 😀, and symbols ∑ π λ → ←.

---

# 4. Links

[Inline link](https://example.com/path?x=1&y=2)

[Inline link with title](https://example.com "Example title")

<https://example.com/autolink>

<user@example.com>

[Reference link][ref-link]

[Collapsed reference link][]

[Shortcut reference link]

[Link with escaped bracket \]](https://example.com/bracket)

[Link containing `inline code`](https://example.com/code)

[ref-link]: https://example.com/reference "Reference title"
[Collapsed reference link]: https://example.com/collapsed
[Shortcut reference link]: https://example.com/shortcut

---

# 5. Images

![Inline image alt text](https://via.placeholder.com/120x80.png "Inline image title")

![Reference image alt text][placeholder-image]

[![Linked image alt](https://via.placeholder.com/80x40.png)](https://example.com/image-link)

[placeholder-image]: https://via.placeholder.com/160x90.png "Reference image title"

---

# 6. Blockquotes

> A simple blockquote.
>
> It contains a second paragraph.

> Nested blockquote level 1
>
> > Nested blockquote level 2
> >
> > - List item inside a nested quote
> > - Another quoted list item
>
> Back to level 1 with **inline formatting** and `code`.

---

# 7. Lists

Unordered list with hyphens:

- Item one
- Item two
  - Nested item two A
  - Nested item two B
- Item three

Unordered list with asterisks:

* Asterisk item
* Another asterisk item

Unordered list with plus signs:

+ Plus item
+ Another plus item

Ordered list:

1. First item
2. Second item
3. Third item

Ordered list with non-1 start:

5. Item five
6. Item six
7. Item seven

Mixed nested list:

1. Ordered parent
   - Unordered child
     1. Ordered grandchild
     2. Another ordered grandchild
   - Child with continuation paragraph

     This paragraph belongs to the child list item.
2. Second ordered parent

Loose list:

- Loose item one.

  This paragraph should remain inside loose item one.

- Loose item two.

Task list:

- [x] Completed task
- [ ] Incomplete task
- [X] Completed task with uppercase marker

---

# 8. Code Blocks

Indented code block:

    function indentedCodeBlock() {
      return "<escaped>";
    }

Fenced code block with language:

```moonbit
pub fn render(markdown : String) -> String {
  markdown
}
```

Fenced code block without language:

```
<p>This should be shown as literal code, not parsed as HTML.</p>
```

Fenced code block with backticks inside, using tildes:

~~~markdown
```text
inner fenced block
```
~~~

JSON code block:

```json
{
  "markdown": true,
  "escape": "<>&\"",
  "items": [1, 2, 3]
}
```

---

# 9. Tables

| Left aligned | Center aligned | Right aligned | Inline syntax |
|:-------------|:--------------:|--------------:|---------------|
| alpha        | beta           | 123           | **bold**      |
| gamma        | delta          | 456.78        | `code`        |
| pipe escaped \| here | emoji 😀 | -9 | [link](https://example.com) |

Compact table:

| A | B |
| - | - |
| 1 | 2 |

---

# 10. Horizontal Rules

Hyphen rule:

---

Asterisk rule:

***

Underscore rule:

___

---

# 11. Footnotes

This sentence has a footnote reference.[^basic-footnote]

This sentence has another footnote reference with inline formatting.[^formatted-footnote]

[^basic-footnote]: This is a basic footnote.

[^formatted-footnote]: This footnote contains **bold text**, `inline code`, and
    a second indented line.

---

# 12. Definition Lists

Term
: Definition text for the term.

Another term
: First definition.
: Second definition.

---

# 13. Math Extensions

Inline math: $E = mc^2$ and \(a^2 + b^2 = c^2\).

Block math:

$$
\int_0^\infty e^{-x}\,dx = 1
$$

Bracketed block math:

\[
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
\]

---

# 14. Raw HTML

<div class="note" data-kind="raw-html">
  <p>Raw HTML paragraph with <strong>strong</strong>, <em>emphasis</em>, and <code>code</code>.</p>
</div>

<!-- HTML comment should not render as visible text in HTML output. -->

<details>
<summary>Expandable details summary</summary>

Markdown inside HTML blocks may or may not be parsed depending on the renderer.

- Detail item one
- Detail item two

</details>

Inline HTML examples: <kbd>Ctrl</kbd> + <kbd>K</kbd>, <mark>marked text</mark>,
<abbr title="HyperText Markup Language">HTML</abbr>.

---

# 15. Escaping And HTML Safety

Raw angle brackets in normal text should be escaped by safe renderers:
<script>alert("xss")</script>

Ampersands should not be double escaped: AT&T, Fish & Chips, x < y && y > z.

Autolink-like text without brackets: https://example.com/plain-url

Email-like text without brackets: hello@example.com

---

# 16. Edge Cases

Paragraph with consecutive inline markers: **bold**__strong?__*italic*_italic?_

Mismatched markers should degrade predictably: **bold starts but does not end.

Empty link target: [empty]()

Empty image target: ![empty image]()

Nested brackets: [a [nested] label](https://example.com/nested)

Backslash at end of file test appears in the final section below.

---

# 17. Mini Document

## Release Notes

> This mini section combines several constructs in one realistic block.

1. Added Markdown input support.
2. Added HTML output escaping.
3. Added fixtures:
   - Headings
   - Lists
   - Code blocks
   - Tables

| Feature | Status | Notes |
|:--------|:------:|------:|
| Headings | done | 6 levels |
| Lists | done | nested |
| Tables | optional | GFM |

```html
<article>
  <h1>Rendered HTML</h1>
  <p>Generated from Markdown.</p>
</article>
```

Final line with a trailing backslash: \
