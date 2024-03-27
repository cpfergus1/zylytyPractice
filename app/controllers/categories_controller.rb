# frozen_string_literal: true

class CategoriesController < BaseApiController
  before_action :authenticate_admin, only: [:create, :destroy]
  rescue_from ActiveRecord::RecordNotFound do
    record_invalid if params[:action] == "destroy"
  end

  def index
    @categories = Category.all.pluck(:name)
    render json: @categories
  end

  def create
    categories = categories_params.map { |name| { name: name } }
    Category.create!(categories)

    head :created
  end

  def destroy
    @category = Category.find_by!(name: params[:category])
    return head :bad_request if @category.name == 'Default'

    head :no_content if @category.destroy
  end

  private

  def categories_params
    params.require(:categories)
  end
end
