class Company < ActiveRecord::Base

  include PhoneFormat

  belongs_to :user
  belongs_to :tax_office

  has_and_belongs_to_many :employees, join_table: 'companies_employees', association_foreign_key: 'employee_id'

  has_many :tax_amounts
  has_one :current_tax_amount, -> { where('tax_amounts.period=?', TaxAmount.current_period) }, class_name: 'TaxAmount'

  has_many :payrolls
  has_one :payroll, -> { where('payrolls.period=?', Payroll.next_period) }, class_name: 'Payroll'

  has_many :zus_amounts
  has_one :current_zus_amount, -> { where('zus_amounts.period=?', ZusAmount.current_period) }, class_name: 'ZusAmount'
  has_one :before_current_zus_amount, -> { where('zus_amounts.period=?', ZusAmount.before_current_period) }, class_name: 'ZusAmount'

  validates :tax_office_id, presence: true
  validates :name, presence: true
  validates :nip, presence: true

  default_scope { where(is_deleted: false).order('name') }

  before_create :set_token
  after_create :create_company_dir

  scope :by_nip, ->(nip) { where(nip: nip.gsub(/[-\.\s]/, '')).limit(1) }
  scope :with_employees, -> { where(has_employees: true) }
  scope :by_token, ->(token) { where(token: token).limit(1) }

  def set_token
    self.token = Digest::MD5.hexdigest("#{self.nip}+#{self.user.nip}#{Time.now.to_s}")
  end

  def nip=(val)
    self['nip'] = val.gsub(/[-\.\s]/, '')
  end

  def formatted_nip
    [nip[0..2], nip[3..5], nip[6..7], nip[8..9]].join('-')
  end

  def vat_7k?
    self.vat_type == 'vat-7k'
  end

  def create_company_dir
    user_dir = "payrolls/#{self.user_id}"
    Dir.mkdir(user_dir) unless Dir.exist?(user_dir)
    Dir.mkdir("#{user_dir}/#{self.id}") unless Dir.exist?("#{user_dir}/#{self.id}")
  end

end
