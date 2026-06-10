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
  write_escaped(out, text)
  out.write_stringview("</")
  out.write_stringview(tag)
  out.write_stringview(">")
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
