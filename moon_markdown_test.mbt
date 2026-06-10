///|
test "render headings and paragraphs" {
  inspect(
    render("# Title\n\nHello MoonBit\n## Section"),
    content="<h1>Title</h1>\n<p>Hello MoonBit</p>\n<h2>Section</h2>",
  )
}

///|
test "escape html special characters" {
  inspect(
    render("Use <tag> & \"quote\""),
    content="<p>Use &lt;tag&gt; &amp; &quot;quote&quot;</p>",
  )
}

///|
test "render inline code" {
  inspect(
    render("Use `render(<md>)` here"),
    content="<p>Use <code>render(&lt;md&gt;)</code> here</p>",
  )
}

///|
test "render links" {
  inspect(
    render("Visit [MoonBit](https://www.moonbitlang.com/?q=<lang>)"),
    content="<p>Visit <a href=\"https://www.moonbitlang.com/?q=&lt;lang&gt;\">MoonBit</a></p>",
  )
}

///|
test "render inline markup in headings and link labels" {
  inspect(
    render("# Read [`docs`](https://example.com/docs)"),
    content="<h1>Read <a href=\"https://example.com/docs\"><code>docs</code></a></h1>",
  )
}

///|
test "leave incomplete inline markup escaped" {
  inspect(
    render("Use `code and [link](https://example.com"),
    content="<p>Use `code and [link](https://example.com</p>",
  )
}
