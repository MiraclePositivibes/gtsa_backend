class Api::V1::UsersController < ApplicationController
  include JsonWebToken
  before_action :authenticate_request, except: [ :create, :update_current, :update, :show ]

  rescue_from 'Not authenticated' do |exception|
    render json: { errors: [exception.message] }, status: :unauthorized
  end

# POST /api/v1/users
  def create
    @user = User.new(user_params)
    # ... save the user and associated account
    if @user.save
      @user.create_account # Automatically create associated account
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 20.minutes.to_i
      # Send welcome email
      begin
        UserMailer.with(user: @user).welcome_email.deliver_now
      rescue => e
      end
      render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M'), user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users
  def index
    @users = User.all
    render json: @users, include: :account, status: :ok, only: [:id, :email, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at, :home_address, :PIN, :status]
  end

  # GET /api/v1/users/me
  def show_current
    authenticate_request
    if @decoded[:user_id]
      @user = User.find(params[:id])
      render json: @user, include: :account, status: :ok, only: [ :id, :email, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at, :home_address, :PIN, :status]
    else
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

# # GET /api/v1/users/:id
  def show
    authenticate_request
    if @decoded[:user_id]
      @user = User.find(@decoded[:user_id])
      render json: @user, include: :account, status: :ok, only: [:id, :email, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at, :home_address, :PIN, :status]
    else
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  # PUT /api/v1/users/me
  def update_current
    authenticate_request
    if @decoded[:user_id]
      @user = User.find(@decoded[:user_id])
      if @user.update(user_params)
        render json: @user, include: :account, status: :ok, only: [:id, :email, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at, :home_address, :PIN, :status]
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  # PUT /api/v1/users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user, include: :account, status: :ok, only: [:id, :email, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at, :home_address, :PIN, :status]
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    if params[:user].present?
      params.require(:user).permit(:id, :email, :password_confirmation, :password, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at, :home_address, :PIN, :status, account: [:savings_account, :investment, :earnings, :stakes])
    else
      params.permit(:id, :email, :password_confirmation, :password, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at, :home_address, :PIN, :status, account: [:savings_account, :investment, :earnings, :stakes])
    end
  end

  def authenticate_request
    puts "Headers: #{request.headers}"
    result = JsonWebToken.authenticate_request(request)
    puts "Result: #{result}"
    if result[:errors]
      render json: { errors: result[:errors] }, status: result[:status]
    else
      @decoded = result
    end
  end
end
