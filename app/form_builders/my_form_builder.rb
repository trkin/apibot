class MyFormBuilder < BootstrapForm::FormBuilder
  # this will overwrite all f.submit form helpers. data-disable-with does not
  # work with input so I need to use button. Copy lines from
  # https://github.com/rails/rails/blob/master/actionview/lib/action_view/helpers/form_helper.rb#L2428
  # This patch does not work well when responding with csv so there you should explicitly disable:
  # <%= f.submit "Generate CSV", 'data-disable-with': nil %>
  def submit(value = nil, options = {})
    if value.is_a?(Hash)
      options = value
      value = nil
    end
    value ||= '<i class="demo-icon icon-floppy"></i> '.html_safe + submit_default_value
    text_without_first_i_tag = value.split(/^\<i.*?\/i\>/).last
    options.reverse_merge! 'data-disable-with': "<i class='demo-icon icon-spin2 animate-spin'></i> #{text_without_first_i_tag}"
    button(value, options)
  end

  def text_field_for_amount(method, options = {})
    if Money.default_formatting_rules[:symbol_position] == :after
      options[:append] = Money.default_currency.to_s
    else
      options[:prepend] = Money.default_currency.to_s
    end
    text_field method, options
  end
end
