# Moon Markdown

Moon Markdown is a small Markdown to HTML renderer written in MoonBit.

This first version intentionally keeps the feature set narrow so the project can grow through clear incremental commits.

## Supported Syntax

- `# Heading 1`
- `## Heading 2`
- `### Heading 3`
- Paragraphs
- HTML escaping for `&`, `<`, `>`, and `"`

## Example

```moonbit
let html = render("# Title\nHello MoonBit")
```

Output:

```html
<h1>Title</h1>
<p>Hello MoonBit</p>
```

## Roadmap

- Lists
- Fenced code blocks
- Inline code
- Links and images
- CLI file conversion
