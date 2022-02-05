window.cloneElementAndAppendTo = function(templateId, containerId) {
  let template = document.getElementById(templateId)
  let container = document.getElementById(containerId)
  let clone = template.cloneNode(true)  // "deep" clone
  clone.id = null
  clone.style.display = 'block'
  container.appendChild(clone)
  console.log(`cloneElementAndAppendTo(${templateId}, ${containerId})`)
}

window.debounce = function(func, wait, immediate) {
    var timeout;
    timeout = void 0;
    return function() {
      var args, callNow, context, later;
      context = this;
      args = arguments;
      later = function() {
        timeout = null;
        if (!immediate) {
          func.apply(context, args);
        }
      };
      callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) {
        func.apply(context, args);
      }
    };
  };
