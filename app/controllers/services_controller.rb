class ServicesController < ApplicationController
  before_action :set_category
  before_action :set_service, only: %i[ show edit update destroy ]

  def index
    @services = Service.all
  end

  def show
  end

  def new
    @service = Service.new
  end

  def edit
    @category = Category.find params[:category_id]
    @service = @category.services.find(params[:id])
  end

  def create
    @category = Category.find params[:category_id]
    @service = @category.services.build service_params

    if @service.save
      flash[:success] = "Service created!"
      redirect_to category_url(@category)
    else
      @services = @category.services.order created_at: :desc
      render 'categories/show'
    end
  end

  def update
    @category = Category.find params[:category_id]
    @service = @category.services.find params[:id]

    if @service.update(service_params)
      flash[:success] = 'Service updated!'
      redirect_to category_url(@category)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy

    flash[:success] = 'Service deleted!'
    redirect_to category_path(@category)
  end

  private

    def set_category
      @category = Category.find params[:category_id]
    end

    def set_service
      @service = Service.find(params[:id])
    end

    def service_params
      params.require(:service).permit(:title, :description, :cost)
    end
end
