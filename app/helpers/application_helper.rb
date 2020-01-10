module ApplicationHelper
  def bootstrap_form_for(object, options = {}, &block)
    options.reverse_merge! builder: MyFormBuilder
    super(object, options, &block)
  end

  def bootstrap_form_with(options = {}, &block)
    options.reverse_merge! builder: MyFormBuilder
    super(options, &block)
  end
end
