class OtpMailer < ApplicationMailer
  default from: 'info@gtsavingsltd.online'

  def otp_email
    @user = params[:user]
    @otp = params[:otp]
    @url = 'https://localhost:5173/verify-otp'

    mail(
      to: @user.email,
      subject: 'Your GT Savings Verification Code'
    )
  end
end 
