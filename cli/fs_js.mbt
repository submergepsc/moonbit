///|
extern "js" fn read_text_file(path : String) -> String =
  #|(path) => {
  #|  const fs = require("fs");
  #|  return fs.readFileSync(path, "utf8");
  #|}

///|
extern "js" fn write_text_file(path : String, content : String) -> Unit =
  #|(path, content) => {
  #|  const fs = require("fs");
  #|  fs.writeFileSync(path, content, "utf8");
  #|}
