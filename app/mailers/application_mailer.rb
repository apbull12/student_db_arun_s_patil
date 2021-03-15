class ApplicationMailer < ActionMailer::Base
  default from: 'arun.s.patil@kreatio.com'
  layout 'mailer'

  def send_registration_link(email)
    # @user = params[:user]
    mail(to: email, subject: 'Welcome to Our Student Master APP')
  end
end
