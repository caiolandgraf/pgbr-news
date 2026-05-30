import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "confirmation", "matchHint", "lengthHint"]
  static values = { min: Number }

  connect() {
    this.validate()
  }

  validate() {
    const password = this.passwordTarget.value
    const confirmation = this.confirmationTarget.value

    if (this.hasLengthHintTarget) {
      const ok = password.length >= this.minValue
      this.lengthHintTarget.classList.toggle("text-emerald-600", ok)
      this.lengthHintTarget.classList.toggle("dark:text-emerald-400", ok)
      this.lengthHintTarget.classList.toggle("text-zinc-500", !ok)
    }

    if (this.hasMatchHintTarget && confirmation.length > 0) {
      const matches = password === confirmation
      this.matchHintTarget.textContent = matches ? "Senhas conferem" : "Senhas não conferem"
      this.matchHintTarget.classList.toggle("text-emerald-600", matches)
      this.matchHintTarget.classList.toggle("dark:text-emerald-400", matches)
      this.matchHintTarget.classList.toggle("text-red-600", !matches)
      this.matchHintTarget.classList.toggle("dark:text-red-400", !matches)
      this.matchHintTarget.classList.remove("hidden")
    } else if (this.hasMatchHintTarget) {
      this.matchHintTarget.classList.add("hidden")
    }
  }
}
