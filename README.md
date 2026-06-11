# Moon Markdown

Moon Markdown is a small Markdown to HTML renderer written in MoonBit.

It focuses on a practical, small Markdown subset that is easy to embed in
MoonBit tools, examples, documentation generators, and learning projects.

## Status

Moon Markdown currently provides a library API. The parser intentionally covers a
small syntax surface first, with predictable HTML escaping and tests for each
supported feature.

## Supported Syntax

- `# Heading 1`
- `## Heading 2`
- `### Heading 3`
- Paragraphs
- Unordered lists with `- item`
- Ordered lists with `1. item`
- Fenced code blocks with triple backticks
- Inline code with `` `code` ``
- Links with `[label](url)`
- HTML escaping for `&`, `<`, `>`, and `"`

## Installation

Add this package as a MoonBit dependency after it is published to mooncakes.io.
For local development, clone the repository and run the standard MoonBit checks:

```bash
/home/loviya/.moon/bin/moon check
/home/loviya/.moon/bin/moon test
```

## Usage

Import the package and call `render(markdown)` with a Markdown string:

```moonbit
let html = render("# Title\nHello [`MoonBit`](https://www.moonbitlang.com)")
```

`render` returns an HTML string:

```html
<h1>Title</h1>
<p>Hello <a href="https://www.moonbitlang.com"><code>MoonBit</code></a></p>
```

You can also render a Markdown file with the CLI package:

```bash
/home/loviya/.moon/bin/moon run cli --target js README.md
```

The command writes HTML to stdout.

## Example

```moonbit
let markdown = "# MoonBit\n\nUse `moon test` before publishing."
let html = render(markdown)
```

Output:

```html
<h1>MoonBit</h1>
<p>Use <code>moon test</code> before publishing.</p>
```

Lists are grouped from consecutive list items:

```moonbit
let markdown = "- Parse Markdown\n- Escape <html>"
let html = render(markdown)
```

Output:

```html
<ul>
<li>Parse Markdown</li>
<li>Escape &lt;html&gt;</li>
</ul>
```

Fenced code blocks are escaped and do not apply inline markup:

````moonbit
let markdown = "```moonbit\nlet html = \"<p>\"\n```"
let html = render(markdown)
````

Output:

```html
<pre><code>let html = &quot;&lt;p&gt;&quot;</code></pre>
```

## Escaping

Text content is HTML-escaped by default. This includes plain text, inline code,
link labels, and link URLs, so input like `<tag>` is rendered as `&lt;tag&gt;`.
Code block contents are also escaped, but inline markup is not expanded inside
code blocks.

## License

Moon Markdown is licensed under the Apache License 2.0.
