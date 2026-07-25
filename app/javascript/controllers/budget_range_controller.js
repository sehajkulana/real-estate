import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["minimum", "maximum", "value", "input"]

  connect() {
    this.sync()
  }

  updateMinimum() {
    if (Number(this.minimumTarget.value) > Number(this.maximumTarget.value)) {
      this.maximumTarget.value = this.minimumTarget.value
    }

    this.sync()
  }

  updateMaximum() {
    if (Number(this.maximumTarget.value) < Number(this.minimumTarget.value)) {
      this.minimumTarget.value = this.maximumTarget.value
    }

    this.sync()
  }

  sync() {
    const minimum = Number(this.minimumTarget.value)
    const maximum = Number(this.maximumTarget.value)
    const maximumAllowed = Number(this.maximumTarget.max)

    this.valueTarget.textContent = minimum === 0 && maximum === maximumAllowed ? "Any budget" : maximum === maximumAllowed ? `${this.currency(minimum)}+` : `${this.currency(minimum)} – ${this.currency(maximum)}`
    this.inputTarget.value = minimum === 0 && maximum === maximumAllowed ? "" : maximum === maximumAllowed ? `${minimum}-` : `${minimum}-${maximum}`
  }

  currency(value) {
    return `₹${new Intl.NumberFormat("en-IN", { maximumFractionDigits: 0 }).format(value)}`
  }
}
