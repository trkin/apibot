import { Controller } from 'stimulus'
const jBox = require('jbox')

export default class extends Controller {
  connect() {
    this._show_message()
  }

  show(event) {
    event.preventDefault()
    this._show_message()
  }

  _show_message() {
    const message = this.data.get('message')
    if (message.length == 0) return
    console.log(`flash_controller connect ${message}`)
    const addClass = this.data.has('alert') ? 'flash-alert' : 'flash-notice'
    // https://stephanwagner.me/jBox/get_started
    new jBox('Notice', {
      autoClose: 10000,
      attributes: {
        x: 'right',
        y: 'bottom',
      },
      stack: true,
      animation: {
        open:'bounce',
        close:'fadeOut',
      },
      content: message,
      addClass: addClass,
    })
  }
}
