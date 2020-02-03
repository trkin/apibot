module TextHelper
  def text_with_help_icon(main_text, help_text)
    <<~HTML
      #{main_text}
      <i class="fas fa-info-circle" data-toggle="tooltip" title="#{help_text}"></i>
      <script>initializeJboxTooltip()</script>
    HTML
      .html_safe
  end

  def text_with_edit_icon(text, show_on_hover: false)
    (text +
     " <i class='far fa-edit move-1-px #{'show-on-hover-target' if show_on_hover}' aria-hidden='true'></i> "
    ).html_safe
  end

  def button_with_edit_icon_tag(text, url, modal_title, attrs: {})
    attrs.reverse_merge!(
      'data-modal': url,
      'data-modal-title': modal_title,
      class: 'btn btn-link btn__font-size-inherit white-space-normal show-on-hover',
    )
    # (text + button_tag(text_with_edit_icon('', show_on_hover: true), attrs)).html_safe
    button_tag text_with_edit_icon(text, show_on_hover: true), attrs
  end

  def time_ago_with_tooltip(time)
    return '' if time.blank?

    "<span title='#{time.to_s :short}'>#{t('ago_ago', ago: time_ago_in_words(time))}</span>".html_safe
  end

  def short_time_with_tooltip(time)
    return '' if time.blank?

    "<span title='#{time.to_s :long}'>#{time.to_s :short}</span>".html_safe
  end

  def detail_view_list(item = nil, *fields, label_class: 'col-sm-2 dt__long--min-width', skip_blank: [])
    content_tag 'dl', class: 'row' do
      if block_given?
        yield
      else
        detail_view item, *fields, label_class: label_class, skip_blank: skip_blank
      end
    end
  end

  # if you use two detail views than label_class: 'col-sm-4'
  def detail_view(item, *fields, label_class: 'col-sm-2 dt__long--min-width', skip_blank: [])
    res = fields.map do |field|
      if (skip_blank == :all || skip_blank.include?(field)) && item.send(field).blank? ||
         (item.respond_to?("visible_#{field}") && item.send("visible_#{field}") != true)
        ''.html_safe
      else
        <<~HTML
          <dt class='#{label_class}'>#{item.class.send :human_attribute_name, field}</dt>
          <dd class='col'>#{item.send field}</dd>
          <dt class='w-100'></dt>
        HTML
          .html_safe
      end
    end
    safe_join res
  end

  def detail_view_one(title, text = nil, label_class: 'col-sm-2 dt__long--min-width', text_class: 'col', &block)
    <<~HTML
      <dt class='#{label_class}'>#{title}</dt>
      <dd class='#{text_class}'>#{block_given? ? capture(&block) : text}</dd>
      <dt class='w-100'></dt>
    HTML
      .html_safe
  end

  def class_for_status(status)
    case status
    when 'finished'
      'success'
    when 'in_queue'
      'secondary'
    when 'failed'
      'danger'
    when 'in_progress'
      'warning'
    when ''
      'info'
    else
      'info'
    end
  end

  def badge_for_status(status)
    <<~HTML
      <span class="badge badge-#{class_for_status status}">
        #{t("task_statuses.#{status}")}
      </span>
    HTML
      .html_safe
  end

  def enabled_disabled_label(value, enabled_text: t('yes_label'), disabled_text: t('no_label'))
    if value
      "<span class='badge badge-success'>#{enabled_text}</span>".html_safe
    else
      "<span class='badge badge-danger'>#{disabled_text}</span>".html_safe
    end
  end

  def t_are_you_sure_to_remove_item_name(item_name)
    if android_app?
      nil
    else
      t('are_you_sure_to_remove_item_name', item_name: item_name)
    end
  end

  def button_tag_open_modal(url, text: t('edit'), title: nil, pull_right: false)
    title ||= text
    tag.button(
      'data-controller': 'modal',
      'data-modal-url': url,
      'data-action': 'modal#open',
      'data-modal-title': title,
      class: "btn text-primary #{'edit-button' if pull_right}",
    ) do
      if block_given?
        yield
      else
        tag.i(class: 'demo-icon icon-pencil') + text
      end
    end
  end

  # f.text_field :phone,
  #              help: f.object.a_phone.blank? && add_alternative_helper(User.human_attribute_name(:a_phone), '#a_phone')
  # <div id='a_phone' class='<%= 'd-none-display' if f.object.a_phone.blank? %>'>
  #   <%= f.text_field :a_phone, skip_label: true, placeholder: true %>
  def add_alternative_helper(text, selector)
    <<~HTML
      <div data-controller='activate'
           data-action='click->activate#toggleAndRemoveMe'
           data-activate-selector='#{selector}'
           >
           #{t('add')} #{text}
       </div>
    HTML
      .html_safe
  end

  # For enums you can use User.human_enum_name :status, user.status
end
