class Message < ActiveRecord::Base

  def self.create_log(payment, message, source='zus')

    create(
        user_id: payment.company.user_id,
        company_id: payment.company.id,
        source: source,
        recipients: [message.to, message.cc].flatten.compact.join(', '),
        body: message.body.to_s
    ) if message.present?
  end


end
