class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]

  def index
    @categories = Category.all
  end

  def show
    @service = @category.services.build
    @services = @category.services.order created_at: :desc
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = 'Category created!'
      redirect_to category_url(@category)
    else
      render :new, status: :unprocessable_entity
    end

  end

  def update
    if @category.update(category_params)
      flash[:success] = 'Category updated!'
      redirect_to category_url(@category)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    flash[:success] = 'Category deleted!'
    redirect_to categories_url
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:title)
    end
end
