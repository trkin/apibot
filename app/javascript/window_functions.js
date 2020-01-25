function cloneElementAndAppendTo(templateId, containerId) {
  let template = document.getElementById(templateId)
  let container = document.getElementById(containerId)
  let clone = template.cloneNode(true)  // "deep" clone
  clone.id = null
  clone.style.display = 'block'
  container.appendChild(clone)
  console.log(`cloneElementAndAppendTo(${templateId}, ${containerId})`)
}
window.cloneElementAndAppendTo = cloneElementAndAppendTo
