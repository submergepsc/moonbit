# Moon Markdown / Moon Markdown 渲染器

Moon Markdown is a small Markdown to HTML renderer written in MoonBit.

Moon Markdown 是一个用 MoonBit 编写的小型 Markdown to HTML 渲染器。

It focuses on a practical, small Markdown subset that is easy to embed in
MoonBit tools, examples, documentation generators, and learning projects.

它专注于一个实用、可预测、易嵌入的 Markdown 子集，适合 MoonBit 工具、示例、
文档生成器和学习项目使用。

## Part 1: Use Moon Markdown / 第一部分：如何使用 Moon Markdown

Moon Markdown is designed around one renderer and several ways to use it. The
same MoonBit `render(markdown)` core is shared by the CLI and the browser UI, so
the output stays consistent across entry points.

Moon Markdown 围绕同一个渲染核心提供多种使用方式。CLI 和浏览器 UI 复用同一套
MoonBit `render(markdown)` 核心，因此不同入口的输出保持一致。

### Online Website / 在线网站

An online website will be provided for direct browser usage. It is the easiest
way to try the renderer without installing MoonBit or cloning the repository.

后续会提供一个在线网站，用户可以直接在浏览器里使用，不需要安装 MoonBit，也不
需要 clone 仓库。

The website is planned to provide the same UI workflow as the local web app:

在线网站计划提供和本地 Web UI 相同的操作流程：

- Paste or type Markdown in the editor.
- Preview the rendered HTML.
- Upload a Markdown file from your computer.
- Download the converted HTML file.

- 在编辑器中粘贴或输入 Markdown。
- 预览渲染后的 HTML。
- 从本机上传 Markdown 文件。
- 下载转换后的 HTML 文件。

### Local Web UI / 本地 Web UI

You can also run the web UI locally with Python's built-in static server.

你也可以使用 Python 自带的静态服务器在本地运行 Web UI。

Build the browser entry:

先构建浏览器入口：

```bash
moon build --target js
```

Serve the repository root:

在仓库根目录启动静态服务器：

```bash
python3 -m http.server 8080
```

Then open:

然后打开：

```text
http://127.0.0.1:8080/web/
```

The page loads the generated MoonBit JavaScript from:

页面会加载 MoonBit 生成的 JavaScript 文件：

```text
_build/js/debug/build/web/web.js
```

Run `moon build --target js` again after changing MoonBit source code.

修改 MoonBit 源码后，需要重新运行 `moon build --target js`。

The local web UI supports both live editing and whole-file conversion:

本地 Web UI 同时支持实时编辑和整文件转换：

- `Open Markdown`: upload a local `.md` file into the editor.
- HTML preview: view the rendered result in the browser.
- `Copy HTML`: copy the rendered HTML.
- `Download HTML`: save a standalone `.html` file.

- `Open Markdown`：上传本地 `.md` 文件到编辑器。
- HTML preview：在浏览器中预览渲染结果。
- `Copy HTML`：复制渲染后的 HTML。
- `Download HTML`：下载独立的 `.html` 文件。

### CLI / 命令行

Use the CLI package to convert Markdown files from the command line.

你可以使用 CLI 包在命令行中转换 Markdown 文件。

Render a Markdown file to stdout:

将 Markdown 文件渲染到标准输出：

```bash
moon run cli --target js README.md
```

Render a Markdown file into an HTML file:

将 Markdown 文件转换为 HTML 文件：

```bash
moon run cli --target js README.md output.html
```

Run the included input/output fixture:

运行仓库中提供的输入/输出 fixture：

```bash
moon run cli --target js examples/basic.md examples/basic.html
```

### Library API / 库 API

Import the package and call `render(markdown)` with a Markdown string:

导入包后，传入 Markdown 字符串调用 `render(markdown)`：

```moonbit
let html = render("# Title\nHello [`MoonBit`](https://www.moonbitlang.com)")
```

`render` returns an HTML string:

`render` 会返回 HTML 字符串：

```html
<h1>Title</h1>
<p>Hello <a href="https://www.moonbitlang.com"><code>MoonBit</code></a></p>
```

### Local Development / 本地开发

For local development, clone the repository and run the standard MoonBit checks:

本地开发时，clone 仓库后运行标准 MoonBit 检查：

```bash
moon check
moon test
```

After this package is published to mooncakes.io, installation instructions will
be updated with the real package command.

发布到 mooncakes.io 后，README 会补充真实的包安装命令。

## Part 2: Project Details / 第二部分：项目细节

### Status / 当前状态

Moon Markdown currently provides a reusable library API, a CLI file converter,
and a local browser UI. The parser intentionally covers a small syntax surface
first, with predictable HTML escaping and tests for each supported feature.

Moon Markdown 当前提供可复用的库 API、CLI 文件转换工具和本地浏览器 UI。解析器
先覆盖一个小而稳定的语法范围，并为每个已支持功能提供可预测的 HTML 转义和测试。

### Supported Syntax / 支持语法

- `# Heading 1` / 一级标题
- `## Heading 2` / 二级标题
- `### Heading 3` / 三级标题
- Paragraphs / 段落
- Unordered lists with `- item` / 使用 `- item` 的无序列表
- Ordered lists with `1. item` / 使用 `1. item` 的有序列表
- Fenced code blocks with triple backticks / 使用三个反引号的 fenced code block
- Inline code with `` `code` `` / 使用 `` `code` `` 的行内代码
- Strong text with `**text**` / 使用 `**text**` 的加粗文本
- Links with `[label](url)` / 使用 `[label](url)` 的链接
- Images with `![alt](src)` / 使用 `![alt](src)` 的图片
- Horizontal rules with `---` / 使用 `---` 的水平分割线
- Pipe tables with `| cell | cell |` / 使用 `| cell | cell |` 的基础 pipe table
- HTML escaping for `&`, `<`, `>`, and `"` / 对 `&`、`<`、`>` 和 `"` 进行 HTML 转义

### Examples / 示例

Render a short Markdown string:

渲染一个短 Markdown 字符串：

```moonbit
let markdown = "# MoonBit\n\nUse `moon test` before publishing."
let html = render(markdown)
```

Output:

输出：

```html
<h1>MoonBit</h1>
<p>Use <code>moon test</code> before publishing.</p>
```

Lists are grouped from consecutive list items:

连续列表项会被组合成同一个列表：

```moonbit
let markdown = "- Parse Markdown\n- Escape <html>"
let html = render(markdown)
```

Output:

输出：

```html
<ul>
<li>Parse Markdown</li>
<li>Escape &lt;html&gt;</li>
</ul>
```

Images render as `<img>` elements with escaped `alt` and `src` attributes:

图片会渲染为 `<img>` 元素，并对 `alt` 和 `src` 属性进行转义：

```moonbit
let markdown = "![MoonBit logo](/assets/moon.png)"
let html = render(markdown)
```

Output:

输出：

```html
<p><img alt="MoonBit logo" src="/assets/moon.png"></p>
```

Fenced code blocks are escaped and do not apply inline markup:

Fenced code block 会被转义，且不会继续解析内部的行内标记：

````moonbit
let markdown = "```moonbit\nlet html = \"<p>\"\n```"
let html = render(markdown)
````

Output:

输出：

```html
<pre><code>let html = &quot;&lt;p&gt;&quot;</code></pre>
```

### Escaping / 转义

Text content is HTML-escaped by default. This includes plain text, inline code,
link labels, image alt text, link URLs, and image sources, so input like `<tag>`
is rendered as `&lt;tag&gt;`.

文本内容默认会进行 HTML 转义，包括普通文本、行内代码、链接 label、图片 alt 文本、
链接 URL 和图片 src。因此，类似 `<tag>` 的输入会被渲染为 `&lt;tag&gt;`。

Code block contents are also escaped, but inline markup is not expanded inside
code blocks.

代码块内容同样会被转义，但代码块内部不会展开行内 Markdown 标记。

### License / 许可证

Moon Markdown is licensed under the Apache License 2.0.

Moon Markdown 使用 Apache License 2.0 许可证。
