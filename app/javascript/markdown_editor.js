import { Editor, Viewer } from "https://esm.sh/bytemd@1.22.0"
import gfm from "https://esm.sh/@bytemd/plugin-gfm@1.22.0"
import highlight from "https://esm.sh/@bytemd/plugin-highlight@1.22.0"
import breaks from "https://esm.sh/@bytemd/plugin-breaks@1.22.0"

const locale = {
  bold: "Negrito",
  boldText: "texto em negrito",
  cheatsheet: "Referência de Markdown",
  closeHelp: "Fechar ajuda",
  closeToc: "Fechar índice",
  code: "Código",
  codeBlock: "Bloco de código",
  codeLang: "linguagem",
  codeText: "código",
  exitFullscreen: "Sair da tela cheia",
  exitPreviewOnly: "Sair do modo visualizar",
  exitWriteOnly: "Sair do modo escrever",
  fullscreen: "Tela cheia",
  h1: "Cabeçalho 1",
  h2: "Cabeçalho 2",
  h3: "Cabeçalho 3",
  h4: "Cabeçalho 4",
  h5: "Cabeçalho 5",
  h6: "Cabeçalho 6",
  headingText: "cabeçalho",
  help: "Ajuda",
  hr: "Linha horizontal",
  image: "Imagem",
  imageAlt: "texto",
  imageTitle: "título",
  italic: "Itálico",
  italicText: "texto itálico",
  limited: "Limite máximo de caracteres atingido",
  lines: "Linhas",
  link: "Link",
  linkText: "texto",
  ol: "Lista numerada",
  olItem: "item",
  preview: "Visualizar",
  previewOnly: "Apenas visualizar",
  quote: "Citação",
  quotedText: "citação",
  shortcuts: "Atalhos",
  source: "Código fonte",
  strikethrough: "Tachado",
  strikethroughText: "texto tachado",
  table: "Tabela",
  textToTranslate: "Texto para traduzir",
  toc: "Índice",
  top: "Topo",
  ul: "Lista",
  ulItem: "item",
  write: "Escrever",
  writeOnly: "Apenas escrever"
}

const gfmLocale = {
  table: "Tabela",
  blockquote: "Citação",
  bold: "Negrito",
  strikethrough: "Tachado",
  italic: "Itálico",
  inlineCode: "Código inline",
  code: "Bloco de código",
  link: "Link",
  image: "Imagem",
  unorderedList: "Lista",
  orderedList: "Lista numerada",
  checkedList: "Lista de tarefas",
  help: "Ajuda"
}

export function createPlugins() {
  return [
    gfm({ locale: gfmLocale }),
    highlight(),
    breaks()
  ]
}

export function createEditor({ target, value, onChange, mode = "tab" }) {
  const editor = new Editor({
    target,
    props: {
      value: value || "",
      plugins: createPlugins(),
      mode,
      locale,
      placeholder: "Escreva em Markdown…",
      editorConfig: { spellcheck: true }
    }
  })

  editor.$on("change", (event) => {
    const next = event.detail.value
    editor.$set({ value: next })
    onChange(next)
  })

  return editor
}

export function createViewer({ target, value }) {
  return new Viewer({
    target,
    props: {
      value: value || "",
      plugins: createPlugins()
    }
  })
}
