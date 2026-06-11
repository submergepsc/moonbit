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
const fileInput = document.querySelector("#file-input");
const downloadButton = document.querySelector("#download-html");
const copyButton = document.querySelector("#copy-html");

let sourceFileName = "moon-markdown";

function renderMarkdown() {
  if (!globalThis.MoonMarkdown || typeof globalThis.MoonMarkdown.render !== "function") {
    status.textContent = "Renderer not loaded";
    return "";
  }

  const html = globalThis.MoonMarkdown.render(input.value);
  preview.innerHTML = html;
  output.textContent = html;
  status.textContent = "Rendered";
  return html;
}

input.value = initialMarkdown;
input.addEventListener("input", renderMarkdown);

fileInput.addEventListener("change", async () => {
  const file = fileInput.files[0];
  if (!file) {
    return;
  }

  sourceFileName = file.name.replace(/\.[^.]+$/, "") || "moon-markdown";
  input.value = await file.text();
  renderMarkdown();
  status.textContent = `Loaded ${file.name}`;
});

downloadButton.addEventListener("click", () => {
  const html = output.textContent || renderMarkdown();
  const documentHtml = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${escapeHtml(sourceFileName)}</title>
  </head>
  <body>
${html}
  </body>
</html>
`;
  const blob = new Blob([documentHtml], { type: "text/html;charset=utf-8" });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = `${sourceFileName}.html`;
  link.click();
  URL.revokeObjectURL(link.href);
  status.textContent = `Downloaded ${link.download}`;
});

copyButton.addEventListener("click", async () => {
  await navigator.clipboard.writeText(output.textContent);
  status.textContent = "HTML copied";
});

function escapeHtml(text) {
  return text
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

renderMarkdown();
