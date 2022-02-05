class SignUpCompanyForm
  include ActiveModel::Model

  FIELDS = %i[company name email password enable_sign_up].freeze
  attr_accessor(*FIELDS)
  attr_accessor :user
  validates(*FIELDS, presence: true)

  def save
    return false unless valid?

    new_company = Company.new name: company
    new_company.enable_sign_up = enable_sign_up if Const.first_company.nil?
    @user = User.new email: email, password: password, password_confirmation: password, company: new_company
    @user.skip_confirmation! if User.all.count.zero? # this will just add confirmed_at = Time.now
    unless @user.save
      errors.add(:email, @user.errors[:email].to_sentence) if @user.errors[:email].present?
      errors.add(:password, @user.errors[:password].to_sentence) if @user.errors[:password].present?
      return false
    end

    @user.company_users.create! company: new_company, position: CompanyUser.positions[:admin]
    true
  end
end
