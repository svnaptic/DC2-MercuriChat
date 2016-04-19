class UserMailer < ApplicationMailer
  # Referenced from: http://guides.rubyonrails.org/action_mailer_basics.html
  default from: 'user_name@example.com'

  def welcome_email(user)
  	# Referenced from: http://guides.rubyonrails.org/action_mailer_basics.html
    @user = user
    @url  = 'localhost:3000/sign_in'
    mail(to: @user.email, subject: 'Welcome to MercuriChat!')
  end
end
