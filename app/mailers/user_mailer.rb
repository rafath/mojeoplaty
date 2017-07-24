class UserMailer < ApplicationMailer

  def welcome_user(user)
    @user = user
    mail(to: email_with_name(user), subject: 'Twoje konto jest już gotowe!', bcc: 'biuro@mojeoplaty.pl')
  end

  def welcome_employee(employee)
    @employee = employee
    mail(to: email_with_name(employee), subject: 'Twoje konto jest już gotowe!')
  end

  def invitation(email)
    attachments.inline['playme.jpg'] = File.read('app/assets/images/mojeoplaty-play.jpg')
    mail(to: email, subject: 'Gdyby nie problem mojej księgowej, nigdy nie powstałyby MojeOplaty')
  end

end
