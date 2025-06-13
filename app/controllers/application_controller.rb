class ApplicationController < ActionController::API
  include JsonWebToken

  def current_user
    @current_user ||= begin
      header = request.headers['Authorization']
      token = header.split(' ').last if header
      decoded = JsonWebToken.decode(token)
      User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      nil
    end
  end

  def authenticate_request
    unless current_user
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end
end
