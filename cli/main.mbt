///|
fn main {
  let args = @env.args()
  if args.length() != 3 {
    print_usage()
  } else {
    let markdown = read_text_file(args[2])
    println(@lib.render(markdown))
  }
}

///|
fn print_usage() -> Unit {
  println("Usage: moon run cli --target js <input.md>")
}
