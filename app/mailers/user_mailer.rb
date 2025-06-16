class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  default from: 'info@gtsavingsltd.online'
  
  def welcome_email
    @user = params[:user]
    @url = 'https://localhost:5173/login'
    @greeting = "Hi"

    
    begin
      mail(
        to: @user.email,
        subject: 'Welcome to GT Savings!',
        delivery_method: :resend,
        delivery_method_options: {
          api_key: ENV['RESEND_API_KEY']
        }
      )
    rescue => e
      puts "Failed to send welcome email: #{e.message}"
      puts e.backtrace.join("\n")
    end
  end
end
