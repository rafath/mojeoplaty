class TaxOffice < ActiveRecord::Base

  include ShortAccount

  scope :by_vat_account, ->(account) { where(vat_account: account).limit(1)  }

  def self.search_by_city(city)
    where(['city ilike ?', "#{city.downcase}%"]).order('city, name').limit(15) || []
  end

  def full_name
    "#{name}, ul. #{address}"
  end

end
