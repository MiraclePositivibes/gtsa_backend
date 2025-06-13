class User < ApplicationRecord
    has_secure_password
    has_one :account, dependent: :destroy
    before_save :set_address
    before_create :generate_account_number
    accepts_nested_attributes_for :account
    has_many :transactions, dependent: :destroy

    def create_account
      build_account(savings_account: 0.00, investment: 0.00, earnings: 0.00, stakes: 0.00).save
    end
    
  validates :email, presence: true, uniqueness: true, on: :create
  validates :password, presence: true, on: :create
  validates :first_name, presence: true, on: :create
  validates :last_name, presence: true, on: :create
  validates :date_of_birth, presence: true, on: :create
  validates :phone_number, presence: true, on: :create
  validates :city, presence: true, on: :create
  validates :state, presence: true, on: :create
  validates :country, presence: true, on: :create

  private

  def set_address
    self.address = "#{city}, #{state}, #{country}"
  end

  def generate_account_number
    self.account_number = rand(1_000_000_000..9_999_999_999)
  end
end
