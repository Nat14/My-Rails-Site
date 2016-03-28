class PageMailer < ActionMailer::Base

  default to: 'naryucha14@gmail.com'
  
  def contact_email(name, email, body)
    @name = name
    @email = email
    @body = body
    mail(from: email, subject: 'My Site Contact Form Message')
  end
end
