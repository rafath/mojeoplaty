class Payroll < ActiveRecord::Base

  include Period
  include EmployeeReferences
  include MarkAsSent

  belongs_to :user
  belongs_to :employee, class_name: 'User', foreign_key: :employee_id
  belongs_to :company

  # after_initialize do
  #   if self.new_record?
  #     self.period = Payroll.next_period
  #     self.filename = "payroll_#{Payroll.next_period[0,5]}"
  #   end
  # end

  def assign_period
    self.period ||= Payroll.next_period
  end

  def file_path
    File.join('payrolls', self.user.id.to_s, self.company.id.to_s, self.filename)
  end

  def download_filename
    "lista_plac_#{self.period.to_s[0,7]}#{File.extname(self.filename)}"
  end

end
