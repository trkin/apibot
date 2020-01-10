// https://stephanwagner.me/jBox/get_started#tooltips
const jBox = require('jbox');
const trkDatatables = require('trk_datatables')

document.addEventListener('turbolinks:load', () => {
  // add tooltip to all elements with title <a title='Hi'>
  new jBox('Tooltip', {
    attach: '[title]'
  })

  trkDatatables.initialise()
})
