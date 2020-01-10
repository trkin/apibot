import { Controller } from 'stimulus'

export default class extends Controller {
  add() {
    let selector = this.data.get('selector')
    let elements = this._findElements(selector)
    for (let element of elements) {
      element.classList.add('active')
    }
    console.log(`activate add ${selector}`)
  }

  // <div class='sidebar__overlay' data-controller='activate' data-action='click->activate#toggle' data-activate-selector='#sidebar,.sidebar__overlay'></div>
  // <%= button_tag class: "btn btn-link", 'data-controller': 'activate', 'data-action': 'activate#toggle', 'data-activate-selector': '#sidebar,.sidebar__overlay' do %>
  toggle() {
    let selector = this.data.get('selector')
    let elements = this._findElements(selector)
    for (let element of elements) {
      element.classList.toggle('active')
    }
    console.log(`activate toggle ${selector}`)
  }

  _findElements(selectors) {
    let elements = []
    for (let selector of selectors.split(',')) {
      if (selector[0] == '#') {
        let element_by_id = document.getElementById(selector.substring(1))
        if (element_by_id) elements.push(element_by_id)
      }
      if (selector[0] == '.') {
        let elements_by_class = document.getElementsByClassName(selector.substring(1))
        elements = elements.concat(Array.from(elements_by_class))
      }
    }
    return elements
  }
}
