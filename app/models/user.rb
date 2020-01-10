class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :trackable

  FIELDS = %i[name email password password_confirmation].freeze

  has_many :company_users, dependent: :destroy
  has_many :companies, through: :company_users, dependent: :destroy
  belongs_to :company

  validates :email, presence: true

  def admin_of_a_current_company?
    company_users.admin.where(company: company).present?
    true
  end

  def remove_me_from_company!(target_company)
    if companies.size == 1
      # we will remove the account
      destroy_my_data!
      destroy!
    elsif target_company == company
      company_users.find_by(company: company).destroy!
      self.company = company_users.first.company
      save!
    else
      company_users.find_by(company: company).destroy!
    end
  end

  def destroy_my_data!
    # TODO: gdpr
  end
end
