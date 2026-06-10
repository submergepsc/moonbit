///|
pub fn render(markdown : String) -> String {
  let out = StringBuilder::new()
  let mut first = true
  for line in markdown.split("\n") {
    let trimmed = line.trim()
    if !trimmed.is_empty() {
      if first {
        first = false
      } else {
        out.write_stringview("\n")
      }
      render_line(out, trimmed)
    }
  }
  out.to_string()
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
        _ => write_escaped(out, text.view(start_offset=start))
      }
  }
}

///|
fn find_next_inline_marker(text : StringView, start : Int) -> Int? {
  match find_from(text, start, "`") {
    None => find_from(text, start, "[")
    Some(code_index) =>
      match find_from(text, start, "[") {
        None => Some(code_index)
        Some(link_index) =>
          if code_index < link_index {
            Some(code_index)
          } else {
            Some(link_index)
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
