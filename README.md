# Moon Markdown

Moon Markdown is a small Markdown to HTML renderer written in MoonBit.

## Supported Syntax

- `# Heading 1`
- `## Heading 2`
- `### Heading 3`
- Paragraphs
- Inline code with `` `code` ``
- Links with `[label](url)`
- HTML escaping for `&`, `<`, `>`, and `"`

## Example

```moonbit
let html = render("# Title\nHello [`MoonBit`](https://www.moonbitlang.com)")
```

Output:

```html
<h1>Title</h1>
<p>Hello <a href="https://www.moonbitlang.com"><code>MoonBit</code></a></p>
```
