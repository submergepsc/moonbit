# Moon Markdown 渲染器

[English](README.md) | 简体中文

Moon Markdown 是一个用 MoonBit 编写的小型 Markdown to HTML 渲染器。

它专注于一个实用、可预测、易嵌入的 Markdown 子集，适合 MoonBit 工具、示例、
文档生成器和学习项目使用。

**在线演示**：[moonbit.submergepsc.asia](https://moonbit.submergepsc.asia)

## 第一部分：如何使用 Moon Markdown

Moon Markdown 围绕同一个渲染核心提供多种使用方式。CLI 和浏览器 UI 复用同一套
MoonBit `render(markdown)` 核心，因此不同入口的输出保持一致。

最快捷的体验方式是在线演示 [moonbit.submergepsc.asia](https://moonbit.submergepsc.asia)，
它提供：

- Markdown 编辑器及实时预览。
- 从本机上传 Markdown 文件。
- 下载或复制渲染后的 HTML。
- 在 StackEdit 中对比 Markdown 效果，或在 CodePen 中查看 HTML 视觉效果。

### 命令行

你可以使用 CLI 包在命令行中转换 Markdown 文件。

将 Markdown 文件渲染到标准输出：

```bash
moon run cli --target js example.md
```

将 Markdown 文件转换为 HTML 文件：

```bash
moon run cli --target js example.md output.html
```

运行仓库中提供的输入/输出 fixture：

```bash
moon run cli --target js examples/basic.md examples/basic.html
```

### 库 API

导入包后，传入 Markdown 字符串调用 `render(markdown)`：

```moonbit
let html = render("# Title\nHello [`MoonBit`](https://www.moonbitlang.com)")
```

`render` 会返回 HTML 字符串：

```html
<h1>Title</h1>
<p>Hello <a href="https://www.moonbitlang.com"><code>MoonBit</code></a></p>
```

### 本地开发

本地开发时，clone 仓库后运行标准 MoonBit 检查：

```bash
moon check
moon test
```

发布到 mooncakes.io 后，README 会补充真实的包安装命令。

本地运行 Web UI：

```bash
moon build --target js
python3 -m http.server 8080
```

打开 `http://127.0.0.1:8080/web/`。页面加载 MoonBit 生成的 JavaScript
文件 `_build/js/debug/build/web/web.js`。修改 MoonBit 源码后需要重新运行
`moon build --target js`。

## 第二部分：项目细节

### 当前状态

Moon Markdown 当前提供可复用的库 API、CLI 文件转换工具和本地浏览器 UI。解析器
先覆盖一个小而稳定的语法范围，并为每个已支持功能提供可预测的 HTML 转义和测试。

### 支持的语法

| 分类 | 语法 | 示例 |
|------|------|------|
| ATX 标题 | `#` 到 `######` | `## 章节` → `<h2>章节</h2>` |
| Setext 标题 | `=` 或 `-` 下划线 | 渲染为普通段落（暂不支持） |
| 段落 | 连续非空行 | 包裹在 `<p>…</p>` 中 |
| 硬换行 | 行尾双空格或反斜杠 | 插入 `<br>` |
| 斜体 | `*斜体*` 或 `_斜体_` | `<em>斜体</em>` |
| 加粗 | `**加粗**` 或 `__加粗__` | `<strong>加粗</strong>` |
| 加粗+斜体 | `***加粗斜体***` 或 `___加粗斜体___` | `<strong><em>加粗斜体</em></strong>` |
| 行内代码 | `` `代码` `` 或 ` ``含 ` 的代码`` ` | `<code>代码</code>` |
| 行内链接 | `[文本](url)` | `<a href="url">文本</a>` |
| 引用式链接 | `[文本][引用]` 配合 `[引用]: url` | 解析为行内链接 |
| 快捷链接 | `[引用]` 配合 `[引用]: url` | 解析为行内链接 |
| 自动链接 | `<https://example.com>` `<user@example.com>` | `<a href="…">…</a>` 或 `mailto:` |
| 行内图片 | `![替代文本](src)` | `<img alt="替代文本" src="src">` |
| 引用式图片 | `![替代文本][引用]` 配合 `[引用]: src` | 解析为行内图片 |
| 引用块 | `> 行` | `<blockquote>…</blockquote>` |
| 嵌套引用块 | `> > 行` | 嵌套 `<blockquote>` 元素 |
| 无序列表 | `-`、`*`、`+` | `<ul><li>…</li></ul>` |
| 有序列表 | `1.`、`1)` | `<ol><li>…</li></ol>` |
| 任务列表 | `- [x] 已完成` `- [ ] 未完成` | 带 `<input type="checkbox">` 的复选框 |
| 缩进代码块 | 4 空格或 Tab | `<pre><code>…</code></pre>` |
| 围栏代码块 | `` ``` `` 或 `~~~` | `<pre><code>…</code></pre>` |
| 水平分割线 | `---`、`***`、`___` | `<hr>` |
| 管道表格 | `\| 单元格 \| 单元格 \|` 加分隔行 | `<table><tr><td>…</td></tr></table>` |
| HTML 转义 | `&`、`<`、`>`、`"` | `&amp;` `&lt;` `&gt;` `&quot;` |
| 反斜杠转义 | `\*原文\*` | 字符原样保留 |
| 删除线 | `~~文本~~` | 暂不支持 |
| 脚注 | `[^1]` | 暂不支持 |

### 示例详解：`example.md` → `output.html`

仓库中包含 `example.md` 和 `output.html` 作为完整的输入/输出对，
涵盖了所有已支持语法的测试用例。

运行转换：

```bash
moon run cli --target js example.md output.html
```

#### 1. 标题

支持 1 到 6 级的 ATX 标题。渲染器会自动去掉闭合的 `#` 字符。

输入：
```markdown
### 带结尾井号的标题 ###
```

输出：
```html
<h3>带结尾井号的标题</h3>
```

标题中可以包含行内标记：

输入：
```markdown
### 带 `行内代码`、**加粗** 和 [链接](https://example.com) 的标题
```

输出：
```html
<h3>带 <code>行内代码</code>、<strong>加粗</strong> 和 <a href="https://example.com">链接</a> 的标题</h3>
```

Setext 标题（`===` 和 `---` 下划线）会被解析为普通段落，因为暂未支持。

#### 2. 段落与换行

一个段落可以跨多个源代码行连续书写，直到遇到空行才结束。行尾空格或反斜杠会
产生硬换行：

输入：
```markdown
这一段末尾有两个空格，用来测试硬换行。  
这一行应该在同一个段落内另起一行显示。
```

输出：
```html
<p>这一段末尾有两个空格，用来测试硬换行。<br>
这一行应该在同一个段落内另起一行显示。</p>
```

反斜杠换行同理：

输入：
```markdown
这一段末尾使用反斜杠测试硬换行。\
这一行也应该在同一个段落内另起一行显示。
```

输出：
```html
<p>这一段末尾使用反斜杠测试硬换行。<br>
这一行也应该在同一个段落内另起一行显示。</p>
```

#### 3. 行内文本样式

支持加粗、斜体、加粗斜体、行内代码和转义标点。`*` 和 `_` 两种分隔符均可使用。

输入：
```markdown
普通文本、**星号加粗文本**、__下划线分隔符加粗文本__、*星号斜体文本*、
_下划线分隔符斜体文本_、***星号加粗斜体***、___下划线分隔符加粗斜体___
```

输出：
```html
<p>普通文本、<strong>星号加粗文本</strong>、<strong>下划线分隔符加粗文本</strong>、<em>星号斜体文本</em>、
<em>下划线分隔符斜体文本</em>、<strong><em>星号加粗斜体</em></strong>、<strong><em>下划线分隔符加粗斜体</em></strong></p>
```

双反引号代码跨度允许在代码中包含反引号：

输入：
```markdown
使用 `行内代码`、``包含 ` 反引号的代码``
```

输出：
```html
<p>使用 <code>行内代码</code>、<code>包含 ` 反引号的代码</code></p>
```

反斜杠转义可以阻止标记被解析：

输入：
```markdown
\*不是斜体\*、\[不是链接\]、\# 不是标题、\`不是代码\`
```

输出：
```html
<p>*不是斜体*、[不是链接]、# 不是标题、`不是代码`</p>
```

HTML 实体和特殊字符在转义后原样输出：`&amp;` `&lt;` `&gt;` `&quot;` `&#39;`，
以及 Unicode 字符、中日韩文本和 emoji。

#### 4. 链接

行内链接、自动链接、引用式链接、折叠引用式链接和快捷引用式链接均可正确解析。

输入：
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

输出：
```html
<p><a href="https://example.com/path?x=1&amp;y=2">行内链接</a></p>
<p><a href="https://example.com/autolink">https://example.com/autolink</a></p>
<p><a href="mailto:user@example.com">user@example.com</a></p>
<p><a href="https://example.com/reference">引用式链接</a></p>
<p><a href="https://example.com/collapsed">折叠引用式链接</a></p>
<p><a href="https://example.com/shortcut">快捷引用式链接</a></p>
```

链接文本中可以包含行内代码：

输入：
```markdown
[链接文本中包含 `行内代码`](https://example.com/code)
```

输出：
```html
<p><a href="https://example.com/code">链接文本中包含 <code>行内代码</code></a></p>
```

引用链接定义会在输出中被移除，不会出现在渲染后的 HTML 中。

#### 5. 图片

支持行内和引用式图片。图片可以嵌套在链接中。

输入：
```markdown
![行内图片替代文本](https://example.com/assets/example.svg)
[![带链接的图片](https://example.com/assets/example.svg)](https://example.com/image-link)
```

输出：
```html
<p><img alt="行内图片替代文本" src="https://example.com/assets/example.svg"></p>
<p><a href="https://example.com/image-link"><img alt="带链接的图片" src="https://example.com/assets/example.svg"></a></p>
```

#### 6. 引用块

引用块支持多个段落和最多两层的嵌套。行内格式和列表可以在引用块中使用。

输入：
```markdown
> 一级嵌套引用
>
> > 二级嵌套引用
> >
> > - 引用中的列表项
>
> 回到一级引用，并包含 **行内格式** 和 `代码`。
```

输出：
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

#### 7. 列表

无序列表使用 `-`、`*` 或 `+` 作为标记。有序列表使用 `1.` 格式，且可以从任意数字
起始。任务列表渲染为带复选框的列表项。

输入：
```markdown
- [x] 已完成任务
- [ ] 未完成任务
```

输出：
```html
<ul>
<li><input type="checkbox" disabled checked> 已完成任务</li>
<li><input type="checkbox" disabled> 未完成任务</li>
</ul>
```

注意：嵌套列表（二级缩进）和宽松列表（列表项内包含段落）尚未完全支持；
渲染器会生成一个尽力而为的结构，可能与 CommonMark 预期有所差异。

#### 8. 代码块

缩进代码块（4 空格 / Tab）和围栏代码块（`` ``` `` 或 `~~~` 分隔符）均受支持。
代码内容会被 HTML 转义。

输入：
```markdown
    function indentedCodeBlock() {
      return "<escaped>";
    }
```

输出：
```html
<pre><code>function indentedCodeBlock() {
  return &quot;&lt;escaped&gt;&quot;;
}</code></pre>
```

使用 `~~~` 的围栏代码块内部可以包含 `` ``` ``：

输入：
````markdown
~~~markdown
```text
内部 fenced block
```
~~~
````

输出：
```html
<pre><code>```text
内部 fenced block
```</code></pre>
```

#### 9. 表格

管道分隔的表格加分隔行会生成 `<table>` 元素。单元格中可以包含行内标记（加粗、
代码、链接）。转义的竖线 `\|` 在单元格中保留为字面竖线。

输入：
```markdown
| 左对齐 | 居中对齐 | 右对齐 |
|:-------|:--------:|-------:|
| 甲     | 乙       | 123    |
```

输出：
```html
<table>
<tr><td>左对齐</td><td>居中对齐</td><td>右对齐</td></tr>
<tr><td>甲</td><td>乙</td><td>123</td></tr>
</table>
```

#### 10. 水平分割线

单独一行上的三个或更多 `-`、`*` 或 `_` 会生成 `<hr>`。

输入：
```markdown
---
***
___
```

输出：
```html
<hr>
<hr>
<hr>
```

#### 11. 边界情况

渲染器能优雅地处理若干边界情况：

**连续的行内标记**会生成独立的元素：
```html
<strong>加粗</strong><strong>也是加粗?</strong><em>斜体</em><em>也是斜体?</em>
```

**未闭合的标记**会被当作字面文本处理。

**空的链接/图片目标**会生成 `href=""` 和 `src=""`：
```html
<a href="">空链接</a>
<img alt="空图片" src="">
```

**链接文本中的嵌套中括号**能被正确解析：
```html
<a href="https://example.com/nested">一个 [嵌套] 标签</a>
```

**文件末尾的反斜杠**会产生一个结尾的 `<br>`：
```html
<p>文件末尾反斜杠测试。<br>
</p>
```

## HTML 转义

文本内容默认进行 HTML 转义。包括普通文本、行内代码、链接标签、图片替代文本、
链接 URL 和图片源，因此输入 `<tag>` 会被渲染为 `&lt;tag&gt;`。

代码块内容同样会被转义，但代码块内部不会展开行内标记。

## 许可证

Moon Markdown 采用 Apache License 2.0 许可证。
