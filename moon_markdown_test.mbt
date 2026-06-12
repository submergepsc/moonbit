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
test "render images" {
  inspect(
    render("Logo: ![MoonBit logo](/assets/moon.png)"),
    content="<p>Logo: <img alt=\"MoonBit logo\" src=\"/assets/moon.png\"></p>",
  )
}

///|
test "escape image alt text and source" {
  inspect(
    render("![`Moon` <logo>](https://example.com/logo.png?q=<tag>&size=1)"),
    content="<p><img alt=\"`Moon` &lt;logo&gt;\" src=\"https://example.com/logo.png?q=&lt;tag&gt;&amp;size=1\"></p>",
  )
}

///|
test "render strong text" {
  inspect(
    render("Learn **computer networks** with `MoonBit`"),
    content="<p>Learn <strong>computer networks</strong> with <code>MoonBit</code></p>",
  )
}

///|
test "render horizontal rules" {
  inspect(
    render("Intro\n---\n# Title"),
    content="<p>Intro</p>\n<hr>\n<h1>Title</h1>",
  )
}

///|
test "render unordered lists" {
  inspect(
    render("- Use `moon check`\n- Escape <html>"),
    content="<ul>\n<li>Use <code>moon check</code></li>\n<li>Escape &lt;html&gt;</li>\n</ul>",
  )
}

///|
test "render ordered lists" {
  inspect(
    render("1. Parse\n2. Render [HTML](https://example.com/?q=<tag>)"),
    content="<ol>\n<li>Parse</li>\n<li>Render <a href=\"https://example.com/?q=&lt;tag&gt;\">HTML</a></li>\n</ol>",
  )
}

///|
test "separate lists from surrounding blocks" {
  inspect(
    render("# Steps\n\n1. Parse\n2. Render\n\nDone"),
    content="<h1>Steps</h1>\n<ol>\n<li>Parse</li>\n<li>Render</li>\n</ol>\n<p>Done</p>",
  )
}

///|
test "render pipe tables" {
  inspect(
    render(
      "|英文术语|缩写|中文含义|\n|---|---|---|\n|Network|net|网络|\n|Host|host|主机|\n\nDone",
    ),
    content="<table>\n<tr><td>英文术语</td><td>缩写</td><td>中文含义</td></tr>\n<tr><td>Network</td><td>net</td><td>网络</td></tr>\n<tr><td>Host</td><td>host</td><td>主机</td></tr>\n</table>\n<p>Done</p>",
  )
}

///|
test "render fenced code blocks" {
  inspect(
    render("# Example\n```moonbit\nlet x = 1\nprintln(x)\n```\nDone"),
    content="<h1>Example</h1>\n<pre><code>let x = 1\nprintln(x)</code></pre>\n<p>Done</p>",
  )
}

///|
test "escape fenced code without inline markup" {
  inspect(
    render("```\nUse `code` and <tag> & [link](url)\n```"),
    content="<pre><code>Use `code` and &lt;tag&gt; &amp; [link](url)</code></pre>",
  )
}

///|
test "close unclosed fenced code at end" {
  inspect(
    render("Before\n```\nlet html = \"<p>\""),
    content="<p>Before</p>\n<pre><code>let html = &quot;&lt;p&gt;&quot;</code></pre>",
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
    render("Use `code and [link](https://example.com and ![img](src"),
    content="<p>Use `code and [link](https://example.com and ![img](src</p>",
  )
}
