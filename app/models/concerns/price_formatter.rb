module PriceFormatter

  def format_price(value)
    value.is_a?(String) ? value.sub(',', '.') : value
  end
end