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

### CLI

Use the CLI package to convert Markdown files from the command line.

Render a Markdown file to stdout:

```bash
moon run cli --target js README.md
```

Render a Markdown file into an HTML file:

```bash
moon run cli --target js README.md output.html
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
- Images with `![alt](src)`
- Horizontal rules with `---`
- Pipe tables with `| cell | cell |`
- HTML escaping for `&`, `<`, `>`, and `"`

### Examples

Render a short Markdown string:

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

Images render as `<img>` elements with escaped `alt` and `src` attributes:

```moonbit
let markdown = "![MoonBit logo](/assets/moon.png)"
let html = render(markdown)
```

Output:

```html
<p><img alt="MoonBit logo" src="/assets/moon.png"></p>
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

### Escaping

Text content is HTML-escaped by default. This includes plain text, inline code,
link labels, image alt text, link URLs, and image sources, so input like `<tag>`
is rendered as `&lt;tag&gt;`.

Code block contents are also escaped, but inline markup is not expanded inside
code blocks.

### License

Moon Markdown is licensed under the Apache License 2.0.
