import { Controller } from 'stimulus'

export default class extends Controller {
  add() {
    let selector = this.data.get('selector')
    let elements = document.querySelectorAll(selector)
    for (let element of elements) {
      element.classList.add('active')
    }
    console.log(`activate add ${selector}`)
  }

  // <div class='sidebar__overlay' data-controller='activate' data-action='click->activate#toggle' data-activate-selector='#sidebar,.sidebar__overlay'></div>
  // <%= button_tag class: "btn btn-link", 'data-controller': 'activate', 'data-action': 'activate#toggle', 'data-activate-selector': '#sidebar,.sidebar__overlay' do %>
  toggle() {
    let selector = this.data.get('selector')
    let elements = document.querySelectorAll(selector)
    for (let element of elements) {
      element.classList.toggle('active')
    }
    console.log(`activate toggle ${selector}`)
  }


  //  Based on selected value X, find data-activate-selector which data value
  // includes X. In example it is [data-activate-target] (can be any name like
  // [data-activate-my-section] and on target element data can be multiple
  // strings joines by comma ,
  // This works for nested fieldset, and controller can be initialied on parent
  //
  //  <%= f.select :action, StepService::ONE_TIME_ACTIONS + StepService::LOOPED_ACTIONS, {}, 'data-controller': 'activate', 'data-action': 'activate#toggleForValueIncludes', 'data-activate-selector': '[data-activate-target]' %>
  //  <%= content_tag :fieldset, class: "d-none-display #{'active' if StepService::ONE_TIME_ACTIONS.include? f.object.action}", disabled: !StepService::ONE_TIME_ACTIONS.include?(f.object.action), 'data-activate-target': StepService::ONE_TIME_ACTIONS.join(',') do %>
  toggleForValueIncludes(event) {
    let selector = event.currentTarget.getAttribute('data-activate-selector')
    let elements = document.querySelectorAll(selector)
    let value = event.currentTarget.value
    let selectorWithoutBrackets = selector.slice(1, -1)
    for (let element of elements) {
      // instead of camel case element.dataset('activateTarget) we can use
      // element.getAttribute('data-activate-target') (original snake case)
      if (element.getAttribute(selectorWithoutBrackets).split(',').includes(value)) {
        element.classList.add('active')
        if (element.nodeName == 'FIELDSET') element.disabled = false
      } else {
        element.classList.remove('active')
        if (element.nodeName == 'FIELDSET') element.disabled = true
      }
    }
    console.log(`activate toggleForValueIncludes ${selector}`)
  }
}
