const initialMarkdown = `# Moon Markdown

Write Markdown on the left.

- Preview HTML locally
- Reuse the MoonBit renderer
- Copy generated HTML

\`\`\`moonbit
let html = render("# Title")
\`\`\`

Visit [MoonBit](https://www.moonbitlang.com).`;

const input = document.querySelector("#markdown-input");
const preview = document.querySelector("#preview");
const output = document.querySelector("#html-output");
const status = document.querySelector("#status");
const copyButton = document.querySelector("#copy-html");

function renderMarkdown() {
  if (!globalThis.MoonMarkdown || typeof globalThis.MoonMarkdown.render !== "function") {
    status.textContent = "Renderer not loaded";
    return;
  }

  const html = globalThis.MoonMarkdown.render(input.value);
  preview.innerHTML = html;
  output.textContent = html;
  status.textContent = "Rendered";
}

input.value = initialMarkdown;
input.addEventListener("input", renderMarkdown);

copyButton.addEventListener("click", async () => {
  await navigator.clipboard.writeText(output.textContent);
  status.textContent = "HTML copied";
});

renderMarkdown();
