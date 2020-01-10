class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # t('successfully') instead I18n.t('successfully')
  include AbstractController::Translation

  # User.human_enum_name :status, user.status
  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end
end
