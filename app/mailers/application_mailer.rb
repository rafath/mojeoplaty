class ApplicationMailer < ActionMailer::Base

  default from: 'Rafath z MojeOplaty.pl <biuro@mojeoplaty.pl>'
  layout 'mailer'

  helper ApplicationHelper

  private

  def email_with_name(resource)
    "#{resource.full_name} <#{resource.email}>"
  end

  def save_message(source, recipients, subject, body)
    Message.create(
      source: source,
      recipients: recipients,
      subject: subject,
      body: body
    )
  end
end
