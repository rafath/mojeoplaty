# class SmsMessenger

  def initialize(payment=nil, test=false)
    @test_mode = test
    @payment = payment
  end

  def send_test
    message = SMSApi::SMS::Message::Eco.new(to: '48512778001', body: 'to jest wiadomosc testowa')
    SMSApi::SMS::Client.new(test_mode: @test_mode).send_message!(message)
  end

  def send_zus
    body = 'Skladki ZUS za okres %s ' % @payment.short_period
    body << 'Ub. Spol. %s: %s zl. ' % [@payment.short_account('us'), @payment.us] if @payment.us > 0
    body << 'Ub. zdrow. %s: %s zl. ' % [@payment.short_account('uz'), @payment.uz] if @payment.uz > 0
    body << 'Fund. Pracy %s: %s zl. ' % [@payment.short_account('fp'), @payment.fp] if @payment.fp > 0
    body << 'Termin do %s-go' % @payment.payment_day
    # body << UZ %s: %s zl. FP %s: %s zl. Termin do %d-go' % [@payment.us, @payment.uz, @payment.fp, @payment.payment_day]
    send_sms(body)
  end

  def send_tax
    body = 'Podatek Doch. za okres %s. ' % @payment.short_period
    body << '%s (%s): %s zl. ' % [@payment.company.tax_type.upcase, @payment.company.tax_office.short_account(@payment.company.tax_type.include?('cit') ? 'cit' : 'pit'), @payment.income_tax] if @payment.income_tax > 0
    body << 'PIT-4 (%s): %s zl. ' % [@payment.company.tax_office.short_account('pit'), @payment.pit_4] if @payment.pit_4 > 0
    body << 'PIT-8 (%s): %s zl. ' % [@payment.company.tax_office.short_account('pit'), @payment.pit_8] if @payment.pit_8 > 0
    body << 'Termin do 20-go'
    send_sms(body)
  end

  def send_vat
    if @payment.vat > 0
      body = 'Podatek VAT za okres %s. ' % @payment.short_period
      body << '%s (%s): %s zl.' % [@payment.company.vat_type.upcase, @payment.company.tax_office.short_account('vat'), @payment.vat]
      body << ' Termin do 25-go'
      send_sms(body)
    end
  end

  private

  def send_sms(body)
    if @payment.company.phone.present?
      message = SMSApi::SMS::Message::Eco.new(to: @payment.company.phone, body: body)
      SMSApi::SMS::Client.new(test_mode: @test_mode).send_message!(message)
    end
    body #for test purpose
  end


end