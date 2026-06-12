# Moon Markdown

English | [简体中文](README.zh-CN.md)

Moon Markdown is a small Markdown to HTML renderer written in MoonBit.

It focuses on a practical, small Markdown subset that is easy to embed in
MoonBit tools, examples, documentation generators, and learning projects.

## Part 1: Use Moon Markdown

Moon Markdown is designed around one renderer and several ways to use it. The
same MoonBit `render(markdown)` core is shared by the CLI and the browser UI, so
the output stays consistent across entry points.

### Online Website

An online website will be provided for direct browser usage. It is the easiest
way to try the renderer without installing MoonBit or cloning the repository.

The website is planned to provide the same UI workflow as the local web app:

- Paste or type Markdown in the editor.
- Preview the rendered HTML.
- Upload a Markdown file from your computer.
- Download the converted HTML file.

### Local Web UI

You can also run the web UI locally with Python's built-in static server.

Build the browser entry:

```bash
moon build --target js
```

Serve the repository root:

```bash
python3 -m http.server 8080
```

Then open:

```text
http://127.0.0.1:8080/web/
```

The page loads the generated MoonBit JavaScript from:

```text
_build/js/debug/build/web/web.js
```

Run `moon build --target js` again after changing MoonBit source code.

The local web UI supports both live editing and whole-file conversion:

- `Open Markdown`: upload a local `.md` file into the editor.
- HTML preview: view the rendered result in the browser.
- `Copy HTML`: copy the rendered HTML.
- `Download HTML`: save a standalone `.html` file.
- `Markdown Preview (StackEdit)`: copy Markdown to clipboard and open StackEdit for comparison.
- `HTML Preview (CodePen)`: copy rendered HTML to clipboard and open CodePen for visual verification.

### CLI

Use the CLI package to convert Markdown files from the command line.

Render a Markdown file to stdout:

```bash
moon run cli --target js example.md
```

Render a Markdown file into an HTML file:

```bash
moon run cli --target js example.md output.html
```

Run the included input/output fixture:

```bash
moon run cli --target js examples/basic.md examples/basic.html
```

### Library API

Import the package and call `render(markdown)` with a Markdown string:

```moonbit
let html = render("# Title\nHello [`MoonBit`](https://www.moonbitlang.com)")
```

`render` returns an HTML string:

```html
<h1>Title</h1>
<p>Hello <a href="https://www.moonbitlang.com"><code>MoonBit</code></a></p>
```

### Local Development

For local development, clone the repository and run the standard MoonBit checks:

```bash
moon check
moon test
```

After this package is published to mooncakes.io, installation instructions will
be updated with the real package command.

## Part 2: Project Details

### Status

Moon Markdown currently provides a reusable library API, a CLI file converter,
and a local browser UI. The parser intentionally covers a small syntax surface
first, with predictable HTML escaping and tests for each supported feature.

### Supported Syntax

| Category | Syntax | Example |
|----------|--------|---------|
| ATX Headings | `#` through `######` | `## Section` → `<h2>Section</h2>` |
| Setext Headings | Underline with `=` or `-` | Rendered as plain text (not yet supported) |
| Paragraphs | Consecutive non-empty lines | Wrapped in `<p>…</p>` |
| Hard line break | Two trailing spaces or backslash at end of line | Inserts `<br>` |
| Emphasis | `*italic*` or `_italic_` | `<em>italic</em>` |
| Strong | `**bold**` or `__bold__` | `<strong>bold</strong>` |
| Strong+Emphasis | `***both***` or `___both___` | `<strong><em>both</em></strong>` |
| Inline code | `` `code` `` or ` ``code with ` ticks`` ` | `<code>code</code>` |
| Links (inline) | `[label](url)` | `<a href="url">label</a>` |
| Links (reference) | `[label][ref]` with `[ref]: url` | Resolved to inline link |
| Links (shortcut) | `[ref]` with `[ref]: url` | Resolved to inline link |
| Links (autolink) | `<https://example.com>` `<user@example.com>` | `<a href="…">…</a>` or `mailto:` |
| Images (inline) | `![alt](src)` | `<img alt="alt" src="src">` |
| Images (reference) | `![alt][ref]` with `[ref]: src` | Resolved to inline image |
| Blockquotes | `> line` | `<blockquote>…</blockquote>` |
| Nested blockquotes | `> > line` | Nested `<blockquote>` elements |
| Unordered lists | `-`, `*`, `+` | `<ul><li>…</li></ul>` |
| Ordered lists | `1.`, `1)` | `<ol><li>…</li></ol>` |
| Task lists | `- [x] done` `- [ ] todo` | Checkbox `<input type="checkbox" disabled>` |
| Indented code blocks | 4 spaces or tab | `<pre><code>…</code></pre>` |
| Fenced code blocks | ` ``` ` or `~~~` | `<pre><code>…</code></pre>` |
| Horizontal rules | `---`, `***`, `___` | `<hr>` |
| Pipe tables | `\| cell \| cell \|` with separator row | `<table><tr><td>…</td></tr></table>` |
| HTML escaping | `&`, `<`, `>`, `"` | `&amp;` `&lt;` `&gt;` `&quot;` |
| Backslash escaping | `\*literal\*` | Characters preserved as-is |
| Strikethrough | `~~text~~` | Not yet supported |
| Footnotes | `[^1]` | Not yet supported |

### Example Walkthrough: `example.md` → `output.html`

The repository includes `example.md` and `output.html` as a comprehensive
input/output pair that exercises every supported syntax feature.

Run the conversion:

```bash
moon run cli --target js example.md output.html
```

#### 1. Headings

ATX headings from level 1 to 6 are fully supported. The renderer also strips
trailing `#` characters from closing heading hashes.

Input:
```markdown
### 带结尾井号的标题 ###
```

Output:
```html
<h3>带结尾井号的标题</h3>
```

Headings can contain inline markup:

Input:
```markdown
### 带 `行内代码`、**加粗** 和 [链接](https://example.com) 的标题
```

Output:
```html
<h3>带 <code>行内代码</code>、<strong>加粗</strong> 和 <a href="https://example.com">链接</a> 的标题</h3>
```

Setext headings (`===` and `---` underlines) are parsed as plain paragraphs
because they are not yet supported.

#### 2. Paragraphs and Line Breaks

A paragraph continues across multiple source lines until an empty line is
encountered. Trailing whitespace or backslash at end of line produces a hard
line break:

Input:
```markdown
这一段末尾有两个空格，用来测试硬换行。  
这一行应该在同一个段落内另起一行显示。
```

Output:
```html
<p>这一段末尾有两个空格，用来测试硬换行。<br>
这一行应该在同一个段落内另起一行显示。</p>
```

Backslash breaks work the same way:

Input:
```markdown
这一段末尾使用反斜杠测试硬换行。\
这一行也应该在同一个段落内另起一行显示。
```

Output:
```html
<p>这一段末尾使用反斜杠测试硬换行。<br>
这一行也应该在同一个段落内另起一行显示。</p>
```

#### 3. Inline Text Styles

Bold, italic, bold-italic, inline code, and escaped punctuation are all
supported. Both `*` and `_` delimiters work.

Input:
```markdown
普通文本、**星号加粗文本**、__下划线分隔符加粗文本__、*星号斜体文本*、
_下划线分隔符斜体文本_、***星号加粗斜体***、___下划线分隔符加粗斜体___
```

Output:
```html
<p>普通文本、<strong>星号加粗文本</strong>、<strong>下划线分隔符加粗文本</strong>、<em>星号斜体文本</em>、
<em>下划线分隔符斜体文本</em>、<strong><em>星号加粗斜体</em></strong>、<strong><em>下划线分隔符加粗斜体</em></strong></p>
```

Double-backtick code spans allow literal backticks inside code:

Input:
```markdown
使用 `行内代码`、``包含 ` 反引号的代码``
```

Output:
```html
<p>使用 <code>行内代码</code>、<code>包含 ` 反引号的代码</code></p>
```

Backslash escaping prevents markup interpretation:

Input:
```markdown
\*不是斜体\*、\[不是链接\]、\# 不是标题、\`不是代码\`
```

Output:
```html
<p>*不是斜体*、[不是链接]、# 不是标题、`不是代码`</p>
```

HTML entities and special characters pass through as-is after escaping: `&amp;`
`&lt;` `&gt;` `&quot;` `&#39;`, plus Unicode characters, CJK text, and emoji.

#### 4. Links

Inline links, autolinks, reference links, collapsed reference links, and
shortcut reference links are all resolved.

Input:
```markdown
[行内链接](https://example.com/path?x=1&y=2)
<https://example.com/autolink>
<user@example.com>
[引用式链接][ref-link]
[折叠引用式链接][]
[快捷引用式链接]

[ref-link]: https://example.com/reference
[折叠引用式链接]: https://example.com/collapsed
[快捷引用式链接]: https://example.com/shortcut
```

Output:
```html
<p><a href="https://example.com/path?x=1&amp;y=2">行内链接</a></p>
<p><a href="https://example.com/autolink">https://example.com/autolink</a></p>
<p><a href="mailto:user@example.com">user@example.com</a></p>
<p><a href="https://example.com/reference">引用式链接</a></p>
<p><a href="https://example.com/collapsed">折叠引用式链接</a></p>
<p><a href="https://example.com/shortcut">快捷引用式链接</a></p>
```

Link text can contain inline code:

Input:
```markdown
[链接文本中包含 `行内代码`](https://example.com/code)
```

Output:
```html
<p><a href="https://example.com/code">链接文本中包含 <code>行内代码</code></a></p>
```

Reference link definitions are stripped from output and do not appear in the
rendered HTML.

#### 5. Images

Both inline and reference-style images are supported. Images can be wrapped in
links.

Input:
```markdown
![行内图片替代文本](https://example.com/assets/example.svg)
[![带链接的图片](https://example.com/assets/example.svg)](https://example.com/image-link)
```

Output:
```html
<p><img alt="行内图片替代文本" src="https://example.com/assets/example.svg"></p>
<p><a href="https://example.com/image-link"><img alt="带链接的图片" src="https://example.com/assets/example.svg"></a></p>
```

#### 6. Blockquotes

Blockquotes support multiple paragraphs and nesting up to two levels deep.
Inline formatting and lists work inside blockquotes.

Input:
```markdown
> 一级嵌套引用
>
> > 二级嵌套引用
> >
> > - 引用中的列表项
>
> 回到一级引用，并包含 **行内格式** 和 `代码`。
```

Output:
```html
<blockquote><p>一级嵌套引用</p>
<blockquote><p>二级嵌套引用</p>
<ul>
<li>引用中的列表项</li>
</ul>
</blockquote>
<p>回到一级引用，并包含 <strong>行内格式</strong> 和 <code>代码</code>。</p>
</blockquote>
```

#### 7. Lists

Unordered lists use `-`, `*`, or `+` markers. Ordered lists use `1.` format and
can start from any number. Task lists render with disabled checkboxes.

Input:
```markdown
- [x] 已完成任务
- [ ] 未完成任务
```

Output:
```html
<ul>
<li><input type="checkbox" disabled checked> 已完成任务</li>
<li><input type="checkbox" disabled> 未完成任务</li>
</ul>
```

Note: Nested lists (second-level indentation) and loose lists (paragraphs inside
list items) are not yet fully supported; the renderer produces a best-effort
structure that may differ from CommonMark expectations.

#### 8. Code Blocks

Indented code blocks (4 spaces / tab) and fenced code blocks (with `` ``` `` or
`~~~` delimiters) are both supported. Code content is HTML-escaped.

Input:
```markdown
    function indentedCodeBlock() {
      return "<escaped>";
    }
```

Output:
```html
<pre><code>function indentedCodeBlock() {
  return &quot;&lt;escaped&gt;&quot;;
}</code></pre>
```

Fenced blocks with `~~~` can contain literal `` ``` `` inside:

Input:
````markdown
~~~markdown
```text
内部 fenced block
```
~~~
````

Output:
```html
<pre><code>```text
内部 fenced block
```</code></pre>
```

#### 9. Tables

Pipe-delimited tables with separator rows produce `<table>` elements. Cells may
contain inline markup (bold, code, links). Escaped pipe characters `\|` are kept
as literal pipes inside cells.

Input:
```markdown
| 左对齐 | 居中对齐 | 右对齐 |
|:-------|:--------:|-------:|
| 甲     | 乙       | 123    |
```

Output:
```html
<table>
<tr><td>左对齐</td><td>居中对齐</td><td>右对齐</td></tr>
<tr><td>甲</td><td>乙</td><td>123</td></tr>
</table>
```

#### 10. Horizontal Rules

Three or more of `-`, `*`, or `_` on their own line produce `<hr>`.

Input:
```markdown
---
***
___
```

Output:
```html
<hr>
<hr>
<hr>
```

#### 11. Edge Cases

The renderer handles several edge cases gracefully:

**Consecutive inline markers** produce separate elements:
```html
<strong>加粗</strong><strong>也是加粗?</strong><em>斜体</em><em>也是斜体?</em>
```

**Unclosed markers** are treated as literal text.

**Empty link/image targets** produce `href=""` and `src=""`:
```html
<a href="">空链接</a>
<img alt="空图片" src="">
```

**Nested brackets in link text** are resolved correctly:
```html
<a href="https://example.com/nested">一个 [嵌套] 标签</a>
```

**Trailing backslash at EOF** produces a final `<br>`:
```html
<p>文件末尾反斜杠测试。<br>
</p>
```

### Escaping

Text content is HTML-escaped by default. This includes plain text, inline code,
link labels, image alt text, link URLs, and image sources, so input like `<tag>`
is rendered as `&lt;tag&gt;`.

Code block contents are also escaped, but inline markup is not expanded inside
code blocks.

### License

Moon Markdown is licensed under the Apache License 2.0.
