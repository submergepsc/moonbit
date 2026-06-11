///|
extern "js" fn read_text_file(path : String) -> String =
  #|(path) => {
  #|  const fs = require("fs");
  #|  return fs.readFileSync(path, "utf8");
  #|}
