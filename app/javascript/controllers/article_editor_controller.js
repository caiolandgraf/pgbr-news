import { Controller } from "@hotwired/stimulus"
import { createEditor } from "markdown_editor"

export default class extends Controller {
  static targets = ["body", "counter", "mount"]
  static values = { max: Number }

  connect() {
    this.onThemeChange = () => this.refreshTheme()
    document.addEventListener("theme:changed", this.onThemeChange)
    this.initEditor()
  }

  disconnect() {
    document.removeEventListener("theme:changed", this.onThemeChange)
    if (this.editor) {
      this.editor.$destroy()
      this.editor = null
    }
  }

  initEditor() {
    if (this.editor) return

    this.mountTarget.replaceChildren()

    this.editor = createEditor({
      target: this.mountTarget,
      value: this.bodyTarget.value,
      mode: "auto",
      onChange: (value) => {
        this.bodyTarget.value = value
        this.updateCounter()
      }
    })

    this.updateCounter()
    this.refreshLayout()
  }

  refreshLayout() {
    requestAnimationFrame(() => {
      this.mountTarget.querySelectorAll(".CodeMirror").forEach((element) => {
        element.CodeMirror?.refresh()
      })
    })
  }

  refreshTheme() {
    if (!this.editor) return

    const value = this.bodyTarget.value
    this.editor.$set({ value: value + "\u200b" })
    this.editor.$set({ value })
    this.refreshLayout()
  }

  updateCounter() {
    const length = this.bodyTarget.value.length
    const max = this.maxValue

    this.counterTarget.textContent = `${length}/${max}`
    this.counterTarget.classList.toggle("text-red-500", length > max)
    this.counterTarget.classList.toggle("dark:text-red-400", length > max)
    this.counterTarget.classList.toggle("text-zinc-500", length <= max)
  }
}
