import { Controller } from "@hotwired/stimulus"
import { createEditor } from "markdown_editor"

export default class extends Controller {
  static targets = ["body", "counter", "mount"]
  static values = { max: Number, initialMode: String, compact: Boolean }

  connect() {
    this.onThemeChange = () => this.refreshTheme()
    document.addEventListener("theme:changed", this.onThemeChange)
    this.writeOnlyObserver = null
    this.initEditor()
  }

  disconnect() {
    document.removeEventListener("theme:changed", this.onThemeChange)
    if (this.writeOnlyObserver) {
      this.writeOnlyObserver.disconnect()
      this.writeOnlyObserver = null
    }
    if (this.editor) {
      this.editor.$destroy()
      this.editor = null
    }
  }

  initEditor() {
    if (this.editor) return

    this.mountTarget.replaceChildren()

    const mode = this.hasInitialModeValue ? this.initialModeValue : "auto"

    this.editor = createEditor({
      target: this.mountTarget,
      value: this.bodyTarget.value,
      mode: mode,
      onChange: (value) => {
        this.bodyTarget.value = value
        this.updateCounter()
      }
    })

    this.updateCounter()
    this.refreshLayout()

    if (!this.hasCompactValue || this.compactValue === false) {
      this.enableWriteOnlyMode()
    }
  }

  enableWriteOnlyMode() {
    if (this.writeOnlyObserver) return

    const clickWriteOnly = () => {
      const button = this.mountTarget.querySelector(
        '.bytemd-toolbar-right .bytemd-toolbar-icon[bytemd-tippy-path="2"]'
      )

      if (!button) return false
      if (button.classList.contains('bytemd-toolbar-icon-active')) return true

      button.click()
      return true
    }

    if (clickWriteOnly()) return

    this.writeOnlyObserver = new MutationObserver(() => {
      if (clickWriteOnly() && this.writeOnlyObserver) {
        this.writeOnlyObserver.disconnect()
        this.writeOnlyObserver = null
      }
    })

    this.writeOnlyObserver.observe(this.mountTarget, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['class']
    })
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
