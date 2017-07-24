class Employee < ActiveRecord::Base

  self.table_name = 'users'

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  scope :by_owner, ->(id) { where(owner: id) }
  default_scope { where('owner > 0').order('lastname') }

  validates :email, uniqueness: true, length: {minimum: 5}, format: {with: /\A([-a-z0-9_+\.]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}, presence: true
  validates :firstname, length: {minimum: 3}, presence: true
  validates :lastname, length: {minimum: 3}, presence: true
  validates :plain_pass, length: {minimum: 6}, presence: true

  belongs_to :user, class_name: 'User', foreign_key: :owner #-> {where(parent: 0, id: self.owner)}

  has_and_belongs_to_many :companies, join_table: 'companies_employees'

  has_many :zus_amounts #, foreign_key: :employee_id
  has_many :tax_amounts
  has_many :payrolls

  before_save :set_password

  def set_password
    self.password = self.plain_pass
    self.password_confirmation = self.plain_pass
  end

  def password_required?
    false
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def is_employee?
    true
  end

end
