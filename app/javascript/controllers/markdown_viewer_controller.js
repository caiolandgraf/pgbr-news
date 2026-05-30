import { Controller } from "@hotwired/stimulus"
import { createViewer } from "markdown_editor"

export default class extends Controller {
  static targets = ["source", "mount"]

  connect() {
    this.onThemeChange = () => this.refresh()
    document.addEventListener("theme:changed", this.onThemeChange)
    this.render()
  }

  disconnect() {
    document.removeEventListener("theme:changed", this.onThemeChange)
    if (this.viewer) {
      this.viewer.$destroy()
      this.viewer = null
    }
  }

  render() {
    if (this.viewer) {
      this.viewer.$destroy()
      this.viewer = null
    }

    this.viewer = createViewer({
      target: this.mountTarget,
      value: this.sourceTarget.value
    })
  }

  refresh() {
    this.render()
  }
}
