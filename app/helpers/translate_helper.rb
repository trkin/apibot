module TranslateHelper
  # t_crud 'edit', User
  # t_crud 'are_you_sure_to_remove_item_name', User
  def t_crud(action, model_class)
    # we are using accusative here
    if action.include? 'item_name'
      t(action, item_name: t('activerecord.models.' + model_class.name.underscore + '.accusative'))
    else
      "#{t(action)} #{t('activerecord.models.' + model_class.name.underscore + '.accusative')}"
    end
  end

  # t_notice 'successfully_created', User
  def t_notice(notice, model_class)
    t("data_item_name_#{notice}", item_name: model_class.model_name.human.titleize)
  end
end
