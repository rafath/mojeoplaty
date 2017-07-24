class TaxAmount < ActiveRecord::Base

  include Period
  include EmployeeReferences
  include PriceFormatter
  include MarkAsSent

  belongs_to :user
  belongs_to :employee, class_name: 'User', foreign_key: :employee_id
  belongs_to :company

  %w(vat income_tax pit_4 pit_8).each do |field|
    define_method("#{field}=") do |arg|
      # self["#{field}"] = format_price(arg)
      write_attribute(field.to_sym, format_price(arg))
    end
  end

  def mark_as_vat_sent
    update_attribute(:is_sent_vat, true)
  end

end
