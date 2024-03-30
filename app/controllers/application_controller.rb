# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_action :default_request_format

  private

  def default_request_format
    request.format = :json unless params[:format]
  end
end
