class ZusAmount < ActiveRecord::Base

  include Period
  include EmployeeReferences
  include PriceFormatter
  include MarkAsSent
  include ShortAccount

  belongs_to :user
  belongs_to :employee, class_name: 'User', foreign_key: :employee_id
  belongs_to :company

  %w(us uz fp).each do |field|
    define_method("#{field}=") do |arg|
      write_attribute(field.to_sym, format_price(arg))
    end
  end

  def us_account
    '83 1010 1023 0000 2613 9510 0000'
  end

  def uz_account
    '78 1010 1023 0000 2613 9520 0000'
  end

  def fp_account
    '73 1010 1023 0000 2613 9530 0000'
  end

  def payment_day
    self.company.has_employees ? 15 : 10
  end
end
