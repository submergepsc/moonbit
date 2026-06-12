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
const stackeditButton = document.querySelector("#open-stackedit");
const codePenButton = document.querySelector("#open-codepen");

let sourceFileName = "moon-markdown";

const md = markdownit({ html: true, linkify: true, typographer: true });

function renderMoonHtml() {
  if (!globalThis.MoonMarkdown || typeof globalThis.MoonMarkdown.render !== "function") {
    return "";
  }
  return globalThis.MoonMarkdown.render(input.value);
}

function renderMarkdown() {
  preview.innerHTML = md.render(input.value);

  const moonHtml = renderMoonHtml();
  output.textContent = moonHtml;
  status.textContent = moonHtml ? "Rendered" : "Renderer not loaded";
  return moonHtml;
}

input.value = initialMarkdown;
input.addEventListener("input", renderMarkdown);

fileInput.addEventListener("change", async () => {
  const file = fileInput.files[0];
  if (!file) return;
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

// StackEdit: 复制 Markdown → 跳转 → 粘贴
if (stackeditButton) {
  stackeditButton.addEventListener("click", async () => {
    const markdown = input.value;
    await navigator.clipboard.writeText(markdown);
    status.textContent = "Copied to clipboard, opening StackEdit...";
    window.location.href = "https://stackedit.io/app";
  });
}

// CodePen: 复制 MoonBit 生成的 HTML → 跳转 → 粘贴到 HTML 窗格
if (codePenButton) {
  codePenButton.addEventListener("click", async () => {
    const html = output.textContent || renderMoonHtml();
    await navigator.clipboard.writeText(html);
    status.textContent = "Copied to clipboard, opening CodePen...";
    window.location.href = "https://codepen.io/pen/";
  });
}

function escapeHtml(text) {
  return text
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

renderMarkdown();
