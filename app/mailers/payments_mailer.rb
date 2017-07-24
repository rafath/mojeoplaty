class PaymentsMailer < ApplicationMailer

  attr_accessor :recipient

  def zus(payment, file, recipient=nil)
    if payment.present?
      @payment = payment
      set_recipient(recipient)
      attachments['druki-zus.pdf'] = File.read(file)
      send_email(payment, "Składki ZUS za okres #{payment.short_period}")
    end
  end

  def tax(payment, file, recipient=nil)
    if payment.present?
      @payment = payment
      set_recipient(recipient)
      attachments['podatki.pdf'] = File.read(file)
      send_email(payment, "Podatek Dochodowy za okres #{payment.short_period}")
    end
  end

  def vat(payment, file, recipient=nil)
    if payment.present?
      @payment = payment
      set_recipient(recipient)
      attachments['vat.pdf'] = File.read(file)
      send_email(payment, "Podatek VAT za okres #{payment.short_period}")
    end
  end

  def payroll(payroll, recipient=nil)
    if payroll.present?
      @payroll = payroll
      set_recipient(recipient)
      attachments['lista-plac.pdf'] = File.read(payroll.file_path)
      send_email(payroll, "Lista Płac za okres #{payroll.short_period}")
    end
  end

  def report(counter, task)
    mail(to: 'rafath@mojeoplaty.pl', subject: "Raport z wysyłki [#{task}:#{counter}]", body: 'no txt')
  end

  private

  def set_recipient(recipient)
    @recipient = recipient if recipient.present?
  end

  def send_email(payment, subject)
    email_settings = {}
    email_settings[:subject] = subject
    if @recipient
      email_settings[:to] = @recipient
    else
      email_settings[:to] = payment.company.email
      email_settings[:cc] = payment.company.cc_emails if payment.company.cc_emails.present?
    end
    email_settings[:bcc] = 'ghost@mojeoplaty.pl'
    # puts email_settings
    mail(email_settings) if email_settings[:to].present?
  end

end
