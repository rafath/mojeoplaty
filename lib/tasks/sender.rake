require 'rubygems'

namespace :sender do

  task :invitations, [:o] => :environment do |t, args|
    File.readlines('lib/assets/invitations.txt').each do |email|
      UserMailer.invitation(email).deliver_now if args[:o] == '1'
      puts email
      sleep(rand(20..30))
    end

  end
end