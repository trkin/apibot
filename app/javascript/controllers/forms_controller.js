import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    console.log('forms#connect')
  }

  submit_form_ajax(e) {
    var url = $(e.currentTarget).data().ajaxUrl;
    var formData = $(e.currentTarget).parents('form').first().serialize();
    return $.getJSON(url, formData, function(data, textStatus) {
      var id, value;
      for (id in data) {
        value = data[id];
        $("#" + id).val(value);
      }
      return console.log(data);
    }).fail(function(xhr, textStatus, errorMessage) {
      return alert(xhr.responseJSON.error_message);
    });
  };

  data_submit_form_ajax_debounced(e) {
    debounce(this.data_submit_form_ajax(e), 250);
  }
}
