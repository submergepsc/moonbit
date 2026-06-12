///|
pub fn render(markdown : String) -> String {
  let out = StringBuilder::new()
  let mut first = true
  let mut list_tag = ""
  let mut in_table = false
  let mut in_code_block = false
  let mut first_code_line = true
  let mut just_closed_code_block = false
  let mut in_blockquote = false
  let mut blockquote_content = StringBuilder::new()
  for line in markdown.split("\n") {
    let trimmed = line.trim()
    if in_code_block {
      if is_code_fence_close(trimmed) {
        close_code_block(out)
        in_code_block = false
        just_closed_code_block = true
      } else {
        first_code_line = write_code_block_line(out, line, first_code_line)
      }
    } else {
      if in_blockquote && !is_blockquote_line(trimmed) {
        close_blockquote(out, blockquote_content)
        blockquote_content = StringBuilder::new()
        in_blockquote = false
      }
      if trimmed.is_empty() {
        just_closed_code_block = false
        if !list_tag.is_empty() {
          close_list(out, list_tag)
          list_tag = ""
        }
        if in_table {
          close_table(out)
          in_table = false
        }
      } else if is_blockquote_line(trimmed) {
        just_closed_code_block = false
        if !list_tag.is_empty() {
          close_list(out, list_tag)
          list_tag = ""
        }
        if in_table {
          close_table(out)
          in_table = false
        }
        if !in_blockquote {
          in_blockquote = true
          if first {
            first = false
          } else {
            out.write_stringview("\n")
          }
          out.write_stringview("<blockquote>")
        }
        write_blockquote_content_line(blockquote_content, blockquote_text(trimmed))
      } else if just_closed_code_block && is_code_fence_close(trimmed) {
        just_closed_code_block = false
      } else if is_reference_definition(trimmed) {
        just_closed_code_block = false
        // Skip reference link definitions: [label]: url
        ()
      } else if is_table_separator(trimmed) {
        just_closed_code_block = false
        ()
      } else if is_table_row(trimmed) {
        just_closed_code_block = false
        if !list_tag.is_empty() {
          close_list(out, list_tag)
          list_tag = ""
        }
        if !in_table {
          first = open_table(out, first)
          in_table = true
        }
        write_table_row(out, trimmed, markdown)
      } else {
        just_closed_code_block = false
        if in_table {
          close_table(out)
          in_table = false
        }
        match unordered_list_item_text(trimmed) {
          Some(item) => {
            if list_tag != "ul" {
              if !list_tag.is_empty() {
                close_list(out, list_tag)
              }
              first = open_list(out, first, "ul")
              list_tag = "ul"
            }
            write_list_item(out, item, markdown)
          }
          None =>
            match ordered_list_item_text(trimmed) {
              Some(item) => {
                if list_tag != "ol" {
                  if !list_tag.is_empty() {
                    close_list(out, list_tag)
                  }
                  first = open_list(out, first, "ol")
                  list_tag = "ol"
                }
                write_list_item(out, item, markdown)
              }
              None =>
                if trimmed.has_prefix("  ") {
                  match unordered_list_item_indented(trimmed, 2) {
                    Some(item) => {
                      out.write_stringview("\n<ul>\n<li>")
                      write_inline(out, item, markdown)
                      out.write_stringview("</li>\n</ul>")
                    }
                    None =>
                      match ordered_list_item_indented(trimmed, 2) {
                        Some(item) => {
                          out.write_stringview("\n<ol>\n<li>")
                          write_inline(out, item, markdown)
                          out.write_stringview("</li>\n</ol>")
                        }
                        None => {
                          if !list_tag.is_empty() {
                            close_list(out, list_tag)
                            list_tag = ""
                          }
                          if is_horizontal_rule(trimmed) {
                            first = write_horizontal_rule(out, first)
                          } else if is_code_fence(trimmed) {
                            first = open_code_block(out, first)
                            in_code_block = true
                            first_code_line = true
                          } else {
                            if first {
                              first = false
                            } else {
                              out.write_stringview("\n")
                            }
                            render_line(out, trimmed, markdown)
                          }
                        }
                      }
                  }
                } else {
                  if !list_tag.is_empty() {
                    close_list(out, list_tag)
                    list_tag = ""
                  }
                  if is_horizontal_rule(trimmed) {
                    first = write_horizontal_rule(out, first)
                  } else if is_code_fence(trimmed) {
                    first = open_code_block(out, first)
                    in_code_block = true
                    first_code_line = true
                  } else {
                    if first {
                      first = false
                    } else {
                      out.write_stringview("\n")
                    }
                    render_line(out, trimmed, markdown)
                  }
                }
            }
        }
      }
    }
  }
  if in_blockquote {
    close_blockquote(out, blockquote_content)
  }
  if !list_tag.is_empty() {
    close_list(out, list_tag)
  }
  if in_table {
    close_table(out)
  }
  if in_code_block {
    close_code_block(out)
  }
  out.to_string()
}

///|
fn is_reference_definition(line : StringView) -> Bool {
  line.strip_prefix("[") is Some(_) && find_from(line, 1, "]:") is Some(_)
}

///|
fn is_code_fence(line : StringView) -> Bool {
  line.strip_prefix("```") is Some(_)
}

///|
fn is_code_fence_close(line : StringView) -> Bool {
  line == "```"
}

///|
fn is_blockquote_line(line : StringView) -> Bool {
  line.strip_prefix("> ") is Some(_) || line.strip_prefix(">") is Some(_)
}

///|
fn blockquote_text(line : StringView) -> StringView {
  let mut text = line.view(start_offset=1)
  if text.strip_prefix(" ") is Some(rest) {
    text = rest
  }
  text
}

///|
fn is_horizontal_rule(line : StringView) -> Bool {
  line == "---" || line == "***" || line == "___"
}

///|
fn is_table_row(line : StringView) -> Bool {
  line.strip_prefix("|") is Some(_) && find_from(line, 1, "|") is Some(_)
}

///|
fn is_table_separator(line : StringView) -> Bool {
  // Must start with |, contain at least one cell with only dashes/colons
  if !(line.strip_prefix("|") is Some(_)) {
    return false
  }
  for cell in table_content(line).split("|") {
    let t = cell.trim()
    if t.is_empty() {
      return false
    }
    if !is_sep_cell(t) {
      return false
    }
  }
  true
}

///|
fn is_sep_cell(cell : StringView) -> Bool {
  for ch in cell {
    if ch != '-' && ch != ':' && ch != ' ' {
      return false
    }
  }
  cell.contains("-")
}

///|
fn unordered_list_item_text(line : StringView) -> StringView? {
  match line.strip_prefix("- ") {
    None =>
      match line.strip_prefix("* ") {
        None => line.strip_prefix("+ ")
        item => item
      }
    item => item
  }
}

///|
fn unordered_list_item_indented(line : StringView, indent : Int) -> StringView? {
  let rest = line.view(start_offset=indent)
  match rest.strip_prefix("- ") {
    None =>
      match rest.strip_prefix("* ") {
        None => rest.strip_prefix("+ ")
        item => item
      }
    item => item
  }
}

///|
fn ordered_list_item_indented(line : StringView, indent : Int) -> StringView? {
  let rest = line.view(start_offset=indent)
  match find_from(rest, 0, ". ") {
    None => None
    Some(dot_index) =>
      if dot_index > 0 && all_digits(rest.view(end_offset=dot_index)) {
        Some(rest.view(start_offset=dot_index + 2))
      } else {
        None
      }
  }
}

///|
fn ordered_list_item_text(line : StringView) -> StringView? {
  match find_from(line, 0, ". ") {
    None => None
    Some(dot_index) =>
      if dot_index > 0 && all_digits(line.view(end_offset=dot_index)) {
        Some(line.view(start_offset=dot_index + 2))
      } else {
        None
      }
  }
}

///|
fn all_digits(text : StringView) -> Bool {
  for ch in text {
    if !is_digit(ch) {
      return false
    }
  }
  true
}

///|
fn is_digit(ch : Char) -> Bool {
  ch == '0' ||
  ch == '1' ||
  ch == '2' ||
  ch == '3' ||
  ch == '4' ||
  ch == '5' ||
  ch == '6' ||
  ch == '7' ||
  ch == '8' ||
  ch == '9'
}

///|
fn open_list(out : StringBuilder, first : Bool, tag : StringView) -> Bool {
  if !first {
    out.write_stringview("\n")
  }
  out.write_stringview("<")
  out.write_stringview(tag)
  out.write_stringview(">")
  false
}

///|
fn close_list(out : StringBuilder, tag : StringView) -> Unit {
  out.write_stringview("\n</")
  out.write_stringview(tag)
  out.write_stringview(">")
}

///|
fn write_list_item(
  out : StringBuilder,
  text : StringView,
  references : String,
) -> Unit {
  out.write_stringview("\n<li>")
  match task_list_item(text) {
    Some(task) => {
      out.write_stringview("<input type=\"checkbox\" disabled")
      if task.checked {
        out.write_stringview(" checked")
      }
      out.write_stringview("> ")
      write_inline(out, task.text, references)
    }
    None => write_inline(out, text, references)
  }
  out.write_stringview("</li>")
}

///|
priv struct TaskListItem {
  checked : Bool
  text : StringView
}

///|
fn task_list_item(text : StringView) -> TaskListItem? {
  match text.strip_prefix("[x] ") {
    Some(rest) => Some({ checked: true, text: rest })
    None =>
      match text.strip_prefix("[X] ") {
        Some(rest) => Some({ checked: true, text: rest })
        None =>
          match text.strip_prefix("[ ] ") {
            Some(rest) => Some({ checked: false, text: rest })
            None => None
          }
      }
  }
}

///|
fn write_blockquote_content_line(
  content : StringBuilder,
  text : StringView,
) -> Unit {
  if content.to_string().length() > 0 {
    content.write_stringview("\n")
  }
  content.write_stringview(text)
}

///|
fn close_blockquote(out : StringBuilder, content : StringBuilder) -> Unit {
  out.write_stringview(render(content.to_string()))
  out.write_stringview("\n</blockquote>")
}

///|
fn open_code_block(out : StringBuilder, first : Bool) -> Bool {
  if !first {
    out.write_stringview("\n")
  }
  out.write_stringview("<pre><code>")
  false
}

///|
fn close_code_block(out : StringBuilder) -> Unit {
  out.write_stringview("</code></pre>")
}

///|
fn write_code_block_line(
  out : StringBuilder,
  text : StringView,
  first_line : Bool,
) -> Bool {
  if !first_line {
    out.write_stringview("\n")
  }
  write_escaped(out, text)
  false
}

///|
fn open_table(out : StringBuilder, first : Bool) -> Bool {
  if !first {
    out.write_stringview("\n")
  }
  out.write_stringview("<table>")
  false
}

///|
fn close_table(out : StringBuilder) -> Unit {
  out.write_stringview("\n</table>")
}

///|
fn write_table_row(
  out : StringBuilder,
  line : StringView,
  references : String,
) -> Unit {
  out.write_stringview("\n<tr>")
  let mut cell = StringBuilder::new()
  let mut escaping = false
  for ch in table_content(line) {
    if escaping {
      if ch == '|' {
        cell.write_char('|')
      } else {
        cell.write_char('\\')
        cell.write_char(ch)
      }
      escaping = false
    } else if ch == '\\' {
      escaping = true
    } else if ch == '|' {
      write_table_cell(out, cell, references)
      cell = StringBuilder::new()
    } else {
      cell.write_char(ch)
    }
  }
  if escaping {
    cell.write_char('\\')
  }
  write_table_cell(out, cell, references)
  out.write_stringview("</tr>")
}

///|
fn write_table_cell(
  out : StringBuilder,
  cell : StringBuilder,
  references : String,
) -> Unit {
  out.write_stringview("<td>")
  let text = cell.to_string()
  write_inline(out, text.trim(), references)
  out.write_stringview("</td>")
}

///|
fn table_content(line : StringView) -> StringView {
  let mut start = 0
  let mut end = line.length()
  if end > 0 && line.view(end_offset=1) == "|" {
    start = 1
  }
  if end > start && line.view(start_offset=end - 1, end_offset=end) == "|" {
    end = end - 1
  }
  line.view(start_offset=start, end_offset=end)
}

///|
fn write_horizontal_rule(out : StringBuilder, first : Bool) -> Bool {
  if !first {
    out.write_stringview("\n")
  }
  out.write_stringview("<hr>")
  false
}

///|
fn render_line(out : StringBuilder, line : StringView, references : String) -> Unit {
  match line.strip_prefix("###### ") {
    Some(text) => write_heading_tag(out, "h6", text, references)
    None =>
      match line.strip_prefix("##### ") {
        Some(text) => write_heading_tag(out, "h5", text, references)
        None =>
          match line.strip_prefix("#### ") {
            Some(text) => write_heading_tag(out, "h4", text, references)
            None =>
              match line.strip_prefix("### ") {
                Some(text) => write_heading_tag(out, "h3", text, references)
                None =>
                  match line.strip_prefix("## ") {
                    Some(text) => write_heading_tag(out, "h2", text, references)
                    None =>
                      match line.strip_prefix("# ") {
                        Some(text) => write_heading_tag(out, "h1", text, references)
                        None => write_tag(out, "p", line, references)
                      }
                  }
              }
          }
      }
  }
}

///|
fn write_heading_tag(
  out : StringBuilder,
  tag : StringView,
  text : StringView,
  references : String,
) -> Unit {
  write_tag(out, tag, trim_closing_heading_hashes(text), references)
}

///|
fn trim_closing_heading_hashes(text : StringView) -> StringView {
  let trimmed = text.trim()
  match find_from(trimmed, 0, " #") {
    None => trimmed
    Some(first_candidate) => {
      let mut close_start = first_candidate
      let mut search_from = first_candidate + 1
      while find_from(trimmed, search_from, " #") is Some(next_candidate) {
        close_start = next_candidate
        search_from = next_candidate + 1
      }
      if only_hashes(trimmed.view(start_offset=close_start + 1)) {
        trimmed.view(end_offset=close_start)
      } else {
        trimmed
      }
    }
  }
}

///|
fn only_hashes(text : StringView) -> Bool {
  if text.is_empty() {
    return false
  }
  for ch in text {
    if ch != '#' {
      return false
    }
  }
  true
}

///|
fn write_tag(
  out : StringBuilder,
  tag : StringView,
  text : StringView,
  references : String,
) -> Unit {
  out.write_stringview("<")
  out.write_stringview(tag)
  out.write_stringview(">")
  write_inline(out, text, references)
  out.write_stringview("</")
  out.write_stringview(tag)
  out.write_stringview(">")
}

///|
fn write_inline(out : StringBuilder, text : StringView, references : String) -> Unit {
  write_inline_from(out, text, references, 0)
}

///|
fn write_inline_from(
  out : StringBuilder,
  text : StringView,
  references : String,
  start : Int,
) -> Unit {
  if start >= text.length() {
    return
  }
  match find_next_inline_marker(text, start) {
    None => write_escaped(out, text.view(start_offset=start))
    Some(marker_index) =>
      if marker_index + 1 < text.length() &&
        text.view(start_offset=marker_index, end_offset=marker_index + 2) ==
        "![" {
        write_image(out, text, references, start, marker_index)
      } else {
        let first_char = text.view(
          start_offset=marker_index,
          end_offset=marker_index + 1,
        )
        if first_char == "\\" {
          write_escaped(
            out,
            text.view(start_offset=start, end_offset=marker_index),
          )
          if marker_index + 1 < text.length() {
            write_escaped(
              out,
              text.view(
                start_offset=marker_index + 1,
                end_offset=marker_index + 2,
              ),
            )
          }
          write_inline_from(out, text, references, marker_index + 2)
        } else if first_char == "`" {
          write_code_span(out, text, references, start, marker_index)
        } else if first_char == "<" {
          write_autolink(out, text, references, start, marker_index)
        } else if first_char == "[" {
          write_link(out, text, references, start, marker_index)
        } else if first_char == "*" {
          if marker_index + 2 < text.length() &&
            text.view(start_offset=marker_index, end_offset=marker_index + 3) ==
            "***" {
            match find_from(text, marker_index + 3, "***") {
              None => write_escaped(out, text.view(start_offset=start))
              Some(close_index) => {
                write_escaped(
                  out,
                  text.view(start_offset=start, end_offset=marker_index),
                )
                out.write_stringview("<strong><em>")
                write_inline(
                  out,
                  text.view(
                    start_offset=marker_index + 3,
                    end_offset=close_index,
                  ),
                  references,
                )
                out.write_stringview("</em></strong>")
                write_inline_from(out, text, references, close_index + 3)
              }
            }
          } else if marker_index + 1 < text.length() &&
            text.view(start_offset=marker_index, end_offset=marker_index + 2) ==
            "**" {
            write_strong(out, text, references, start, marker_index)
          } else {
            write_em(out, text, references, start, marker_index)
          }
        } else if first_char == "_" {
          if marker_index + 2 < text.length() &&
            text.view(start_offset=marker_index, end_offset=marker_index + 3) ==
            "___" {
            match find_from(text, marker_index + 3, "___") {
              None => write_escaped(out, text.view(start_offset=start))
              Some(close_index) => {
                write_escaped(
                  out,
                  text.view(start_offset=start, end_offset=marker_index),
                )
                out.write_stringview("<strong><em>")
                write_inline(
                  out,
                  text.view(
                    start_offset=marker_index + 3,
                    end_offset=close_index,
                  ),
                  references,
                )
                out.write_stringview("</em></strong>")
                write_inline_from(out, text, references, close_index + 3)
              }
            }
          } else if marker_index + 1 < text.length() &&
            text.view(start_offset=marker_index, end_offset=marker_index + 2) ==
            "__" {
            match find_from(text, marker_index + 2, "__") {
              None => write_escaped(out, text.view(start_offset=start))
              Some(close_index) => {
                write_escaped(
                  out,
                  text.view(start_offset=start, end_offset=marker_index),
                )
                out.write_stringview("<strong>")
                write_inline(
                  out,
                  text.view(
                    start_offset=marker_index + 2,
                    end_offset=close_index,
                  ),
                  references,
                )
                out.write_stringview("</strong>")
                write_inline_from(out, text, references, close_index + 2)
              }
            }
          } else {
            write_em(out, text, references, start, marker_index)
          }
        } else {
          write_escaped(out, text.view(start_offset=start))
        }
      }
  }
}

///|
fn find_next_inline_marker(text : StringView, start : Int) -> Int? {
  // Find `` but not ``` (code fence)
  let double_backtick = find_non_fence_double_backtick(text, start)
  earliest_index(
    find_from(text, start, "\\"),
    earliest_index(
      earliest_index(
        earliest_index(
          earliest_index(
            earliest_index(double_backtick, find_from(text, start, "`")),
            find_from(text, start, "!["),
          ),
          find_from(text, start, "***"),
        ),
        earliest_index(
          find_from(text, start, "___"),
          earliest_index(
            earliest_index(
              find_from(text, start, "**"),
              find_from(text, start, "__"),
            ),
            earliest_index(
              find_from(text, start, "["),
              find_from(text, start, "<"),
            ),
          ),
        ),
      ),
      earliest_index(find_from(text, start, "*"), find_from(text, start, "_")),
    ),
  )
}

///|
fn find_non_fence_double_backtick(text : StringView, start : Int) -> Int? {
  match find_from(text, start, "``") {
    None => None
    Some(idx) =>
      if idx + 2 < text.length() &&
        text.view(start_offset=idx, end_offset=idx + 3) == "```" {
        // Skip triple backtick, look again after it
        match find_from(text, idx + 3, "``") {
          None => None
          Some(next) => find_non_fence_double_backtick(text, next)
        }
      } else {
        Some(idx)
      }
  }
}

///|
fn earliest_index(left : Int?, right : Int?) -> Int? {
  match left {
    None => right
    Some(left_index) =>
      match right {
        None => Some(left_index)
        Some(right_index) =>
          if left_index < right_index {
            Some(left_index)
          } else {
            Some(right_index)
          }
      }
  }
}

///|
fn write_autolink(
  out : StringBuilder,
  text : StringView,
  references : String,
  start : Int,
  open_index : Int,
) -> Unit {
  match find_from(text, open_index + 1, ">") {
    None => write_escaped(out, text.view(start_offset=start))
    Some(close_index) => {
      let url = text.view(start_offset=open_index + 1, end_offset=close_index)
      if url.contains("://") || url.contains("@") {
        write_escaped(out, text.view(start_offset=start, end_offset=open_index))
        if url.contains("@") {
          out.write_stringview("<a href=\"mailto:")
          write_escaped(out, url)
          out.write_stringview("\">")
          write_escaped(out, url)
          out.write_stringview("</a>")
        } else {
          out.write_stringview("<a href=\"")
          write_escaped(out, url)
          out.write_stringview("\">")
          write_escaped(out, url)
          out.write_stringview("</a>")
        }
        write_inline_from(out, text, references, close_index + 1)
      } else {
        write_escaped(
          out,
          text.view(start_offset=start, end_offset=close_index + 1),
        )
        write_inline_from(out, text, references, close_index + 1)
      }
    }
  }
}

///|
fn write_code_span(
  out : StringBuilder,
  text : StringView,
  references : String,
  start : Int,
  open_index : Int,
) -> Unit {
  // Check for double-backtick: ````
  if open_index + 1 < text.length() &&
    text.view(start_offset=open_index, end_offset=open_index + 2) == "``" &&
    !(open_index + 2 < text.length() &&
    text.view(start_offset=open_index, end_offset=open_index + 3) == "```") {
    // Double-backtick code span
    match find_from(text, open_index + 2, "``") {
      None => write_escaped(out, text.view(start_offset=start))
      Some(close_index) => {
        write_escaped(out, text.view(start_offset=start, end_offset=open_index))
        out.write_stringview("<code>")
        write_escaped(
          out,
          text.view(start_offset=open_index + 2, end_offset=close_index),
        )
        out.write_stringview("</code>")
        write_inline_from(out, text, references, close_index + 2)
      }
    }
  } else {
    match find_from(text, open_index + 1, "`") {
      None => write_escaped(out, text.view(start_offset=start))
      Some(close_index) => {
        write_escaped(out, text.view(start_offset=start, end_offset=open_index))
        out.write_stringview("<code>")
        write_escaped(
          out,
          text.view(start_offset=open_index + 1, end_offset=close_index),
        )
        out.write_stringview("</code>")
        write_inline_from(out, text, references, close_index + 1)
      }
    }
  }
}

///|
fn write_em(
  out : StringBuilder,
  text : StringView,
  references : String,
  start : Int,
  open_index : Int,
) -> Unit {
  let delimiter = text.view(start_offset=open_index, end_offset=open_index + 1)
  match find_from(text, open_index + 1, delimiter) {
    None => write_escaped(out, text.view(start_offset=start))
    Some(close_index) => {
      write_escaped(out, text.view(start_offset=start, end_offset=open_index))
      out.write_stringview("<em>")
      write_inline(
        out,
        text.view(start_offset=open_index + 1, end_offset=close_index),
        references,
      )
      out.write_stringview("</em>")
      write_inline_from(out, text, references, close_index + 1)
    }
  }
}

///|
fn write_strong(
  out : StringBuilder,
  text : StringView,
  references : String,
  start : Int,
  open_index : Int,
) -> Unit {
  match find_from(text, open_index + 2, "**") {
    None => write_escaped(out, text.view(start_offset=start))
    Some(close_index) => {
      write_escaped(out, text.view(start_offset=start, end_offset=open_index))
      out.write_stringview("<strong>")
      write_inline(
        out,
        text.view(start_offset=open_index + 2, end_offset=close_index),
        references,
      )
      out.write_stringview("</strong>")
      write_inline_from(out, text, references, close_index + 2)
    }
  }
}

///|
fn write_link(
  out : StringBuilder,
  text : StringView,
  references : String,
  start : Int,
  open_index : Int,
) -> Unit {
  match find_closing_bracket(text, open_index + 1) {
    None => write_escaped(out, text.view(start_offset=start))
    Some(label_end) =>
      if label_end + 1 < text.length() &&
        text.view(start_offset=label_end + 1, end_offset=label_end + 2) == "(" {
        match find_from(text, label_end + 2, ")") {
          None => write_escaped(out, text.view(start_offset=start))
          Some(url_end) => {
            // Check for optional title: url "title" or url 'title' or url (title)
            let url_part = text.view(
              start_offset=label_end + 2,
              end_offset=url_end,
            )
            let mut effective_url_end = url_end
            match url_part.find(" ") {
              None => ()
              Some(space_idx) => effective_url_end = label_end + 2 + space_idx
            }
            write_escaped(
              out,
              text.view(start_offset=start, end_offset=open_index),
            )
            out.write_stringview("<a href=\"")
            write_escaped(
              out,
              text.view(
                start_offset=label_end + 2,
                end_offset=effective_url_end,
              ),
            )
            out.write_stringview("\">")
            write_inline(
              out,
              text.view(start_offset=open_index + 1, end_offset=label_end),
              references,
            )
            out.write_stringview("</a>")
            write_inline_from(out, text, references, url_end + 1)
          }
        }
      } else if label_end + 1 < text.length() &&
        text.view(start_offset=label_end + 1, end_offset=label_end + 2) == "[" {
        match find_closing_bracket(text, label_end + 2) {
          None => write_escaped(out, text.view(start_offset=start))
          Some(reference_end) => {
            let label = text.view(start_offset=open_index + 1, end_offset=label_end)
            let key = text.view(start_offset=label_end + 2, end_offset=reference_end)
            let lookup_key = if key.is_empty() { label } else { key }
            match find_reference_url(references, lookup_key) {
              None => write_escaped(out, text.view(start_offset=start, end_offset=reference_end + 1))
              Some(url) => {
                write_escaped(out, text.view(start_offset=start, end_offset=open_index))
                out.write_stringview("<a href=\"")
                write_escaped(out, url)
                out.write_stringview("\">")
                write_inline(out, label, references)
                out.write_stringview("</a>")
                write_inline_from(out, text, references, reference_end + 1)
              }
            }
          }
        }
      } else {
        let label = text.view(start_offset=open_index + 1, end_offset=label_end)
        match find_reference_url(references, label) {
          None => {
            write_escaped(out, text.view(start_offset=start, end_offset=label_end + 1))
            write_inline_from(out, text, references, label_end + 1)
          }
          Some(url) => {
            write_escaped(out, text.view(start_offset=start, end_offset=open_index))
            out.write_stringview("<a href=\"")
            write_escaped(out, url)
            out.write_stringview("\">")
            write_inline(out, label, references)
            out.write_stringview("</a>")
            write_inline_from(out, text, references, label_end + 1)
          }
        }
      }
  }
}

///|
fn write_image(
  out : StringBuilder,
  text : StringView,
  references : String,
  start : Int,
  open_index : Int,
) -> Unit {
  match find_closing_bracket(text, open_index + 2) {
    None => write_escaped(out, text.view(start_offset=start))
    Some(alt_end) =>
      if alt_end + 1 < text.length() &&
        text.view(start_offset=alt_end + 1, end_offset=alt_end + 2) == "(" {
        match find_from(text, alt_end + 2, ")") {
          None => write_escaped(out, text.view(start_offset=start))
          Some(src_end) => {
            let src_part = text.view(
              start_offset=alt_end + 2,
              end_offset=src_end,
            )
            let mut effective_src_end = src_end
            match src_part.find(" ") {
              None => ()
              Some(space_idx) => effective_src_end = alt_end + 2 + space_idx
            }
            write_escaped(
              out,
              text.view(start_offset=start, end_offset=open_index),
            )
            out.write_stringview("<img alt=\"")
            write_escaped(
              out,
              text.view(start_offset=open_index + 2, end_offset=alt_end),
            )
            out.write_stringview("\" src=\"")
            write_escaped(
              out,
              text.view(start_offset=alt_end + 2, end_offset=effective_src_end),
            )
            out.write_stringview("\">")
            write_inline_from(out, text, references, src_end + 1)
          }
        }
      } else if alt_end + 1 < text.length() &&
        text.view(start_offset=alt_end + 1, end_offset=alt_end + 2) == "[" {
        match find_closing_bracket(text, alt_end + 2) {
          None => write_escaped(out, text.view(start_offset=start))
          Some(reference_end) => {
            let alt = text.view(start_offset=open_index + 2, end_offset=alt_end)
            let key = text.view(start_offset=alt_end + 2, end_offset=reference_end)
            let lookup_key = if key.is_empty() { alt } else { key }
            match find_reference_url(references, lookup_key) {
              None => write_escaped(out, text.view(start_offset=start, end_offset=reference_end + 1))
              Some(src) => {
                write_escaped(out, text.view(start_offset=start, end_offset=open_index))
                out.write_stringview("<img alt=\"")
                write_escaped(out, alt)
                out.write_stringview("\" src=\"")
                write_escaped(out, src)
                out.write_stringview("\">")
                write_inline_from(out, text, references, reference_end + 1)
              }
            }
          }
        }
      } else {
        write_escaped(out, text.view(start_offset=start))
      }
  }
}

///|
fn find_reference_url(references : String, key : StringView) -> StringView? {
  for line in references.split("\n") {
    let trimmed = line.trim()
    if trimmed.strip_prefix("[") is Some(rest) {
      match find_from(rest, 0, "]:") {
        None => ()
        Some(label_end) => {
          let label = rest.view(end_offset=label_end)
          if label == key {
            let tail = rest.view(start_offset=label_end + 2).trim()
            match tail.find(" ") {
              None => return Some(tail)
              Some(space_index) => return Some(tail.view(end_offset=space_index))
            }
          }
        }
      }
    }
  }
  None
}

///|
fn find_closing_bracket(text : StringView, start : Int) -> Int? {
  let mut index = start
  let mut depth = 0
  let mut escaping = false
  for ch in text.view(start_offset=start) {
    if escaping {
      escaping = false
    } else if ch == '\\' {
      escaping = true
    } else if ch == '[' {
      depth = depth + 1
    } else if ch == ']' {
      if depth == 0 {
        return Some(index)
      }
      depth = depth - 1
    }
    index = index + 1
  }
  None
}

///|
fn find_from(text : StringView, start : Int, needle : StringView) -> Int? {
  match text.view(start_offset=start).find(needle) {
    None => None
    Some(index) => Some(start + index)
  }
}

///|
fn write_escaped(out : StringBuilder, text : StringView) -> Unit {
  for ch in text {
    match ch {
      '&' => out.write_stringview("&amp;")
      '<' => out.write_stringview("&lt;")
      '>' => out.write_stringview("&gt;")
      '"' => out.write_stringview("&quot;")
      _ => out.write_char(ch)
    }
  }
}
