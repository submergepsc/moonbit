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
- Strong text with `**text**`
- Links with `[label](url)`
- Horizontal rules with `---`
- Pipe tables with `| cell | cell |`
- HTML escaping for `&`, `<`, `>`, and `"`

## Installation

Add this package as a MoonBit dependency after it is published to mooncakes.io.
For local development, clone the repository and run the standard MoonBit checks:

```bash
moon check
moon test
```

## Usage Modes

Moon Markdown is planned as one renderer with four usage modes:

- CLI: convert Markdown files from the command line.
- Online web app: use the renderer from a deployed browser page.
- Local web app: run the same browser page from a local static server.
- Local offline frontend package: download a static package and use it without a backend.

The CLI and local web preview are available now. The online web app and offline
frontend package are planned to reuse the same MoonBit `render(markdown)` core,
with the browser UI kept in plain HTML/CSS/JS first.

## Local Web Preview

Build the browser entry and serve the repository root with a local static server:

```bash
moon build --target js
python3 -m http.server 8080
```

Then open:

```text
http://127.0.0.1:8080/web/
```

The page loads the generated MoonBit JS from
`_build/js/debug/build/web/web.js`, so run `moon build --target js` again after
changing MoonBit source code.

The local web page supports both live editing and whole-file conversion:

- Open a Markdown file with `Open Markdown`.
- Preview the rendered HTML in the browser.
- Save a standalone HTML file with `Download HTML`.

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
moon run cli --target js README.md
```

The command writes HTML to stdout.

To convert a whole Markdown file into an HTML file:

```bash
moon run cli --target js README.md output.html
```

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
