# Markdown 语法覆盖测试文档

这是一份用于测试 Markdown 转 HTML 渲染器的纯 Markdown 文档。它覆盖
CommonMark 基础语法、GitHub Flavored Markdown 常用语法，以及若干常见扩展语法。
如果某个渲染器暂不支持某些扩展，对应内容可以按普通文本保留。

[TOC]

---

# 1. 标题

# ATX 一级标题
## ATX 二级标题
### ATX 三级标题
#### ATX 四级标题
##### ATX 五级标题
###### ATX 六级标题

Setext 一级标题
===============

Setext 二级标题
---------------

### 带结尾井号的标题 ###

### 带 `行内代码`、**加粗** 和 [链接](https://example.com) 的标题

---

# 2. 段落与换行

这是一个普通段落。源码中可以把同一个段落拆成多行书写，
渲染后仍然应该作为一个连续段落处理。

这一段末尾有两个空格，用来测试硬换行。  
这一行应该在同一个段落内另起一行显示。

这一段末尾使用反斜杠测试硬换行。\
这一行也应该在同一个段落内另起一行显示。

多个空行应该只负责分隔段落。


这是额外空行之后的新段落。

---

# 3. 行内文本样式

普通文本、**加粗文本**、__下划线形式加粗__、*斜体文本*、_下划线形式斜体_、
***加粗斜体***、___下划线形式加粗斜体___、~~删除线文本~~、==高亮扩展==、
H~2~O、x^2^，以及 <u>HTML 下划线文本</u>。

使用 `行内代码`、``包含 ` 反引号的代码``，以及 `代码中的 <>&"' 符号`。

转义标点应该保持字面含义：\*不是斜体\*、\[不是链接\]、\# 不是标题、
\`不是代码\`、\\ 反斜杠。

实体与特殊字符覆盖：&amp; &lt; &gt; &quot; &#39; © ® ™ 中文字符、
日本語、한국어、emoji 😀，以及符号 ∑ π λ → ←。

---

# 4. 链接

[行内链接](https://example.com/path?x=1&y=2)

[带 title 的行内链接](https://example.com "示例标题")

<https://example.com/autolink>

<user@example.com>

[引用式链接][ref-link]

[折叠引用式链接][]

[快捷引用式链接]

[包含转义右中括号 \] 的链接](https://example.com/bracket)

[链接文本中包含 `行内代码`](https://example.com/code)

[ref-link]: https://example.com/reference "引用标题"
[折叠引用式链接]: https://example.com/collapsed
[快捷引用式链接]: https://example.com/shortcut

---

# 5. 图片

![行内图片替代文本](https://raw.githubusercontent.com/submergepsc/imgur/main/example.png "行内图片标题")

![引用式图片替代文本][placeholder-image]

[![带链接的图片替代文本](https://raw.githubusercontent.com/submergepsc/imgur/main/example.png)](https://example.com/image-link)

[placeholder-image]: https://raw.githubusercontent.com/submergepsc/imgur/main/example.png "引用式图片标题"

---

# 6. 引用块

> 这是一个简单引用块。
>
> 这是引用块中的第二个段落。

> 一级嵌套引用
>
> > 二级嵌套引用
> >
> > - 引用中的列表项
> > - 另一个引用列表项
>
> 回到一级引用，并包含 **行内格式** 和 `代码`。

---

# 7. 列表

使用连字符的无序列表：

- 第一项
- 第二项
  - 第二项的子项 A
  - 第二项的子项 B
- 第三项

使用星号的无序列表：

* 星号列表项
* 另一个星号列表项

使用加号的无序列表：

+ 加号列表项
+ 另一个加号列表项

有序列表：

1. 第一项
2. 第二项
3. 第三项

非 1 起始的有序列表：

5. 第五项
6. 第六项
7. 第七项

混合嵌套列表：

1. 有序父项
   - 无序子项
     1. 有序孙项
     2. 另一个有序孙项
   - 带续接段落的子项

     这个段落应该属于上面的子列表项。
2. 第二个有序父项

宽松列表：

- 宽松列表第一项。

  这个段落应该保留在第一项内部。

- 宽松列表第二项。

任务列表：

- [x] 已完成任务
- [ ] 未完成任务
- [X] 使用大写 X 的已完成任务

---

# 8. 代码块

缩进代码块：

    function indentedCodeBlock() {
      return "<escaped>";
    }

带语言标记的 fenced code block：

```moonbit
pub fn render(markdown : String) -> String {
  markdown
}
```

不带语言标记的 fenced code block：

```
<p>这段内容应该作为代码显示，而不是被解析为 HTML。</p>
```

使用波浪线包裹，内部包含反引号围栏：

~~~markdown
```text
内部 fenced block
```
~~~

JSON 代码块：

```json
{
  "markdown": true,
  "escape": "<>&\"",
  "items": [1, 2, 3]
}
```

---

# 9. 表格

| 左对齐 | 居中对齐 | 右对齐 | 行内语法 |
|:-------|:--------:|-------:|----------|
| 甲     | 乙       | 123    | **加粗** |
| 丙     | 丁       | 456.78 | `代码`   |
| 包含转义竖线 \| 的单元格 | emoji 😀 | -9 | [链接](https://example.com) |

紧凑表格：

| A | B |
| - | - |
| 1 | 2 |

---

# 10. 水平分割线

连字符分割线：

---

星号分割线：

***

下划线分割线：

___

---

# 11. 脚注

这个句子包含一个脚注引用。[^basic-footnote]

这个句子包含另一个带行内格式的脚注引用。[^formatted-footnote]

[^basic-footnote]: 这是一个基础脚注。

[^formatted-footnote]: 这个脚注包含 **加粗文本**、`行内代码`，
    以及第二行缩进内容。

---

# 12. 定义列表

术语
: 这是该术语的定义。

另一个术语
: 第一个定义。
: 第二个定义。

---

# 13. 数学公式扩展

行内数学：$E = mc^2$ 和 \(a^2 + b^2 = c^2\)。

块级数学：

$$
\int_0^\infty e^{-x}\,dx = 1
$$

方括号形式块级数学：

\[
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
\]

---

# 14. 原始 HTML

<div class="note" data-kind="raw-html">
  <p>原始 HTML 段落，包含 <strong>strong</strong>、<em>emphasis</em> 和 <code>code</code>。</p>
</div>

<!-- HTML 注释在 HTML 输出中不应作为可见文本出现。 -->

<details>
<summary>可展开详情摘要</summary>

HTML 块内部的 Markdown 是否继续解析，取决于具体渲染器。

- 详情项一
- 详情项二

</details>

行内 HTML 示例：<kbd>Ctrl</kbd> + <kbd>K</kbd>、<mark>标记文本</mark>、
<abbr title="HyperText Markup Language">HTML</abbr>。

---

# 15. 转义与 HTML 安全

普通文本中的原始尖括号应被安全渲染器转义：
<script>alert("xss")</script>

普通文本中的 & 不应被重复转义：AT&T、Fish & Chips、x < y && y > z。

未使用尖括号包裹的 URL 文本：https://example.com/plain-url

未使用尖括号包裹的邮箱文本：hello@example.com

---

# 16. 边界情况

连续行内标记：**加粗**__也是加粗?__*斜体*_也是斜体?_

未闭合标记应有可预测的降级行为：**加粗开始但没有结束。

空链接目标：[空链接]()

空图片目标：![空图片]()

嵌套中括号：[一个 [嵌套] 标签](https://example.com/nested)

文件末尾反斜杠测试会出现在最后一节。

---

# 17. 组合小文档

## 发布说明

> 这一小节把多种结构组合到一个较真实的片段中。

1. 增加 Markdown 输入支持。
2. 增加 HTML 输出转义。
3. 增加 fixture：
   - 标题
   - 列表
   - 代码块
   - 表格

| 功能 | 状态 | 说明 |
|:-----|:----:|-----:|
| 标题 | 完成 | 6 个等级 |
| 列表 | 完成 | 支持嵌套 |
| 表格 | 可选 | GFM |

```html
<article>
  <h1>渲染后的 HTML</h1>
  <p>由 Markdown 生成。</p>
</article>
```

最后一行带有结尾反斜杠：\
