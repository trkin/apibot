import { Controller } from 'stimulus'
// https://stephanwagner.me/jBox/options#ajax
const jBox = require('jbox');

export default class extends Controller {
  open() {
    const url = this.data.get('url')
    const title = this.data.get('title')
    // default width is 'auto' (use px or % ie: 200 or 80%)
    const width = 'auto'
    const modal = new jBox('Modal', {
      title: title,
      width: width,
      ajax: {
        url: url,
        reload: 'strict',
        setContent: true,
        complete: function() {
          // we need to reposition when ajax returns
          this.position()
        },
      },
      onCloseComplete: function() {
        const oldModal = document.getElementById(this.options.id)
        oldModal.innerHTML = ''
      },
      addClass: 'jbox-modal',
    })
    modal.open()
    console.log(`modal.open url ${url} title ${title}`)
  }
}
