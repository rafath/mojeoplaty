require 'rubygems'

namespace :payments do

  task :send_all, [:o] => :environment do |t, args|
    Rake::Task['payments:zus'].invoke(args[:o])
    Rake::Task['payments:tax'].invoke(args[:o])
    Rake::Task['payments:vat'].invoke(args[:o])
    Rake::Task['payments:payrolls'].invoke(args[:o])
  end

  task :zus, [:o] => :environment do |t, args|
    counter = 0
    ZusAmount.where('NOT is_sent AND period=?', ZusAmount.current_period).includes(:company).find_in_batches do |payments|
      payments.each do |payment|
        if args[:o] == '1'
          if payment.company.email.present?
            pdf = ZusPdfRenderer.new(payment)
            pdf.render_file unless pdf.rendered?
            message = PaymentsMailer.zus(payment, pdf.dest_file).deliver_now
            Message.create_log(payment, message, 'zus-task')
            payment.mark_as_sent
          else
            SmsMessenger.send_zus(payment)
          end
          counter += 1
        else
          puts payment.company.email
        end
      end
    end
    send_report(counter, 'zus')
  end

  task :tax, [:o] => :environment do |t, args|
    counter = 0
    TaxAmount.where('NOT is_sent AND period=?', TaxAmount.current_period).includes(:company).find_in_batches do |payments|
      payments.each do |payment|
        if args[:o] == '1'
          pdf = TaxPdfRenderer.new(payment)
          pdf.render_file unless pdf.rendered?
          message = PaymentsMailer.tax(payment, pdf.dest_file).deliver_now
          Message.create_log(payment, message, 'tax-task')
          payment.mark_as_sent
          counter += 1
        else
          puts payment.company.email
        end
      end
    end
    send_report(counter, 'tax')
  end

  task :vat, [:o] => :environment do |t, args|
    counter = 0
    TaxAmount.where('NOT is_sent_vat AND period=?', TaxAmount.current_period).includes(:company).find_in_batches do |payments|
      payments.each do |payment|
        if args[:o] == '1'
          pdf = VatPdfRenderer.new(payment)
          pdf.render_file unless pdf.rendered?
          message = PaymentsMailer.vat(payment, pdf.dest_file).deliver_now
          Message.create_log(payment, message, 'vat-task')
          payment.mark_as_vat_sent
        else
          puts payment.company.email
        end
      end
    end
    send_report(counter, 'vat')
  end

  task :payrolls, [:o] => :environment do |t, args|
    counter = 0
    Payroll.where('NOT is_sent AND period=?', Payroll.next_period).includes(:company).find_in_batches do |payrolls|
      payrolls.each do |payroll|
        if args[:o] == '1'
          message = PaymentsMailer.payroll(payroll).deliver_now
          Message.create_log(payroll, message, 'payroll-task')
          payroll.mark_as_sent
          counter += 1
        else
          puts payroll.company.email
        end
      end
    end
    send_report(counter, 'payroll')
  end

  def send_report(counter, source)
    PaymentsMailer.report(counter, source).deliver_now
  end

end