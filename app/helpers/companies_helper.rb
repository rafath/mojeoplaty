module CompaniesHelper

  def vat_types
    {
        'vat-7'=> 'VAT 7',
        'vat-7k'=> 'VAT 7K',
        'vat-0'=> 'Nie dotyczy',
    }.invert
  end

  def tax_types
    {
        'cit-8' => 'CIT-8',
        'pit-5' => 'PIT 5',
        'pit-5l' => 'PIT 5L'
    }.invert
  end
end
