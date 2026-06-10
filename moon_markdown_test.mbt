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
