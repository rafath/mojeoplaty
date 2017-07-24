module Owner
  attr_reader :user, :employee

  def set_user(account)
    if account.is_employee?
      @user = account.user
      @employee = account
    else
      @user = account
      @employee = nil
    end
  end
end