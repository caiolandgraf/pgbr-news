import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["iconSun", "iconMoon"]

  connect() {
    this.syncIcons()
  }

  toggle() {
    const isDark = document.documentElement.classList.toggle("dark")
    localStorage.theme = isDark ? "dark" : "light"
    document.documentElement.dataset.colorMode = isDark ? "dark" : "light"
    this.syncIcons()
    document.dispatchEvent(new CustomEvent("theme:changed"))
  }

  syncIcons() {
    const isDark = document.documentElement.classList.contains("dark")
    this.iconSunTarget?.classList.toggle("hidden", !isDark)
    this.iconMoonTarget?.classList.toggle("hidden", isDark)
  }
}
