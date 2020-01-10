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
    return '' unless time.present?

    "<span title='#{time.to_s :long}'>#{time.to_s :short}</span>".html_safe
  end

  def detail_view_list(item, *fields, label_class: 'col-sm-2 dt__long--min-width')
    content_tag 'dl', class: 'row' do
      detail_view item, *fields, label_class: label_class
    end
  end

  # if you use two detail views than label_class: 'col-sm-4'
  def detail_view(item, *fields, label_class: 'col-sm-2')
    res = fields.map do |field|
      <<~HTML
        <dt class='#{label_class}'>#{item.class.send :human_attribute_name, field}</dt>
        <dd class='col'>#{item.send field}</dd>
        <dt class='w-100'></dt>
      HTML
        .html_safe
    end
    safe_join res
  end

  def detail_view_one(title, text, label_class: 'col-sm-2', text_class: 'col')
    <<~HTML
      <dt class='#{label_class}'>#{title}</dt>
      <dd class='#{text_class}'>#{text}</dd>
      <dt class='w-100'></dt>
    HTML
      .html_safe
  end

  def class_for_status(status)
    case status
    when 'unassigned'
      'success'
    when 'completed'
      'secondary'
    when 'cancelled_by_project', 'blocked'
      'danger'
    when 'relinquished'
      'warning'
    when 'accepted'
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
end
