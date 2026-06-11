///|
fn main {
  let args = @env.args()
  match args.length() {
    3 => {
      let markdown = read_text_file(args[2])
      println(@lib.render(markdown))
    }
    4 => {
      let markdown = read_text_file(args[2])
      write_text_file(args[3], @lib.render(markdown))
    }
    _ => print_usage()
  }
}

///|
fn print_usage() -> Unit {
  println("Usage: moon run cli --target js <input.md> [output.html]")
}
