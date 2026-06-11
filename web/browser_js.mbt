///|
extern "js" fn install_renderer(render : (String) -> String) -> Unit =
  #|(render) => {
  #|  globalThis.MoonMarkdown = {
  #|    render(markdown) {
  #|      return render(String(markdown ?? ""));
  #|    }
  #|  };
  #|}
