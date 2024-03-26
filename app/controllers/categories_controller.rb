# frozen_string_literal: true

class CategoriesController < BaseApiController
  before_action :authenticate_admin, only: :create

  def index
    @categories = Category.all.pluck(:name)
    render json: @categories
  end

  def create
    categories = categories_params.map { |name| { name: name } }
    Category.create!(categories)

    head :created
  end

  private

  def categories_params
    params.require(:categories)
  end
end
