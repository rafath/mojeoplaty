module ShortAccount

  def short_account(type)
    # account = self["#{type}_account"].gsub(/\s/, '')
    account = self.method("#{type}_account".to_sym).call.gsub(/\s/, '')
    "#{account[0..1]}..#{account[18..21]}"
  end
end