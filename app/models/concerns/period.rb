module Period
  extend ActiveSupport::Concern

  #period is always for previous month (not current)

  included do
    scope :by_period, ->(date) { where('period=?', date).limit(1).first }
    scope :by_company_and_period, ->(company) { where(company_id: company, period: ZusAmount.current_period).limit(1) }

    before_save :assign_period
  end

  class_methods do
    def last_month
      @date ||= Time.now.last_month
    end

    def current_period
      last_month.strftime('%Y-%m-01')
    end

    def before_current_period
      (last_month-1.months).strftime('%Y-%m-01')
    end

    def next_period
      Time.now.strftime('%Y-%m-01')
    end
  end

  def assign_period
    self.period = self.class.current_period if period.blank?
  end

  def short_period
    sprintf('%02d-%d', period.month, period.year)
  end

end