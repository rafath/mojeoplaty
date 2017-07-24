module PhoneFormat
  extend ActiveSupport::Concern

  included do
    before_save :set_phone_format
  end

  def set_phone_format
    if self.phone.present?
      self.phone = self.phone.gsub(/[\s\.\-\+]/, '')
      self.phone = "48#{phone}" if phone.match('^48').nil?
    end
  end

end