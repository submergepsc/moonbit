///|
pub fn render(markdown : String) -> String {
  let out = StringBuilder::new()
  let mut first = true
  let mut list_tag = ""
  let mut in_table = false
  let mut in_code_block = false
  let mut first_code_line = true
  for line in markdown.split("\n") {
    let trimmed = line.trim()
    if in_code_block {
      if is_code_fence(trimmed) {
        close_code_block(out)
        in_code_block = false
      } else {
        first_code_line = write_code_block_line(out, line, first_code_line)
      }
    } else if !trimmed.is_empty() {
      if is_table_separator(trimmed) {
        ()
      } else if is_table_row(trimmed) {
        if !list_tag.is_empty() {
          close_list(out, list_tag)
          list_tag = ""
        }
        if !in_table {
          first = open_table(out, first)
          in_table = true
        }
        write_table_row(out, trimmed)
      } else {
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
          write_list_item(out, item)
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
              write_list_item(out, item)
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
                render_line(out, trimmed)
              }
            }
          }
      }
      }
    }
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
fn is_code_fence(line : StringView) -> Bool {
  line.strip_prefix("```") is Some(_)
}

///|
fn is_horizontal_rule(line : StringView) -> Bool {
  line == "---"
}

///|
fn is_table_row(line : StringView) -> Bool {
  line.strip_prefix("|") is Some(_) && find_from(line, 1, "|") is Some(_)
}

///|
fn is_table_separator(line : StringView) -> Bool {
  is_table_row(line) && find_from(line, 0, "---") is Some(_)
}

///|
fn unordered_list_item_text(line : StringView) -> StringView? {
  line.strip_prefix("- ")
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
  ch == '0' || ch == '1' || ch == '2' || ch == '3' || ch == '4' ||
  ch == '5' || ch == '6' || ch == '7' || ch == '8' || ch == '9'
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
fn write_list_item(out : StringBuilder, text : StringView) -> Unit {
  out.write_stringview("\n<li>")
  write_inline(out, text)
  out.write_stringview("</li>")
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
  first_line : Bool
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
fn write_table_row(out : StringBuilder, line : StringView) -> Unit {
  out.write_stringview("\n<tr>")
  for cell in table_content(line).split("|") {
    out.write_stringview("<td>")
    write_inline(out, cell.trim())
    out.write_stringview("</td>")
  }
  out.write_stringview("</tr>")
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
fn render_line(out : StringBuilder, line : StringView) -> Unit {
  match line.strip_prefix("### ") {
    Some(text) => write_tag(out, "h3", text)
    None =>
      match line.strip_prefix("## ") {
        Some(text) => write_tag(out, "h2", text)
        None =>
          match line.strip_prefix("# ") {
            Some(text) => write_tag(out, "h1", text)
            None => write_tag(out, "p", line)
          }
      }
  }
}

///|
fn write_tag(out : StringBuilder, tag : StringView, text : StringView) -> Unit {
  out.write_stringview("<")
  out.write_stringview(tag)
  out.write_stringview(">")
  write_inline(out, text)
  out.write_stringview("</")
  out.write_stringview(tag)
  out.write_stringview(">")
}

///|
fn write_inline(out : StringBuilder, text : StringView) -> Unit {
  write_inline_from(out, text, 0)
}

///|
fn write_inline_from(
  out : StringBuilder,
  text : StringView,
  start : Int
) -> Unit {
  if start >= text.length() {
    return
  }
  match find_next_inline_marker(text, start) {
    None => write_escaped(out, text.view(start_offset=start))
    Some(marker_index) =>
      match text.view(start_offset=marker_index, end_offset=marker_index + 1) {
        "`" => write_code_span(out, text, start, marker_index)
        "[" => write_link(out, text, start, marker_index)
        "*" => write_strong(out, text, start, marker_index)
        _ => write_escaped(out, text.view(start_offset=start))
      }
  }
}

///|
fn find_next_inline_marker(text : StringView, start : Int) -> Int? {
  earliest_index(
    earliest_index(find_from(text, start, "`"), find_from(text, start, "[")),
    find_from(text, start, "**"),
  )
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
fn write_code_span(
  out : StringBuilder,
  text : StringView,
  start : Int,
  open_index : Int
) -> Unit {
  match find_from(text, open_index + 1, "`") {
    None => write_escaped(out, text.view(start_offset=start))
    Some(close_index) => {
      write_escaped(out, text.view(start_offset=start, end_offset=open_index))
      out.write_stringview("<code>")
      write_escaped(out, text.view(start_offset=open_index + 1, end_offset=close_index))
      out.write_stringview("</code>")
      write_inline_from(out, text, close_index + 1)
    }
  }
}

///|
fn write_strong(
  out : StringBuilder,
  text : StringView,
  start : Int,
  open_index : Int
) -> Unit {
  match find_from(text, open_index + 2, "**") {
    None => write_escaped(out, text.view(start_offset=start))
    Some(close_index) => {
      write_escaped(out, text.view(start_offset=start, end_offset=open_index))
      out.write_stringview("<strong>")
      write_inline(out, text.view(start_offset=open_index + 2, end_offset=close_index))
      out.write_stringview("</strong>")
      write_inline_from(out, text, close_index + 2)
    }
  }
}

///|
fn write_link(
  out : StringBuilder,
  text : StringView,
  start : Int,
  open_index : Int
) -> Unit {
  match find_from(text, open_index + 1, "]") {
    None => write_escaped(out, text.view(start_offset=start))
    Some(label_end) =>
      if label_end + 1 < text.length() &&
        text.view(start_offset=label_end + 1, end_offset=label_end + 2) == "(" {
        match find_from(text, label_end + 2, ")") {
          None => write_escaped(out, text.view(start_offset=start))
          Some(url_end) => {
            write_escaped(out, text.view(start_offset=start, end_offset=open_index))
            out.write_stringview("<a href=\"")
            write_escaped(out, text.view(start_offset=label_end + 2, end_offset=url_end))
            out.write_stringview("\">")
            write_inline(out, text.view(start_offset=open_index + 1, end_offset=label_end))
            out.write_stringview("</a>")
            write_inline_from(out, text, url_end + 1)
          }
        }
      } else {
        write_escaped(out, text.view(start_offset=start))
      }
  }
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
