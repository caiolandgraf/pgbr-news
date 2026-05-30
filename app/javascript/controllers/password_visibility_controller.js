import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "showLabel", "hideLabel"]

  toggle() {
    const isPassword = this.inputTarget.type === "password"
    this.inputTarget.type = isPassword ? "text" : "password"
    this.showLabelTarget.classList.toggle("hidden", isPassword)
    this.hideLabelTarget.classList.toggle("hidden", !isPassword)
  }
}
