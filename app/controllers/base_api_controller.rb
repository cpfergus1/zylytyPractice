# frozen_string_literal: true

class BaseApiController < ApplicationController
  rescue_from StandardError, with: :truncated_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  before_action :authorize_request

  def logged_in?
    !!current_user
  end

  def token
    request.cookies['sessionId']
  end

  def user_id
    decoded_token.first['user_id']
  end

  def admin_token
    request.headers['Authorization']
  end

  def admin?
    admin_token == ENV['ADMIN_API_KEY']
  end

  def current_user
    @user ||= User.find_by(id: user_id)
  end

  def jwt_secret
    Rails.application.credentials.jwt_secret
  end

  def issue_token(user)
    JWT.encode({ user_id: user.id, exp: Time.now.to_i + 1.hour }, jwt_secret, 'HS256')
  end

  def decoded_token
    JWT.decode(token, jwt_secret, true, { algorithm: 'HS256' })
  rescue JWT::DecodeError
    [{ error: "Invalid Token" }]
  end

  protected

  def truncated_error(errors)
    error_info = []
    errors = errors.is_a?(Array) ? errors.take(10) : [errors]
    errors.each do |error|
      error_info << { error: "Bad Request", exception: "#{error.class.name} : #{error.message}" }
    end

    render json: error_info.to_json, status: :bad_request
  end

  def record_not_found
    head :not_found
  end

  def record_invalid
    head :bad_request
  end

  private

  def authorize_request
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in? || admin?
  end

  def authenticate_admin
    render json: { message: 'Unauthorized' }, status: :unauthorized unless admin?
  end
end
