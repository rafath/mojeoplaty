module EmployeeReferences
  extend ActiveSupport::Concern

  included do
    before_save :assign_employee_reference
  end

  def assign_employee_reference
    if user.present? and user.is_employee?
      self.employee_id = user.id
      self.user_id = user.owner
    end
  end

end