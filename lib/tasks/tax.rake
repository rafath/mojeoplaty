require 'rubygems'
require 'csv'

namespace :tax do
  task add: :environment do
    CSV.foreach('db/urzedy_skarbowe_all.csv', col_sep: ';') do |row|
      us, city, code, street, cit, vat, pit, pcc = row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8]
      us = [us, city].join(' ') if us.strip.split.last.downcase == 'skarbowy'

      TaxOffice.create(
          name: us,
          address: street,
          postcode: code,
          city: city,
          vat_account: vat,
          cit_account: cit,
          pit_account: pit,
          pcc_account: pcc.nil? ? '' : pcc.strip
      )
      puts us
    end
  end

  task company_dirs: :environment do
    Company.find_in_batches do |companies|
      companies.each do |company|
        u_dir = "payrolls/#{company.user_id}/"
        Dir.mkdir(u_dir) unless Dir.exist?(u_dir)
        Dir.mkdir("#{u_dir}#{company.id}") unless Dir.exist?("#{u_dir}#{company.id}")
      end
    end
    puts 'done'
  end

end